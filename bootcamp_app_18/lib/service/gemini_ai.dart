import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAI {
  static const String _apiKey = ""; // api key buraya eklenecek
  static late final GenerativeModel model;

  GeminiAI() {
    _initialize();
  }

  void _initialize() {
    model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
  }

  bool apiControl() {
    if (_apiKey.isEmpty) {
      print('No API_KEY is empty');
      return false;
    }
    return true;
  }

  Future<String?> geminiTextPrompt(String query) async {
    if (apiControl()) {
      final content = [
        //default test amaçlı text verilmiştir ileride değiştirilecek.
        Content.text(query)
      ];
      final response = await model.generateContent(content);
      if (response.text != null) {
        print("RESPONSE TEXT ===================");
        print(response.text);
        return response.text;
      } else {
        return null;
      }
    }
    return null;
  }
}
