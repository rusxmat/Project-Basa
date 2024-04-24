import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final bool isTextArea;
  final bool readOnly;
  final int defaultMaxLines;
  final String? errorText;

  const CustomTextField({
    super.key,
    this.hintText,
    required this.controller,
    this.isTextArea = false,
    this.readOnly = false,
    this.defaultMaxLines = 5,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      keyboardType: (isTextArea) ? TextInputType.multiline : TextInputType.text,
      maxLines: (isTextArea) ? defaultMaxLines : 1,
      cursorColor: ConstantUI.customBlue,
      controller: controller,
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ConstantUI.customPink,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular((isTextArea) ? 25 : 50),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ConstantUI.customPink,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular((isTextArea) ? 25 : 50),
        ),
        errorStyle: const TextStyle(color: ConstantUI.customPink),
        errorText: errorText,
        label: (hintText == null)
            ? null
            : Text(
                hintText!,
                style: TextStyle(
                    color: (errorText == null)
                        ? ConstantUI.customBlue
                        : ConstantUI.customPink),
              ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: (readOnly)
            ? null
            : OutlineInputBorder(
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
