import 'package:flutter/material.dart';

final ThemeData lightYellowTheme = ThemeData(
  primarySwatch: MaterialColor(0xFFE2D772, <int, Color>{
    50: Color(0xFFFFFBEA),
    100: Color(0xFFFFF6D6),
    200: Color(0xFFFFF1C2),
    300: Color(0xFFFEECAD),
    400: Color(0xFFFEDEA1),
    500: Color(0xFFE2D772),
    600: Color(0xFFD6C96A),
    700: Color(0xFFBFB25E),
    800: Color(0xFFA99C52),
    900: Color(0xFF938646),
  }),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color.fromARGB(255, 173, 173, 110),
    textTheme: ButtonTextTheme.primary,
  ),
);

final ThemeData lightPinkTheme = ThemeData(
  primarySwatch: MaterialColor(0xFFBA5375, <int, Color>{
    50: Color(0xFFFDE7EC),
    100: Color(0xFFFAC3D1),
    200: Color(0xFFF69DB3),
    300: Color(0xFFF27795),
    400: Color(0xFFEF5B7F),
    500: Color(0xFFEB3F69),
    600: Color(0xFFE83961),
    700: Color(0xFFE42F56),
    800: Color(0xFFE0264C),
    900: Color(0xFFD8173B),
  }),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color.fromARGB(255, 183, 89, 121),
    textTheme: ButtonTextTheme.primary,
  ),
);

final ThemeData lightBlueTheme = ThemeData(
  primarySwatch: Colors.blue,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.lightBlueAccent,
    textTheme: ButtonTextTheme.primary,
  ),
);
