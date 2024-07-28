import 'package:flutter/material.dart';
import 'exercise_item.dart'; // Import this

class MediumProgramPage extends StatelessWidget {
  const MediumProgramPage({super.key});

  final Map<String, List<String>> mediumProgram = const {
    "monday": ["Abdominals", "Hamstrings"],
    "tuesday": ["Quadriceps", "Triceps"],
    "wednesday": ["Glutes", "Lats"],
    "thursday": ["Chest", "Adductors"],
    "friday": ["Shoulders", "Abductors"],
    "saturday": ["Lower Back", "Neck"],
    "sunday": ["Calves", "Biceps"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orta Program'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.red],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: mediumProgram.length,
          itemBuilder: (context, index) {
            String day = mediumProgram.keys.elementAt(index);
            List<String> exercises = mediumProgram[day]!;
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  day.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: exercises.map((exercise) {
                    return ExerciseItem(exercise: exercise);
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
