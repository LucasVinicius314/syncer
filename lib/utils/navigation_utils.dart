import 'package:flutter/material.dart';

class NavigationUtils {
  static Future<dynamic> pushNamed(
    BuildContext context, {
    required String routeName,
  }) async {
    return await Navigator.of(context).pushNamed(routeName);
  }
}
