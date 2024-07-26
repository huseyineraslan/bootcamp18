import 'package:bootcamp_app_18/service/gemini_ai.dart';
import 'package:flutter/material.dart';

// NOT :
// gemini ai için : service/gemini_ai.dart dosyası içine api key koyulmalıdır.

class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  AIAssistantPageState createState() => AIAssistantPageState();
}

class AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final GeminiAI _geminiAI = GeminiAI();

  String? _dietType;
  String? _goal;
  String? role;
  final String _goalQuestionContext =
      'Kilo almak mı yoksa vermek mi istiyorsunuz? (Kilo Almak, Kilo Vermek)';
  final String _dietTypeQuestion =
      'Lütfen beslenme türünüzü belirtin: Vejetaryen, Etçil, Protein Agirlikli veya Normal';
  final aiErrorMessage =
      "AI bağlanma hatası yaşıyorum. Şuan için size otomatik liste hazırlıyorum.AI için daha sonra tekrar deneyiniz.";

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    setState(() {
      _messages.add({
        'role': 'ai',
        'content': 'Merhaba! Size nasıl yardımcı olabilirim?'
      });
      _messages.add({'role': 'ai', 'content': _dietTypeQuestion});
    });
  }

  Future<void> _sendMessage() async {
    final userMessage = _controller.text;
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _controller.clear();
    });

// dietType al
    if (_dietType == null) {
      if (userMessage.toLowerCase().contains('vejetaryen')) {
        _dietType = 'Vejetaryen';
        setState(() {
          _messages.add({'role': 'ai', 'content': _goalQuestionContext});
        });
      } else if (userMessage.toLowerCase().contains('etçil')) {
        _dietType = 'Etçil';
        setState(() {
          _messages.add({'role': 'ai', 'content': _goalQuestionContext});
        });
      } else if (userMessage.toLowerCase().contains('protein') ||
          userMessage.toLowerCase().contains('agirlikli')) {
        _dietType = 'Protein Agirlikli';
        setState(() {
          _messages.add({'role': 'ai', 'content': _goalQuestionContext});
        });
      } else if (userMessage.toLowerCase().contains('normal')) {
        _dietType = 'Normal';
        setState(() {
          _messages.add({'role': 'ai', 'content': _goalQuestionContext});
        });
      } else {
        setState(() {
          _messages.add({'role': 'ai', 'content': _dietTypeQuestion});
        });
      }
    }
