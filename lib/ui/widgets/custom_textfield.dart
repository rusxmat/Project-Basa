import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isTextArea;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isTextArea,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: (isTextArea) ? TextInputType.multiline : TextInputType.text,
      maxLines: (isTextArea) ? 5 : 1,
      cursorColor: ConstantUI.customBlue,
      controller: controller,
      decoration: InputDecoration(
        label: Text(
          hintText,
          style: const TextStyle(color: ConstantUI.customBlue),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ConstantUI.customBlue,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular((isTextArea) ? 25 : 50),
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular((isTextArea) ? 25 : 50),
        ),
      ),
    );
  }
}
