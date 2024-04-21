import 'package:bonsoir/bonsoir.dart';

class SyncerService {
  SyncerService({
    required this.hostname,
    required this.ip,
    required this.name,
    required this.port,
    required this.type,
  });

  String hostname;
  String ip;
  String name;
  int port;
  String type;

  factory SyncerService.fromBonsoirService(BonsoirService service) {
    return SyncerService(
      hostname: service.attributes['hostname'] ?? '',
      ip: service.attributes['ip'] ?? '',
      name: service.name,
      port: int.parse(service.attributes['port'] ?? '0'),
      type: service.type,
    );
  }

  BonsoirService toBonsoirService() {
    return BonsoirService(
      name: name,
      type: type,
      port: port,
      attributes: {
        'hostname': hostname,
        'ip': ip,
        'port': port.toStringAsFixed(0),
      },
    );
  }
}
