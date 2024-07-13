import 'package:bootcamp_app_18/models/exercise_model.dart';
import 'package:bootcamp_app_18/pages/exercise_detail_page.dart';
import 'package:bootcamp_app_18/provider/exercise_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisesPage extends StatefulWidget {
  final String categoryName;
  const ExercisesPage({super.key, required this.categoryName});

  @override
  ExercisesPageState createState() => ExercisesPageState();
}

class ExercisesPageState extends State<ExercisesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      // ExerciseProvider sağlayıcısından egzersizleri almak için Consumer kullanalım
      body: Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, _) {
          // ExerciseProvider'dan kategoriye göre egzersizleri al

          List<Exercise> exercises =
              exerciseProvider.getExercisesByCategory(widget.categoryName);

          return exercises.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    //egzersiz listesi oluşturma
                    return ListTile(
                      title: Text(exercises[index].name!,
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        // ilgili egzersize ait detay sayfasına yönlendirme
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseDetailPage(
                                exerciseId: exercises[index].id!),
                          ),
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
