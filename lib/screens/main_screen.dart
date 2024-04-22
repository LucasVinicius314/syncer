import 'package:flutter/material.dart';
import 'package:syncer/screens/client_screen.dart';
import 'package:syncer/screens/server_screen.dart';
import 'package:syncer/utils/navigation_utils.dart';
import 'package:syncer/widgets/syncer_scaffold.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return SyncerScaffold(
      title: 'Syncer - Pick Mode',
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  await NavigationUtils.pushNamed(
                    context,
                    routeName: ClientScreen.route,
                  );
                },
                child: const Text('Client'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  await NavigationUtils.pushNamed(
                    context,
                    routeName: ServerScreen.route,
                  );
                },
                child: const Text('Server'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
