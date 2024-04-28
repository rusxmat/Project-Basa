import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final VoidCallback? onPressedArrowBack;

  const CustomAppBarWidget({
    Key? key,
    required this.title,
    this.actions = const [],
    this.onPressedArrowBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ConstantUI.customYellow,
          ),
          onPressed: (onPressedArrowBack == null)
              ? () {
                  Navigator.pop(context);
                }
              : onPressedArrowBack,
        ),
        backgroundColor: ConstantUI.customBlue,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: ITIM_FONTNAME,
            color: Colors.white,
          ),
        ),
        actions: (actions.isNotEmpty) ? actions : null);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
