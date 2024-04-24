import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:flutter/material.dart';

class ViewImageModal extends StatelessWidget {
  final Image image;

  ViewImageModal({required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.close,
                color: ConstantUI.customPink,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            image,
          ],
        ),
      ),
    );
  }
}
