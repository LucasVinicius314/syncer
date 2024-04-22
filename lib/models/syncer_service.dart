import 'package:bonsoir/bonsoir.dart';

class SyncerService {
  SyncerService({
    required this.hostname,
    required this.ip,
    required this.name,
    required this.os,
    required this.port,
    required this.publishedAt,
    required this.type,
  });

  String hostname;
  String ip;
  String name;
  String os;
  int port;
  DateTime publishedAt;
  String type;

  factory SyncerService.fromBonsoirService(BonsoirService service) {
    return SyncerService(
      hostname: service.attributes['hostname'] ?? '',
      ip: service.attributes['ip'] ?? '',
      name: service.name,
      os: service.attributes['os'] ?? '',
      port: int.parse(service.attributes['port'] ?? '0'),
      publishedAt: DateTime.fromMillisecondsSinceEpoch(
        int.parse(service.attributes['publishedAt'] ?? '0'),
        isUtc: true,
      ),
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
        'os': os,
        'port': port.toStringAsFixed(0),
        'publishedAt': publishedAt.millisecondsSinceEpoch.toStringAsFixed(0),
      },
    );
  }
}
