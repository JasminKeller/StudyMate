import 'package:flutter/material.dart';

void showCustomSnackBar(
    BuildContext context,
    String message, {
      IconData? icon,
      String? actionLabel,
      VoidCallback? onAction,
    }) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) Icon(icon),
          if (icon != null) const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
        label: actionLabel,
        onPressed: onAction,
      )
          : null,
      duration: const Duration(seconds: 3),
    ),
  );
}
