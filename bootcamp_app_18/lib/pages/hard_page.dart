import 'package:flutter/material.dart';
import 'exercise_item.dart'; // Import this

class HardProgramPage extends StatelessWidget {
  const HardProgramPage({super.key});

  final Map<String, List<String>> hardProgram = const {
    "monday": ["Abdominals", "Hamstrings", "Quadriceps"],
    "tuesday": ["Triceps", "Glutes", "Lats"],
    "wednesday": ["Chest", "Adductors", "Shoulders"],
    "thursday": ["Abductors", "Lower Back", "Neck"],
    "friday": ["Calves", "Biceps", "Forearms"],
    "saturday": ["Full Body"],
    "sunday": ["Rest"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zor Program'),
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
          itemCount: hardProgram.length,
          itemBuilder: (context, index) {
            String day = hardProgram.keys.elementAt(index);
            List<String> exercises = hardProgram[day]!;
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
