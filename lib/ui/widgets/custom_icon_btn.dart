import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = ConstantUI.customBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      icon: icon,
      onPressed: onPressed,
    );
  }
}
