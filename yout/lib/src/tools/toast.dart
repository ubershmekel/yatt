import 'package:flutter/material.dart';

class Toast {
  static toast(BuildContext context, String message) {
    if (!context.mounted) {
      // Check `context.mounted` because of
      // https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps
      debugPrint('Toast.toast: context is not mounted');
      return;
    }

    // Hide previouse snack bars
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 26.0)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )));
  }
}
