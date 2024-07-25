import 'dart:core';
import 'package:bootcamp_app_18/constants/theme_manager.dart';
import 'package:bootcamp_app_18/firebase_options.dart';
import 'package:bootcamp_app_18/pages/home_page.dart';
import 'package:bootcamp_app_18/pages/ai_assistant_page.dart';
import 'package:bootcamp_app_18/pages/statistics_page.dart';
import 'package:bootcamp_app_18/provider/app_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = true;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        theme: _isDarkTheme ? ThemeManager.darkTheme : ThemeManager.lightTheme,
        home: HomePage(
          isDarkTheme: _isDarkTheme,
          toggleTheme: _toggleTheme,
        ),
        routes: {
          '/aiAssistant': (context) => AIAssistantPage(),
          '/statistics': (context) => StatisticsPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
