import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:syncer/models/syncer_service.dart';
import 'package:syncer/utils/constants.dart';
import 'package:syncer/utils/utils.dart';
import 'package:syncer/widgets/syncer_scaffold.dart';
import 'package:syncer/widgets/syncer_service_list_tile.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  static const route = '/client';

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final _discovery = BonsoirDiscovery(type: Constants.serviceIdentifier);

  final _services = <String, SyncerService>{};

  io.Socket? _client;

  void _clearClient() {
    _client?.dispose();

    setState(() {
      _client = null;
    });
  }

  Widget _getConnectedServerCard() {
    return Card(
      child: _client == null
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.close, color: Colors.red, size: 20),
                  SizedBox(width: 16),
                  Expanded(child: Text('Not connected to any server.')),
                ],
              ),
            )
          : const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check, color: Colors.green, size: 20),
                      SizedBox(width: 16),
                      // TODO: fix, add info
                      Expanded(child: Text('Connected to server.')),
                    ],
                  ),
                ),
                // TODO: fix, server info
                // SyncerServiceListTile(
                //   onTap: null,
                //   syncerService: syncerService,
                // ),
              ],
            ),
    );
  }

  Widget _getServersCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Builder(
        builder: (context) {
          if (_services.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No servers found to connect to.'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Available servers (${_services.length.toStringAsFixed(0)}):',
                ),
              ),
              ..._services.values.map((e) {
                return SyncerServiceListTile(
                  syncerService: e,
                  onTap: () {
                    _initClient(syncerService: e);
                  },
                );
              })
            ],
          );
        },
      ),
    );
  }

  Future<void> _initBonsoir() async {
    // TODO: fix, extract

    await _discovery.ready;

    _discovery.eventStream!.listen((event) async {
      if (event.service == null) {
        return;
      }

      final newService = SyncerService.fromBonsoirService(event.service!);

      switch (event.type) {
        case BonsoirDiscoveryEventType.discoveryServiceFound:
          final foundService = _services[newService.ip];

          if (foundService != null &&
              foundService.publishedAt.isAfter(newService.publishedAt)) {
            return;
          }

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

  void _initClient({
    required SyncerService syncerService,
  }) {
    // TODO: fix, extract

    _clearClient();

    final client = io.io(
      'http://${syncerService.ip}:${syncerService.port.toStringAsFixed(0)}',
      io.OptionBuilder()
          .disableReconnection()
          .enableForceNewConnection()
          .setExtraHeaders(
            {
              // TODO: fix, password
              'password': '123',
            },
          )
          .setTimeout(2000)
          .setTransports(['websocket'])
          .build(),
    );

    client.onConnect((_) {
      setState(() {
        _client = client;
      });
    });

    client.onConnectError((e) async {
      _clearClient();

      await Utils.showAlertDialog(
        context,
        title: 'Error connecting to server',
        content: e.toString(),
      );
    });

    client.onDisconnect((e) {
      _clearClient();
    });

    client.on('event', (data) {
      // TODO: fix, handle messages
    });
  }

  @override
  void initState() {
    super.initState();

    _initBonsoir();
  }

  @override
  void dispose() {
    _discovery.stop();
    _client?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SyncerScaffold(
      title: 'Client',
      children: [
        _getServersCard(),
        const SizedBox(height: 16),
        _getConnectedServerCard(),
      ],
    );
  }
}
