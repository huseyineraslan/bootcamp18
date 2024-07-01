import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

/*
API bilgisi:

https://wger.de/en/software/api

https://wger.de/api/v2/
 */
class ExerciseApiService {
  static const String _baseUrl = 'https://wger.de/api/v2/';

  /* 
  Tüm veri çekme işlemlerinde önbelleğe alma yöntemi kullanılmıştır.
  Bu sayede gereksiz ağ requestlerinden kaçınılmıştır.
  */

// Egzersiz kategori listesini alma
  static Future<List> fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedCategories = prefs.getString('categories');

    if (cachedCategories != null) {
      //önbellekte veri varsa
      return json.decode(cachedCategories);
    } else {
      //Önbellekten veri alınamazsa veya önbellekteki veri geçersizse api ye istek at
      final response =
          await http.get(Uri.parse('${_baseUrl}exercisecategory/'));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        List categories = data['results'];
        await prefs.setString('categories', json.encode(categories));
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    }
  }

  // Seçilen kategoriye ait egzersiz listesini alma (eg:legs => leg exercise list)
  static Future<List> fetchExercises(int categoryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedExercises = prefs.getString('exercises_$categoryId');

    if (cachedExercises != null) {
      //önbellekte veri varsa
      return json.decode(cachedExercises);
    } else {
      //Önbellekten veri alınamazsa veya önbellekteki veri geçersizse api ye istek at
      final response = await http.get(Uri.parse(
          '${_baseUrl}exercise/?category=$categoryId&language=2&limit=30&offset=0'));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

// Hatalı veri list
        List<Map<String, dynamic>> unwantedExercises = [
          {'name': 'Dumbbell Lunges Standing'},
          {'name': 'Elevación de talón de pie'},
          {'name': 'Elevación de talón sentados'},
          {'name': 'BlahBlah'},
          {'name': 'Arabesque'},
        ];

        Set<String> unwantedNames =
            unwantedExercises.map((e) => e['name'] as String).toSet();
// ücretsiz api kullandığımız için kirli verileri listeye dahil etme
        List exercises = data['results']
            .where((exercise) =>
                exercise['description'] != null &&
                exercise['description'].isNotEmpty &&
                exercise['description'] != "<p>.</p>" &&
                !unwantedNames.contains(exercise['name']))
            .toList();

        await prefs.setString('exercises_$categoryId', json.encode(exercises));
        return exercises;
      } else {
        throw Exception('Failed to load exercises');
      }
    }
  }

// Seçilen egzersiz detay bilgisini alma
  static Future<Map> fetchExerciseDetails(int exerciseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedExercise = prefs.getString('exercise_$exerciseId');

    //önbellekte veri varsa
    if (cachedExercise != null) {
      return json.decode(cachedExercise);
    }
    //Önbellekten veri alınamazsa veya önbellekteki veri geçersizse api ye istek at
    else {
      final response =
          await http.get(Uri.parse('${_baseUrl}exerciseinfo/$exerciseId/'));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        //description bilgisini düzenleme ve translate etme
        data['steps'] =
            await translator(parseHtmlToString(data['description'] ?? ''));

        // add to cache
        await prefs.setString('exercise_$exerciseId', json.encode(data));

        return data;
      } else {
        throw Exception('Failed to load exercise details');
      }
    }
  }

  // ilgili egzersiz description ı html formatında geliyor, bunu metne çevirme
  static String parseHtmlToString(String htmlString) {
    String plainText = htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
    List<String> steps = plainText.split('</li>');
    if (steps.isNotEmpty) {
      steps[steps.length - 1] = steps.last.replaceAll(RegExp(r'<[^>]*>'), '');
      steps = steps.map((step) => step.replaceAll('<li>', '')).toList();
    }
    return steps.join('\n');
  }

// Translate - türkçe
  static Future<String> translator(String infoText) async {
    final translator = GoogleTranslator();
    // türkçe ye çevir
    var translation = await translator.translate(infoText, to: 'tr');

    return translation.toString();
  }
}
