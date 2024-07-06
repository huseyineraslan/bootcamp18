import 'package:bootcamp_app_18/pages/exercise_detail_page.dart';
import 'package:bootcamp_app_18/service/wger_exercise_api_service.dart';
import 'package:flutter/material.dart';

class ExercisesPage extends StatefulWidget {
  final int categoryId;
  const ExercisesPage({super.key, required this.categoryId});

  @override
  ExercisesPageState createState() => ExercisesPageState();
}

class ExercisesPageState extends State<ExercisesPage> {
  List exercises = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExercises(); //egzersiz listesini al
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      // egzersiz listesi yüklendiğinde listeyi oluştur
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                //egzersiz listesi oluşturma
                return ListTile(
                  title: Text(exercises[index]['name'],
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    // ilgili egzersize ait detay sayfasına yönlendirme
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailPage(
                            exerciseId: exercises[index]['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

// api den ilgili kategorinin egzersiz listesini alma
  fetchExercises() async {
    try {
      List fetchedExercises =
          await ExerciseApiService.fetchExercises(widget.categoryId);
      setState(() {
        exercises = fetchedExercises;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }
}
