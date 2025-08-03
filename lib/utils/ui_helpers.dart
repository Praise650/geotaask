// ui_helpers.dart
import 'package:flutter/material.dart';

class UIHelpers {
  static Future<T?> showCustomBottomSheet<T>(
    BuildContext context, {
    required Widget child,
  }) async {
    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      //todo: add bottomsheet layout
      builder: (context) =>  child
    );
  }

  static void showCustomDialog(
    BuildContext context,
    String title,
    String content,
  ) {}

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
