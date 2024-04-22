import 'package:flutter/material.dart';

class MessageModal extends StatelessWidget {
  final String message;

  MessageModal({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Babala'),
      content: Container(
        padding: EdgeInsets.all(16),
        child: Text(
          message,
          style: TextStyle(fontSize: 18),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
