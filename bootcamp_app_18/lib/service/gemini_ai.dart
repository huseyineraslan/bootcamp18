import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAI {
  static const String _apiKey =
      "AIzaSyCp6O_vCcqesk9ODcBZCsC7211rvkuuQh8"; // api key buraya eklenecek
  static GeminiAI? _instance;
  late final GenerativeModel model;
  Map<String, List<Map<String, String>>> _sessions =
      {}; // Oturum verilerini saklama

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

  Future<String?> geminiTextPrompt(String sessionId, String query) async {
    if (apiControl()) {
      _addMessageToSession(sessionId, 'user', query); // Kullanıcı mesajını ekle
      final content = _getConversationContext(sessionId);

      final response = await model.generateContent(content);
      if (response.text != null) {
        print("RESPONSE TEXT ===================");
        print(response.text);

        _addMessageToSession(
            sessionId, 'ai', response.text!); // AI yanıtını ekle

        return response.text;
      } else {
        return null;
      }
    }
    return null;
  }

  void _addMessageToSession(String sessionId, String sender, String message) {
    if (!_sessions.containsKey(sessionId)) {
      _sessions[sessionId] = [];
    }
    _sessions[sessionId]!.add({'sender': sender, 'message': message});
  }

  List<Content> _getConversationContext(String sessionId) {
    final sessionMessages = _sessions[sessionId] ?? [];
    return sessionMessages.map((msg) => Content.text(msg['message']!)).toList();
  }
}
