import 'package:flutter/material.dart';

class SnackbarService {
  void showReminderUpdatedSnackbar(BuildContext context, bool isActivated) {
    final message = isActivated ? 'Erinnerung aktiviert.' : 'Erinnerung deaktiviert.';
    final icon = isActivated ? Icons.alarm_on : Icons.alarm_off;
    showCustomSnackBar(context, message, icon: icon);
  }

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
}
