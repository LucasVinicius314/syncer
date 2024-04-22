import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncer/models/syncer_service.dart';

class SyncerServiceListTile extends StatelessWidget {
  const SyncerServiceListTile({
    super.key,
    required this.onTap,
    required this.syncerService,
  });

  final void Function()? onTap;
  final SyncerService syncerService;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${syncerService.hostname} - ${syncerService.os}'),
      subtitle: Text(syncerService.ip),
      trailing: Text(
        DateFormat('yyyy-MM-dd – kk:mm:ss').format(syncerService.publishedAt),
      ),
      onTap: onTap,
    );
  }
}
