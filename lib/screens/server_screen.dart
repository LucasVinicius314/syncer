import 'dart:io';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:socket_io/socket_io.dart' as io;
import 'package:syncer/models/syncer_service.dart';
import 'package:syncer/utils/constants.dart';
import 'package:syncer/utils/utils.dart';
import 'package:syncer/widgets/loading_indicator.dart';
import 'package:syncer/widgets/syncer_scaffold.dart';
import 'package:windows_network_adapter_info/windows_network_adapter_info.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({super.key});

  static const route = '/server';

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  final _windowsNetworkAdapterInfo = WindowsNetworkAdapterInfo();

  final _server = io.Server();

  final _clients = <Socket>[];

  BonsoirBroadcast? _broadcast;

  Widget _getClientsCard() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
                'Connected clients (${_clients.length.toStringAsFixed(0)}):'),
          ),
          if (_clients.isEmpty)
            const Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Text('No clients connected.'),
            )
          else
            ..._clients.map((e) {
              return ListTile(title: Text(e.address.toString()));
            }),
        ],
      ),
    );
  }

  Widget _getStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: _broadcast?.ready,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const Row(
                children: [
                  Icon(Icons.check, color: Colors.green, size: 20),
                  SizedBox(width: 16),
                  Expanded(child: Text('Accepting client connections.')),
                ],
              );
            }

            return Row(
              children: [
                LoadingIndicator.small(),
                const SizedBox(width: 16),
                const Expanded(child: Text('Initializing.')),
              ],
            );
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
      os: Platform.operatingSystem,
      port: Constants.port,
      publishedAt: DateTime.now(),
      type: Constants.serviceIdentifier,
    ).toBonsoirService();

    setState(() {
      _broadcast = BonsoirBroadcast(service: service);
    });

    await _broadcast?.ready;
    await _broadcast?.start();
  }

  Future<void> _initServer() async {
    // TODO: fix, extract

    _server.onconnection((client) {
      client.on('msg', (data) {
        // TODO: fix, handle messages
      });
    });

    await _server.listen(Constants.port);
  }

  @override
  void initState() {
    super.initState();

    _initBonsoir();
    _initServer();
  }

  @override
  void dispose() {
    _broadcast?.stop();
    _server.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SyncerScaffold(
      title: 'Server',
      children: [
        _getStatusCard(),
        const SizedBox(height: 16),
        _getClientsCard(),
      ],
    );
  }
}
