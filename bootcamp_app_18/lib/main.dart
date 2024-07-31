import 'dart:core';
import 'package:bootcamp_app_18/constants/theme_manager.dart';
import 'package:bootcamp_app_18/firebase_options.dart';
import 'package:bootcamp_app_18/pages/home_page.dart';
import 'package:bootcamp_app_18/pages/ai_assistant_page.dart';
import 'package:bootcamp_app_18/pages/statistics_page.dart';
import 'package:bootcamp_app_18/provider/app_provider.dart';
import 'package:bootcamp_app_18/provider/theme_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                AppProvider()..fetchExercises()), //egzersiz bilgisini çek
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.isDarkTheme
                ? ThemeManager.darkTheme
                : ThemeManager.lightTheme,
            home: const HomePage(),
            routes: {
              '/aiAssistant': (context) => const AIAssistantPage(),
              '/statistics': (context) => const StatisticsPage(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
