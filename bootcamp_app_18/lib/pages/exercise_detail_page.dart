import 'package:bootcamp_app_18/service/wger_exercise_api_service.dart';
import 'package:flutter/material.dart';

class ExerciseDetailPage extends StatefulWidget {
  final int exerciseId;
  const ExerciseDetailPage({super.key, required this.exerciseId});

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  Map exercise = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExerciseDetails(); // seçilen egzersizin detay bilgilerini alma
  }

  @override
  Widget build(BuildContext context) {
    String steps = exercise['steps'] ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    steps,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),

                  // egzersiz detay bilgisinde equipment varsa oluştur
                  buildDetailList(
                    'Gerekli Ekipman',
                    exercise['equipment'],
                    (equipment) => "- ${equipment["name"]}",
                  ),
                  const SizedBox(height: 16),
                  // egzersiz detay bilgisinde muscles varsa oluştur
                  buildDetailList(
                    'Çalışan Kaslar - Muscles',
                    exercise['muscles'],
                    (muscle) => "- ${muscle["name"]} (${muscle["name_en"]})",
                  ),
                  const SizedBox(height: 16),
                  // egzersiz detay bilgisinde muscles_secondary varsa yaz.
                  buildDetailList(
                    'Secondary Muscles',
                    exercise['muscles_secondary'],
                    (muscle) => "- ${muscle["name"]} (${muscle["name_en"]})",
                  ),
                ],
              ),
            ),
    );
  }

// seçilen egzersizin detay bilgilerini alma
  fetchExerciseDetails() async {
    try {
      Map fetchedExercise =
          await ExerciseApiService.fetchExerciseDetails(widget.exerciseId);
      setState(() {
        exercise = fetchedExercise;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

/*
   buildDetailList : title, öğeler listesi ve her bir öğeyi nasıl 
   görüntüleyeceğinizi belirten bir itemBuilder fonksiyonu alır.
 */
  Widget buildDetailList(
      String title, List<dynamic> items, String Function(dynamic) itemBuilder) {
    //liste boşsa boş alan döndür
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      // title ve listeyi column içine yerleştirme
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Liste Title Text
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Text(
            itemBuilder(item),
            style: const TextStyle(fontSize: 16),
          );
        }),
      ],
    );
  }
}
