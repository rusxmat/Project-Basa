import 'dart:io';

import 'package:basa_proj_app/ui/widgets/custom_textfield.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class EditBookPageModal extends StatelessWidget {
  final TextEditingController bookContentController;
  final int pageNumber;
  final XFile image;

  EditBookPageModal({
    required this.bookContentController,
    required this.pageNumber,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Page'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.file(
                    File(image.path),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                CustomTextField(
                  controller: bookContentController,
                  isTextArea: true,
                  defaultMaxLines: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
