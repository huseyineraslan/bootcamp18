import 'package:bootcamp_app_18/models/exercise_model.dart';
import 'package:bootcamp_app_18/pages/exercise_detail_page.dart';
import 'package:bootcamp_app_18/provider/app_provider.dart';
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
        title: Text('${capitalizeFirstLetter(widget.categoryName)} Exercises'),
      ),
      // ExerciseProvider sağlayıcısından egzersizleri almak için Consumer kullanalım
      body: Consumer<AppProvider>(
        builder: (context, exerciseProvider, _) {
          if (widget.categoryName.toLowerCase() == 'rest') {
            return const Center(child: Text('Bugün dinlenme günü!'));
          }
          //bu kategoriye ait egzersiz listesi mevcut değil ise
          if (!Provider.of<AppProvider>(context)
              .uniquePrimaryMuscles
              .contains(widget.categoryName)) {
            return const Center(
                child: Text(
                    'Üzgünüm bu kategoriye ait şuan için egzersiz mevcut değil.😞'));
          }
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
                      title: Text(
                        exercises[index].name!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
