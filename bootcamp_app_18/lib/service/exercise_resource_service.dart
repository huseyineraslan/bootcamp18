import 'dart:convert';
import 'package:bootcamp_app_18/models/exercise_model.dart';
import 'package:http/http.dart' as http;

class ExerciseService {
  final String _baseUrl =
      'https://raw.githubusercontent.com/havva-nur-ezginci/free-exercise-db_tr/main/dist/body_only_tr.json';

  Future<List<Exercise>> fetchExercises() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> exercisesJson = json.decode(response.body);
      return exercisesJson.map((json) => Exercise.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
