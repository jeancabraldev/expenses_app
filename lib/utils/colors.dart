import 'package:flutter/material.dart';

class ColorsLayout {
  //primary color
  static Color primaryColor([double opacity = 1]) =>
      Color.fromRGBO(30, 150, 252, opacity);

  //secondary color
  static Color secondaryColor([double opacity = 1]) =>
      Color.fromRGBO(247, 127, 0, opacity);

  //primary text color
  static Color primaryTextColor([double opacity = 1]) =>
      Color.fromRGBO(53, 53, 53, opacity);

  //color icons
  static Color iconColor([double opacity = 1]) =>
      Color.fromRGBO(70, 70, 70, opacity);
}
