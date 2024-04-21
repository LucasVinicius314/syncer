import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:syncer/models/syncer_service.dart';
import 'package:syncer/utils/constants.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  static const route = '/client';

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final _discovery = BonsoirDiscovery(type: Constants.serviceIdentifier);

  final _services = <String, SyncerService>{};

  Widget _getContent() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (context) {
            if (_services.isEmpty) {
              return const Text('No hosts found to connect to.');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _services.values.map((e) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(e.hostname),
                    Text(e.ip),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Future<void> _initBonsoir() async {
    await _discovery.ready;

    _discovery.eventStream!.listen((event) {
      if (event.service == null) {
        return;
      }

      final newService = SyncerService.fromBonsoirService(event.service!);

      switch (event.type) {
        case BonsoirDiscoveryEventType.discoveryServiceFound:
          setState(() {
            _services[newService.ip] = newService;
          });
          break;
        case BonsoirDiscoveryEventType.discoveryServiceLost:
          setState(() {
            _services.remove(newService.ip);
          });
          break;
        default:
      }
    });

    await _discovery.start();
  }

  @override
  void initState() {
    super.initState();

    _initBonsoir();
  }

  @override
  void dispose() {
    _discovery.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Client')),
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