//goal bilgisi al
    else if (_goal == null) {
      if (userMessage.toLowerCase().contains('kilo almak')) {
        _goal = 'Kilo Almak';

        setState(() {
          _messages.add({
            'role': 'ai',
            'content':
                'Kilo almak için önerilen beslenme programını sağlıyorum.Lütfen biraz bekleyin...'
          });
        });
        String? mealPlan = await _getMealPlan();
        _messages.add({'role': 'ai', 'content': mealPlan ?? 'HATALI GİRİŞ'});
      } else if (userMessage.toLowerCase().contains('kilo vermek')) {
        _goal = 'Kilo Vermek';

        setState(() {
          _messages.add({
            'role': 'ai',
            'content':
                'Kilo vermek için önerilen beslenme programını sağlıyorum.Lütfen biraz bekleyin...'
          });
        });
        String? mealPlan = await _getMealPlan();
        _messages.add({'role': 'ai', 'content': mealPlan ?? 'HATALI GİRİŞ'});
      } else {
        setState(() {
          _messages.add({'role': 'ai', 'content': _goalQuestionContext});
        });
      }
    } else {
      // ai ile konuşmaya devam
      _messages.add({'role': 'ai', 'content': 'Lütfen biraz bekleyin.....'});
      String? response = await _geminiAI.geminiTextPrompt(userMessage);
      if (response != null) {
        responsePrepare(response);
      }
    }
  }

  Future<String?> _getMealPlan() async {
    if (_dietType != null && _goal != null) {
      String query = "beslenme türüm:$_dietType hedefim:$_goal";
      //default test amaçlı text verilmiştir ileride değiştirilecek.
      String? response = await _geminiAI.geminiTextPrompt(
          'Kullanıcı bilgilerine göre günlük öğünlerin diyet listesini ve sağlıklı beslenme hakkında bilgi vermelisin. Kullanıcı bilgisi; $query -Yaş:28  cinsiyet:kadın');

// ai den cevap alındıysa
      if (response != null) {
        responsePrepare(response);
        return "Sormak istediğiniz başka birşey var mı?";
      }

      // AI hatası durumunda otomatik liste önerisi yap
      else {
        print('API isteğinde bir hata oluştu');
        _messages.add({'role': 'ai', 'content': aiErrorMessage});

        if (_dietType == 'Vejetaryen') {
          return _goal == 'Kilo Almak'
              ? 'Kilo almak için önerilen vejetaryen beslenme planı:\n'
                  'Kahvaltı: Yulaf ezmesi, chia tohumu, badem sütü, meyve\n'
                  'Ara Öğün: Yoğurt ve granola\n'
                  'Öğle: Mercimek köftesi, kinoa, yeşil salata\n'
                  'Ara Öğün: Avokado ve tam buğday ekmeği\n'
                  'Akşam: Sebzeli kinoa pilavı, zeytinyağlı enginar\n'
                  'Tatlı: Meyve salatası'
              : 'Kilo vermek için önerilen vejetaryen beslenme planı:\n'
                  'Kahvaltı: Sütlü chia pudingi, taze meyveler\n'
                  'Ara Öğün: Sebze çubukları ve humus\n'
                  'Öğle: Izgara sebzeler ve yoğurtlu soslu salata\n'
                  'Ara Öğün: Bir avuç badem\n'
                  'Akşam: Sebze çorbası ve tam buğday ekmeği\n'
                  'Tatlı: Az şekerli yoğurt';
        } else if (_dietType == 'Etçil') {
          return _goal == 'Kilo Almak'
              ? 'Kilo almak için önerilen etçil beslenme planı:\n'
                  'Kahvaltı: Yumurta beyazı omleti, tam buğday ekmeği, avokado\n'
                  'Ara Öğün: Peynir ve ceviz\n'
                  'Öğle: Izgara tavuk göğsü, kahverengi pirinç, sebze\n'
                  'Ara Öğün: Smoothie (süt, muz, protein tozu)\n'
                  'Akşam: Kırmızı et, patates püresi, sebze garnitürü\n'
                  'Tatlı: Protein bar'
              : 'Kilo vermek için önerilen etçil beslenme planı:\n'
                  'Kahvaltı: Yumurta beyazı ile hazırlanmış sebzeli omlet\n'
                  'Ara Öğün: Taze meyve ve yoğurt\n'
                  'Öğle: Izgara balık, kinoa ve sebze salatası\n'
                  'Ara Öğün: Bir avuç fındık\n'
                  'Akşam: Tavuk göğsü, haşlanmış sebzeler\n'
                  'Tatlı: Şekersiz puding';
        } else if (_dietType == 'Protein Agirlikli') {
          return _goal == 'Kilo Almak'
              ? 'Kilo almak için önerilen protein ağırlıklı beslenme planı:\n'
                  'Kahvaltı: Yüksek proteinli smoothie (süt, protein tozu, yulaf)\n'
                  'Ara Öğün: Süzme yoğurt ve meyve\n'
                  'Öğle: Izgara tavuk, quinoa ve sebzeler\n'
                  'Ara Öğün: Protein bar\n'
                  'Akşam: Izgara biftek, patates ve sebzeler\n'
                  'Tatlı: Proteinli sütlü tatlı'
              : 'Kilo vermek için önerilen protein ağırlıklı beslenme planı:\n'
                  'Kahvaltı: Yüksek proteinli yoğurt ve meyve\n'
                  'Ara Öğün: Sebze çubukları ve humus\n'
                  'Öğle: Izgara balık, yeşil salata ve kinoa\n'
                  'Ara Öğün: Bir avuç badem\n'
                  'Akşam: Tavuk göğsü, haşlanmış brokoli\n'
                  'Tatlı: Az şekerli sütlü tatlı';
        } else if (_dietType == 'Normal') {
          return _goal == 'Kilo Almak'
              ? 'Kilo almak için önerilen normal beslenme planı:\n'
                  'Kahvaltı: 2 tam yumurta ve 2 yumurta beyazı (omelet veya haşlanmış),1 dilim tam buğday ekmeği veya tam tahıllı ekmek,1 avokado (dilimlenmiş veya ezilmiş), 1 kase yulaf ezmesi (süt ve bal veya fıstık ezmesi ile), 1 bardak taze sıkılmış meyve suyu veya süt\n'
                  'Ara Öğün: 1 avuç ceviz veya badem,1 adet muz veya başka bir meyv\n'
                  'Öğle:Izgara tavuk göğsü, balık veya kırmızı et (yaklaşık 200-250 gram),Esmer pirinç veya tam tahıllı makarna (1 porsiyon),Buharda pişirilmiş veya ızgara sebzeler (brokoli, havuç, kabak vb.),Yeşil salata (zeytinyağı ve limon ile)\n'
                  'Ara Öğün:1 bardak smoothie (süt, yoğurt, muz, yulaf, fıstık ezmesi gibi malzemelerle),Bir avuç kuru yemiş (fındık, fıstık, kaju vb.)n'
                  'Akşam: Izgara veya fırında pişirilmiş balık veya tavuk (200-250 gram),Kinoa, bulgur veya tam buğday makarna (1 porsiyon),Zeytinyağı ile hazırlanmış salata (çeşitli sebzelerle),Tam tahıllı ekmek (1 dilim)\n'
                  'Gece Atıştırmalığı:1 kase yoğurt (meyve parçaları ve fıstık ezmesi ekleyebilirsiniz),Bir avuç kuru meyve (kuru üzüm, kayısı, hurma vb.)'
              : 'Kilo vermek için önerilen normal beslenme planı:\n'
                  'Kahvaltı: 1 kase yulaf ezmesi (su veya yağsız süt ile hazırlanmış),1 adet muz veya elma,Bir avuç badem veya ceviz,Yeşil çay veya şekersiz kahve\n'
                  'Ara Öğün: 1 adet yoğurt (yağsız veya az yağlı),Bir avuç meyve (örneğin, çilek, üzüm)\n'
                  'Öğle: Izgara tavuk göğsü veya balık (yaklaşık 150-200 gram),Bulgur pilavı veya esmer pirinç (yarım porsiyon),Buharda pişirilmiş sebzeler (brokoli, havuç, kabak vb.),Yeşil salata (az zeytinyağı ve limon ile)\n'
                  'Ara Öğün:1 adet meyve (örneğin, armut, portakal),Bir avuç fındık veya badem\n'
                  'Akşam: Izgara veya haşlanmış sebzeler (karnabahar, kabak, patlıcan vb.),Mercimek çorbası veya sebze çorbası,1 dilim tam buğday ekmeği\n'
                  'Gece Atıştırmalığı (İhtiyaç Halinde): Bir bardak bitki çayı (örneğin, papatya veya adaçayı,1 küçük porsiyon meyve (örneğin, elma dilimleri)';
        }
      }
    } else {
      return 'Beslenme türü ve hedef belirtilmedi.';
    }
    return null;
  }

  void responsePrepare(String response) {
    try {
      List<String> responseList = split(response);
      setState(() {
        responseList.forEach(
            (element) => _messages.add({'role': 'ai', 'content': element}));
      });
    } catch (e) {
      print('Yanıtı işlerken bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Diyet Asistanı'),
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
                    alignment: isUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
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

  List<String> split(String textInput) {
    String updatedText = textInput.replaceAll("**", "•");
    updatedText = updatedText.replaceAll("*", "-");
    List<String> dietAdvice = updatedText.split('\n\n');
    print("split-----${dietAdvice.length}------");
    return dietAdvice;
  }
}
