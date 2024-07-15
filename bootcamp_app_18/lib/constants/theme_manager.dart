import 'package:flutter/material.dart';

class ThemeManager {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFFEDEADE),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFEDEADE),
      secondary: Colors.orange,
      background: Color(0xFFEDEADE),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
      bodyLarge: TextStyle(
          fontSize: 19.0, color: Colors.black, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black),
      bodySmall: TextStyle(fontSize: 12.0, color: Colors.black),
    ),
    iconTheme: const IconThemeData(color: Colors.black, size: 30),
    buttonTheme: const ButtonThemeData(buttonColor: Colors.orange),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFEDEADE),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFFEDEADE),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF252525),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF252525),
      secondary: Colors.orange,
      background: Color(0xFF191919),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(
          fontSize: 19.0, color: Colors.white, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white),
      bodySmall: TextStyle(fontSize: 12.0, color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white, size: 30),
    buttonTheme: const ButtonThemeData(buttonColor: Colors.orange),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF666666),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF191919),
    ),
  );
}
