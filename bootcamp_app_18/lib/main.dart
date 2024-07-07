import 'dart:core';
import 'package:bootcamp_app_18/constants/color.dart';
import 'package:bootcamp_app_18/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
          accentColor: Colors.deepPurpleAccent,
          backgroundColor: HexColor(backgroundColor),
          errorColor: Colors.red,
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: HexColor(appBarColor),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        textTheme: const TextTheme(
            bodyMedium: TextStyle(
          color: Colors.white,
        )),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
