import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData iconData;
  final String message;

  const EmptyStateWidget({
    Key? key,
    required this.iconData,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData, size: 80, color: Colors.grey),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
