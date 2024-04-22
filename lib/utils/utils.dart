import 'package:flutter/material.dart';

class Utils {
  static Future<void> showAlertDialog<T>(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            OutlinedButton(
              onPressed: () async {
                await Navigator.of(context).maybePop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  static void showSnackBar(
    BuildContext context, {
    required String message,
  }) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
