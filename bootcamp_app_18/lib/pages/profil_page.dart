import 'dart:async';
import 'package:bootcamp_app_18/pages/login_page.dart';
import 'package:bootcamp_app_18/service/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final AuthService _firebaseService = AuthService();

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _stepCountController = TextEditingController();
  final _ageController = TextEditingController();
  final _focusNode = FocusNode();
  String? _selectedGender;
  bool? _isValid;
  String? _errorMessage;
  String? _country;
  String? _location;
  String? _locInfo;
  String _name = 'hüseyin eraslan'; // Örnek koydum
  bool _isSaved = false;
  int _stepCount = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _startStepCounter(); // Adım sayar otomatik başlatılıyor
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _weightController.dispose();
    _heightController.dispose();
    _stepCountController.dispose();
    _ageController.dispose();
    _focusNode.dispose();
    _timer.cancel(); // Timer'i iptal et
    super.dispose();
  }

  void _startStepCounter() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _stepCount++; // Adım sayısı her saniye bir artıyor
      });
    });
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _validateWeightAndHeight();
    }
  }

  void _validateWeightAndHeight() async {
    // Simüle edilmiş boy ve kilo doğrulama
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isValid =
          true; // Burayı gerçek bir doğrulama servisi ile değiştirecez havva
      _country = 'Turkey';
      _location = 'Istanbul';
      _locInfo = 'Country: $_country, Location: $_location';
      _errorMessage = null;
    });
  }

  void _saveProfileInformation() {
    // Burada profil bilgilerini kaydedebilirsiniz
    setState(() {
      _isSaved = true;
    });
    // Bildirim gösterebilirsiniz
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil bilgileri kaydedildi.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Profil', style: Theme.of(context).textTheme.displayLarge),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            _firebaseService.signOut();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ])),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.white70],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.grey[300],
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'lib/assets/images/profile_16_9backimage.jpg', // Burada yolu değiştirin
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage('lib/assets/images/profile_pic.jpg'),
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: Image(
                              image: AssetImage(
                                  'lib/assets/images/profile_pic.jpg'),
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Boy',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    TextField(
                      controller: _heightController,
                      focusNode: _focusNode,
                      maxLength: 3,
                      decoration: const InputDecoration(
                        labelText: 'Boy (cm)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isSaved,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Kilo',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    TextField(
                      controller: _weightController,
                      focusNode: _focusNode,
                      maxLength: 3,
                      decoration: const InputDecoration(
                        labelText: 'Kilo (kg)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isSaved,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Adım Sayar',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    TextField(
                      controller: _stepCountController,
                      maxLength: 5,
                      readOnly: true, // Kullanıcı girişi engellendi
                      decoration: const InputDecoration(
                        labelText: 'Adım Sayar',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Yaş',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    TextField(
                      controller: _ageController,
                      focusNode: _focusNode,
                      maxLength: 3,
                      decoration: const InputDecoration(
                        labelText: 'Yaş',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isSaved,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Cinsiyet',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: ['Erkek', 'Kadın', 'Diğer'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: !_isSaved
                          ? (newValue) {
                              setState(() {
                                _selectedGender = newValue;
                              });
                            }
                          : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Cinsiyet',
                      ),
                      disabledHint: Text(_selectedGender ?? 'Seçilmedi'),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Durumunuz',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Buraya durumunuz yazılacak.',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: !_isSaved ? _saveProfileInformation : null,
                      child: const Text('Bilgileri Kaydet'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
