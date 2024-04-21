import 'package:flutter/material.dart';
import 'package:syncer/screens/client_screen.dart';
import 'package:syncer/screens/main_screen.dart';
import 'package:syncer/screens/server_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light()
          .copyWith(cardTheme: const CardTheme(margin: EdgeInsets.zero)),
      routes: {
        ClientScreen.route: (context) => const ClientScreen(),
        MainScreen.route: (context) => const MainScreen(),
        ServerScreen.route: (context) => const ServerScreen(),
      },
    );
  }
}
