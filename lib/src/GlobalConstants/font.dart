// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

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

  static TextStyle medium({
    double fontSize = 14.0,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }
}

class secondFont {
  static const String primaryFont = 'OUTFIT';

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

  static TextStyle medium({
    double fontSize = 14.0,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }
}
