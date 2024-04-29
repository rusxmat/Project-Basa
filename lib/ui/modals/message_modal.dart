import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:flutter/material.dart';

class MessageModal extends StatelessWidget {
  final String message;
  final String title;

  const MessageModal({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ConstantUI.customBlue,
          )),
      content: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      actions: [
        CustomFloatingAction(
          btnColor: Colors.white,
          btnIcon: CLOSE_ICON,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
