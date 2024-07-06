import 'package:bootcamp_app_18/pages/exercises_page.dart';
import 'package:bootcamp_app_18/service/wger_exercise_api_service.dart';
import 'package:flutter/material.dart';

class ExerciseCategoriesPage extends StatefulWidget {
  const ExerciseCategoriesPage({super.key});

  @override
  State<ExerciseCategoriesPage> createState() => _ExerciseCategoriesPageState();
}

class _ExerciseCategoriesPageState extends State<ExerciseCategoriesPage> {
  List categories = []; // exercises categories
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories(); //kategoriler listesi alınır
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Categories'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String categoriName = categories[index]['name'];

                String imageName =
                    'lib/assets/images/${categoriName.trim()}.jpg';

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  // InkWell widget, dokunmayı / tıklanmayı algılar
                  child: InkWell(
                    onTap: () {
                      // seçilen egzersiz kategorisine ait egzersizler sayfasına yönlendirme
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExercisesPage(
                              categoryId: categories[index]['id']),
                        ),
                      );
                    },
                    child: Container(
                      height: 100, //card yüksekliği
                      //card arka plan
                      decoration: BoxDecoration(
                        color: Colors.blueGrey, //arka plan rengini
                        image: DecorationImage(
                          image: AssetImage(imageName),
                          fit: BoxFit.cover, //resim kutucuğu doldursun
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(
                                0.6), //yarı saydam bir siyah renk (%60 opaklık)
                            BlendMode.dstATop, //renk efekti
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        //Egzersiz Kategori Text
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categories[index]['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void fetchCategories() async {
    try {
      List fetchedCategories = await ExerciseApiService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }
}
