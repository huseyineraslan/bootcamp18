import 'dart:core';
import 'package:bootcamp_app_18/constants/theme_manager.dart';
import 'package:bootcamp_app_18/firebase_options.dart';
import 'package:bootcamp_app_18/pages/home_page.dart';
import 'package:bootcamp_app_18/provider/app_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback toggleTheme;

  const HomePage({
    super.key,
    required this.isDarkTheme,
    required this.toggleTheme,
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
    //initState den sonra builden önce çalışır
    super.didChangeDependencies();
    calculateAspectRatio();
    // Tüm resimleri önbeleğe yükle - yükleme yapılmamma durumunda gecikme meydana gelmektedir.
    if (!_imagesPrecached) {
      for (var quote in MotivationalQuotes.quotes) {
        precacheImage(AssetImage(quote['image']!), context);
      }
      _imagesPrecached = true; // Tekrar çağrılmasını önlemek için
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar - profil - bildirim - söz
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          // Logo denemesi
          /*   leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20.0,
              backgroundImage: AssetImage('lib/assets/images/logo.png'),
            ),
          ),*/
          title: Text(
            'Enerjinizi yükseltin,\nsağlığınızı koruyun!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            IconButton(
              icon: Icon(
                widget.isDarkTheme ? Icons.wb_sunny : Icons.nights_stay,
              ),
              onPressed: widget.toggleTheme,
            ),
            //bildirimler
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Bildirim sayfasına yönlendirme
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsPage()));
              },
            ),
            //Profil
            IconButton(
              icon: const Icon(Icons.person),

              onPressed: () {
                // Profil sayfasına yönlendirme
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));

              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Motivasyon resim ve sözleri
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
            //grid bölümü ezgersiz-diyet-hesaplama
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //motivasyon cümlesi noktaları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildDotIndicator(),
                  ),
                  const SizedBox(height: 10),
                  // Gridview Section
                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true, //scroll
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: aspectRatio,
                      children: [
                        _buildGridTile(
                            'Egzersizler', Icons.fitness_center, context),
                        _buildGridTile('Beslenme', Icons.restaurant, context),
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
    );
  }

  // Sonraki motivasyon alıntısına geçmek için mevcut alıntı günceller
  void _nextQuote() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _quotesLength;
    });
  }

  // Her bir motivasyon alıntısı için bir daire göstergesi oluşturur
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

  // Grid alt bölümdeki öğeyi oluşturma metodu
  Widget _buildGridTile(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // İlgili sayfaya yönlendirme
        if (title == 'Egzersizler') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ExerciseCategoriesPage()),
          );
        } else if (title == 'Beslenme') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NutritionPage()),
          );
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

  // Grid bölümündeki öğelerin boyutunu hesaplama - ekrana sığması hedeflenmiştir.
  void calculateAspectRatio() {
    double availableHeight = MediaQuery.of(context).size.height -
        appBarHeight -
        motivationCardHeight -
        60; // 60 is for padding and spacing

    aspectRatio =
        (MediaQuery.of(context).size.width / 2) / (availableHeight / 2);

    // ChildAspectRatio 0'dan küçük veya 0 ise 1 olarak ayarlanır
    if (aspectRatio <= 0) {
      aspectRatio = 1;
    }
  }
}
