import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:flutter/material.dart';

class CustomFloatingAction extends StatelessWidget {
  final Icon? btnIcon;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color btnColor;
  final Color iconColor;
  final double iconSize;
  final String? extendedText;

  const CustomFloatingAction({
    this.btnIcon,
    required this.onPressed,
    this.icon,
    required this.btnColor,
    this.iconColor = Colors.white,
    this.iconSize = 50,
    this.extendedText,
  });

  @override
  Widget build(BuildContext context) {
    return (extendedText == null)
        ? FloatingActionButton(
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
            child: (onPressed != null)
                ? (btnIcon != null)
                    ? btnIcon
                    : Icon(
                        icon,
                        color: iconColor,
                        size: iconSize,
                      )
                : DISABLED_ICON,
          )
        : FloatingActionButton.extended(
            label: Text(
              extendedText!,
              style: TextStyle(
                color: iconColor,
                fontSize: 16,
              ),
            ),
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
            icon: (onPressed != null)
                ? (btnIcon != null)
                    ? btnIcon
                    : Icon(
                        icon,
                        color: iconColor,
                        size: iconSize,
                      )
                : DISABLED_ICON,
          );
  }
}
