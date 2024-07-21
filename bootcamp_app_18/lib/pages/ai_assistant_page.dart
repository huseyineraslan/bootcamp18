import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  _AIAssistantPageState createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String _apiKey = 'API_KEY_BURAYA_GİRECEK'; // API anahtarınızı buraya ekleyin
  String? _dietType;
  String? _goal;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    setState(() {
      _messages.add({'role': 'ai', 'content': 'Merhaba! Size nasıl yardımcı olabilirim?'});
      _messages.add({'role': 'ai', 'content': 'Hangi beslenme türü ile ilgileniyorsunuz? (Vejetaryen, Etçil, Protein Agirlikli)'});
    });
  }

  Future<void> _sendMessage() async {
    final userMessage = _controller.text;
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _controller.clear();
    });

    if (_dietType == null) {
      if (userMessage.toLowerCase().contains('vejetaryen')) {
        _dietType = 'Vejetaryen';
        setState(() {
          _messages.add({'role': 'ai', 'content': 'Kilo almak mı yoksa vermek mi istiyorsunuz? (Kilo Almak, Kilo Vermek)'});
        });
      } else if (userMessage.toLowerCase().contains('etçil') || userMessage.toLowerCase().contains('etcil')) {
        _dietType = 'Etçil';
        setState(() {
          _messages.add({'role': 'ai', 'content': 'Kilo almak mı yoksa vermek mi istiyorsunuz? (Kilo Almak, Kilo Vermek)'});
        });
      } else if (userMessage.toLowerCase().contains('protein') || userMessage.toLowerCase().contains('agirlikli')) {
        _dietType = 'Protein Agirlikli';
        setState(() {
          _messages.add({'role': 'ai', 'content': 'Kilo almak mı yoksa vermek mi istiyorsunuz? (Kilo Almak, Kilo Vermek)'});
        });
      } else {
        setState(() {
          _messages.add({'role': 'ai', 'content': 'Lütfen beslenme türünüzü belirtin: Vejetaryen, Etçil, veya Protein Agirlikli.'});
        });
      }
    } else if (_goal == null) {
      if (userMessage.toLowerCase().contains('kilo almak')) {
        _goal = 'Kilo Almak';
        setState(() {
          _messages.add({'role': 'ai', 'content': 'Kilo almak için önerilen beslenme programını sağlıyorum.'});
          _messages.add({'role': 'ai', 'content': _getMealPlan()});
        });
      } else if (userMessage.toLowerCase().contains('kilo vermek')) {
        _goal = 'Kilo Vermek';
        setState(() {
          _messages.add({'role': 'ai', 'content': 'Kilo vermek için önerilen beslenme programını sağlıyorum.'});
          _messages.add({'role': 'ai', 'content': _getMealPlan()});
        });
      } else {
        setState(() {
          _messages.add({'role': 'ai', 'content': 'Lütfen kilo almak mı yoksa vermek mi istediğinizi belirtin.'});
        });
      }
    } else {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'), // Endpointi doğru kullanın
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'text-davinci-003', // Modeli belirtin
          'prompt': userMessage,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          final aiMessage = responseData['choices'][0]['text'];
          setState(() {
            _messages.add({'role': 'ai', 'content': aiMessage.trim()});
          });
        } catch (e) {
          print('Yanıtı işlerken bir hata oluştu: $e');
        }
      } else {
        print('API isteğinde bir hata oluştu: ${response.statusCode}');
        print('Hata yanıtı: ${response.body}');
      }
    }
  }

  String _getMealPlan() {
    if (_dietType == 'Vejetaryen') {
      return _goal == 'Kilo Almak' ?
      'Kilo almak için önerilen vejetaryen beslenme planı:\n'
          'Kahvaltı: Yulaf ezmesi, chia tohumu, badem sütü, meyve\n'
          'Ara Öğün: Yoğurt ve granola\n'
          'Öğle: Mercimek köftesi, kinoa, yeşil salata\n'
          'Ara Öğün: Avokado ve tam buğday ekmeği\n'
          'Akşam: Sebzeli kinoa pilavı, zeytinyağlı enginar\n'
          'Tatlı: Meyve salatası' :
      'Kilo vermek için önerilen vejetaryen beslenme planı:\n'
          'Kahvaltı: Sütlü chia pudingi, taze meyveler\n'
          'Ara Öğün: Sebze çubukları ve humus\n'
          'Öğle: Izgara sebzeler ve yoğurtlu soslu salata\n'
          'Ara Öğün: Bir avuç badem\n'
          'Akşam: Sebze çorbası ve tam buğday ekmeği\n'
          'Tatlı: Az şekerli yoğurt';
    } else if (_dietType == 'Etçil') {
      return _goal == 'Kilo Almak' ?
      'Kilo almak için önerilen etçil beslenme planı:\n'
          'Kahvaltı: Yumurta beyazı omleti, tam buğday ekmeği, avokado\n'
          'Ara Öğün: Peynir ve ceviz\n'
          'Öğle: Izgara tavuk göğsü, kahverengi pirinç, sebze\n'
          'Ara Öğün: Smoothie (süt, muz, protein tozu)\n'
          'Akşam: Kırmızı et, patates püresi, sebze garnitürü\n'
          'Tatlı: Protein bar' :
      'Kilo vermek için önerilen etçil beslenme planı:\n'
          'Kahvaltı: Yumurta beyazı ile hazırlanmış sebzeli omlet\n'
          'Ara Öğün: Taze meyve ve yoğurt\n'
          'Öğle: Izgara balık, kinoa ve sebze salatası\n'
          'Ara Öğün: Bir avuç fındık\n'
          'Akşam: Tavuk göğsü, haşlanmış sebzeler\n'
          'Tatlı: Şekersiz puding';
    } else if (_dietType == 'Protein Agirlikli') {
      return _goal == 'Kilo Almak' ?
      'Kilo almak için önerilen protein ağırlıklı beslenme planı:\n'
          'Kahvaltı: Yüksek proteinli smoothie (süt, protein tozu, yulaf)\n'
          'Ara Öğün: Süzme yoğurt ve meyve\n'
          'Öğle: Izgara tavuk, quinoa ve sebzeler\n'
          'Ara Öğün: Protein bar\n'
          'Akşam: Izgara biftek, patates ve sebzeler\n'
          'Tatlı: Proteinli sütlü tatlı' :
      'Kilo vermek için önerilen protein ağırlıklı beslenme planı:\n'
          'Kahvaltı: Yüksek proteinli yoğurt ve meyve\n'
          'Ara Öğün: Sebze çubukları ve humus\n'
          'Öğle: Izgara balık, yeşil salata ve kinoa\n'
          'Ara Öğün: Bir avuç badem\n'
          'Akşam: Tavuk göğsü, haşlanmış brokoli\n'
          'Tatlı: Az şekerli sütlü tatlı';
    } else {
      return 'Beslenme türü ve hedef belirtilmedi.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yapay Zeka Destekli Diyet Asistanı'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['role'] == 'user';

                return ListTile(
                  title: Align(
                    alignment:
                    isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        message['content'] ?? '',
                        style: TextStyle(
                          color: isUserMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Soru yazın...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
