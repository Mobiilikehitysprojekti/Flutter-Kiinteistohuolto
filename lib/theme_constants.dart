import 'package:flutter/material.dart';

const COLOR_PRIMARY = Colors.deepOrangeAccent;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: COLOR_PRIMARY,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.resolveWith<Color>((states) => COLOR_PRIMARY),
    ),
  ),
  appBarTheme: const AppBarTheme(backgroundColor: COLOR_PRIMARY),
  textTheme: const TextTheme(
    bodySmall: TextStyle(color: COLOR_PRIMARY),
    bodyMedium: TextStyle(color: COLOR_PRIMARY),
    bodyLarge: TextStyle(color: COLOR_PRIMARY)
  ),
  
);
