import 'dart:io';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:syncer/models/syncer_service.dart';
import 'package:syncer/utils/constants.dart';
import 'package:syncer/utils/utils.dart';
import 'package:windows_network_adapter_info/windows_network_adapter_info.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key});

  static const route = '/server';

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  BonsoirBroadcast? _broadcast;

  final _windowsNetworkAdapterInfo = WindowsNetworkAdapterInfo();

  Widget _getContent() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: _broadcast?.ready,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const Text('Waiting for client connection.');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<void> _initBonsoir() async {
    final adapters = await _windowsNetworkAdapterInfo.getInfo();

    final index = adapters
        .indexWhere((element) => element.ipAddress.startsWith('192.168.'));
    if (index == -1) {
      if (mounted) {
        Utils.showSnackBar(context, message: 'No local IP found.');
      }

      return;
    }

    final service = SyncerService(
      hostname: Platform.localHostname,
      ip: adapters[index].ipAddress,
      name: 'Syncer Service',
      port: Constants.port,
      type: Constants.serviceIdentifier,
    ).toBonsoirService();

    setState(() {
      _broadcast = BonsoirBroadcast(service: service);
    });

    await _broadcast?.ready;
    await _broadcast?.start();
  }

  @override
  void initState() {
    super.initState();

    _initBonsoir();
  }

  @override
  void dispose() {
    _broadcast?.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Server')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _getContent(),
            ),
          ),
        ],
      ),
    );
  }
}
