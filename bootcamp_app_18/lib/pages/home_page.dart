import 'dart:core';
import 'package:bootcamp_app_18/constants/motivational_quotes.dart';
import 'package:bootcamp_app_18/pages/adversiment_page.dart';
import 'package:bootcamp_app_18/pages/exercise_categories_page.dart';
import 'package:bootcamp_app_18/pages/login_page.dart';
import 'package:bootcamp_app_18/pages/notifications_page.dart';
import 'package:bootcamp_app_18/pages/nutrition_page.dart';
import 'package:bootcamp_app_18/pages/profil_page.dart';
import 'package:bootcamp_app_18/pages/programs_page.dart';
import 'package:bootcamp_app_18/pages/statistics_page.dart';
import 'package:bootcamp_app_18/provider/app_provider.dart';
import 'package:bootcamp_app_18/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  double appBarHeight = 50;
  double motivationCardHeight = 250;
  late double aspectRatio; //grid height
  bool _imagesPrecached = false;

  int _currentIndex = 0;

  final int _quotesLength = MotivationalQuotes.quotes.length;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    calculateAspectRatio();
    if (!_imagesPrecached) {
      for (var quote in MotivationalQuotes.quotes) {
        precacheImage(AssetImage(quote['image']!), context);
      }
      _imagesPrecached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: Text(
            'Enerjinizi yükseltin,\nsağlığınızı koruyun!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            IconButton(
                icon: Icon(
                  themeProvider.isDarkTheme
                      ? Icons.wb_sunny
                      : Icons.nights_stay,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                }),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                if (appProvider.isLoggedIn) {
                  // Kullanıcı giriş yapmışsa profile page'ine yönlendir
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilPage()),
                  );
                } else {
                  // Kullanıcı giriş yapmamışsa login page'ine yönlendir
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
            ),
          ],
          automaticallyImplyLeading: false, // Geri düğmesini gizle
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _nextQuote,
                  child: Container(
                    height: motivationCardHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            MotivationalQuotes.quotes[_currentIndex]['image']!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          MotivationalQuotes.quotes[_currentIndex]['quote']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.black26,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildDotIndicator(),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: aspectRatio,
                          children: [
                            _buildGridTile(
                                'Egzersizler', Icons.fitness_center, context),
                            _buildGridTile(
                                'Beslenme', Icons.restaurant, context),
                            _buildGridTile(
                                'Programlar', Icons.calendar_today, context),
                            _buildGridTile(
                                'İstatistikler', Icons.show_chart, context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const AdBanner(),
        ],
      ),
    );
  }

  void _nextQuote() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _quotesLength;
    });
  }

  List<Widget> _buildDotIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _quotesLength; i++) {
      indicators.add(Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndex == i ? Colors.deepOrange : Colors.grey,
        ),
      ));
    }
    return indicators;
  }

  Widget _buildGridTile(String title, IconData icon, BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        if (title == 'Egzersizler') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ExerciseCategoriesPage()),
          );
        } else if (title == 'Beslenme') {
          if (appProvider.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NutritionPage()),
            );
          } else {
            // Giriş yapılmamışsa uyarı dialogu göster
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Giriş Yapılmadı'),
                  content: const Text(
                    'AI destekli diyetisyen kullanmak için lütfen giriş yapın.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Tamam',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                );
              },
            );
          }
        } else if (title == 'Programlar') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProgramsPage()),
          );
        } else if (title == 'İstatistikler') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StatisticsPage()),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.secondary, Colors.red],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.black54,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void calculateAspectRatio() {
    double availableHeight = MediaQuery.of(context).size.height -
        appBarHeight -
        motivationCardHeight -
        60; // 60 is for padding and spacing

    aspectRatio =
        (MediaQuery.of(context).size.width / 2) / (availableHeight / 2);

    if (aspectRatio <= 0) {
      aspectRatio = 1;
    }
  }
}
