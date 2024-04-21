import 'package:flutter/material.dart';
import 'package:syncer/screens/client_screen.dart';
import 'package:syncer/screens/server_screen.dart';
import 'package:syncer/utils/navigation_utils.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mode')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ElevatedButton(
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
                    child: ElevatedButton(
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
            ),
          ),
        ],
      ),
    );
  }
}
