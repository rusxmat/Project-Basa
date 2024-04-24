import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:flutter/material.dart';

class CustomFloatingAction extends StatelessWidget {
  final Icon btnIcon;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color btnColor;

  const CustomFloatingAction({
    required this.btnIcon,
    required this.onPressed,
    this.icon,
    required this.btnColor,
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
      enableFeedback: onPressed != null,
      backgroundColor: btnColor,
      onPressed: onPressed,
      child: (onPressed != null) ? btnIcon : DISABLED_ICON,
    );
  }
}
