import 'package:flutter/material.dart';

class ConstantUI {
  static const Color customBlue = Color.fromARGB(255, 50, 132, 255);
  static const Color customYellow = Color.fromARGB(255, 255, 224, 99);
  static const Color customOrange = Color.fromARGB(255, 255, 154, 13);
  static const Color customGreen = Color.fromARGB(255, 0, 253, 0);
  static const Color customViolet = Color.fromARGB(255, 143, 51, 255);
  static const Color customPink = Color.fromARGB(255, 255, 134, 154);
  static const Color customGrey = Colors.grey;
}

const String ITIM_FONTNAME = 'Itim';
const AssetImage LOGO = AssetImage('assets/images/basa_logo.png');
const AssetImage LOGO_TXT = AssetImage('assets/images/basa_text_logo.png');

const Icon FORWARD_ICON = Icon(
  Icons.arrow_circle_right_rounded,
  color: ConstantUI.customBlue,
  size: 50,
);

const Icon DISABLED_ICON = Icon(
  Icons.do_disturb_alt_rounded,
  color: ConstantUI.customPink,
  size: 50,
);

const Icon CLOSE_ICON = Icon(
  Icons.cancel_rounded,
  color: ConstantUI.customGrey,
  size: 50,
);

const Icon DELETE_ICON = Icon(
  Icons.delete_rounded,
  color: Colors.white,
  size: 40,
);
