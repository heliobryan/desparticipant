import 'package:flutter/material.dart';

// ignore: camel_case_types
class principalFont {
  static const String primaryFont = 'STRETCH';

  static TextStyle regular(
      {double fontSize = 14.0, Color color = Colors.black}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle bold({double fontSize = 14.0, Color color = Colors.black}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle medium(
      {double fontSize = 14.0, Color color = Colors.black}) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }
}
