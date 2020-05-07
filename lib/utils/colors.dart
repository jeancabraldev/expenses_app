import 'package:flutter/material.dart';

class ColorsLayout {
  //primary color
  static Color primaryColor([double opacity = 1]) =>
      Color.fromRGBO(36, 123, 160, opacity);

  //secondary color
  static Color secondaryColor([double opacity = 1]) =>
      Color.fromRGBO(255, 224, 102, opacity);

  //primary text color
  static Color primaryTextColor([double opacity = 1]) =>
      Color.fromRGBO(53, 53, 53, opacity);

  //color icons
  static Color iconColor([double opacity = 1]) =>
      Color.fromRGBO(70, 70, 70, opacity);

  static Color backgroundColorWhite([double opacity = 1]) =>
      Colors.white.withOpacity(1);

  static Color categoryColorCards([double opacity = 1]) =>
      Color.fromRGBO(242, 95, 92, 1);
}
