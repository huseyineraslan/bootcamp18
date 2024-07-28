import 'package:flutter/material.dart';
import 'exercise_item.dart';

class EasyProgramPage extends StatelessWidget {
  const EasyProgramPage({super.key});

  final Map<String, List<String>> easyProgram = const {
    "monday": ["Abdominals"],
    "tuesday": ["Hamstrings"],
    "wednesday": ["Quadriceps"],
    "thursday": ["Triceps"],
    "friday": ["Glutes"],
    "saturday": ["Lats"],
    "sunday": ["Rest"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kolay Program'),
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
          itemCount: easyProgram.length,
          itemBuilder: (context, index) {
            String day = easyProgram.keys.elementAt(index);
            List<String> exercises = easyProgram[day]!;
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
