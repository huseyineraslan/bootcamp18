import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAI {
  static const String _apiKey =
      "AIzaSyCp6O_vCcqesk9ODcBZCsC7211rvkuuQh8"; // api key buraya eklenecek
  static GeminiAI? _instance;
  late final GenerativeModel model;

  // Private constructor to prevent direct instantiation
  GeminiAI._internal() {
    _initialize();
  }
// Factory constructor to get the singleton instance
  factory GeminiAI() {
    _instance ??= GeminiAI._internal();
    return _instance!;
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
