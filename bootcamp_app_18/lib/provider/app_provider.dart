import 'package:bootcamp_app_18/models/exercise_model.dart';
import 'package:bootcamp_app_18/pages/home_page.dart';
import 'package:bootcamp_app_18/service/exercise_resource_service.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;

  // unique muscles
  final Set<String> _uniquePrimaryMuscles = {};
  Set<String> get uniquePrimaryMuscles => _uniquePrimaryMuscles;
  final ExerciseService _exerciseService = ExerciseService();

  Future<void> fetchExercises() async {
    try {
      _exercises = await _exerciseService.fetchExercises();

      for (var exercise in exercises) {
        if (exercise.primaryMuscles != null &&
            exercise.primaryMuscles!.isNotEmpty) {
          _uniquePrimaryMuscles.addAll(exercise.primaryMuscles!);
        }
      }

      notifyListeners(); // // Notify listeners of changes
    } catch (e) {
      print('Egzersizler çekilemedi: $e');
    }
  }

  // Kategoriye göre egzersizleri filtreleme
  List<Exercise> getExercisesByCategory(String categoryName) {
    return _exercises
        .where((exercise) =>
            exercise.primaryMuscles?.contains(categoryName) ?? false)
        .toList();
  }

  // ID'ye göre tek bir egzersizi al
  Exercise? getExerciseById(String id) {
    return _exercises.firstWhere((exercise) => exercise.id == id);
  }

// login yapılma durumu işlemleri
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout(BuildContext context) {
    _isLoggedIn = false;
    notifyListeners();

    // Logout işlemi tamamlandıktan sonra HomePage'e dön
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}
