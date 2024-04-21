import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(
    BuildContext context, {
    required String message,
  }) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
