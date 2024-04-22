import 'package:flutter/material.dart';

class CustomFloatingAction extends StatelessWidget {
  final Icon btnIcon;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color btnColor;
  final bool isDisabled;

  const CustomFloatingAction({
    required this.btnIcon,
    required this.onPressed,
    this.icon,
    required this.btnColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: ShapeBorder.lerp(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        0.5,
      ),
      backgroundColor: btnColor,
      onPressed: (!isDisabled) ? onPressed : null,
      child: btnIcon,
    );
  }
}
