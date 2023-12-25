import 'package:flutter/material.dart';

class DeleteIconWidget extends StatelessWidget {
  const DeleteIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container (
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}
