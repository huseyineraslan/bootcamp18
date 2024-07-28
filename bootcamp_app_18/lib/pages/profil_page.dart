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
  String? _selectedWeight;
  String? _selectedHeight;
  String? _selectedSteps;
  String? _selectedAge;
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
        _stepCount++;
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

  void _enableDataEntry() {
    setState(() {
      _isSaved = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Profil', style: Theme.of(context).textTheme.headlineSmall),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _firebaseService.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.secondary, Colors.red],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        AssetImage('lib/assets/images/profile_picpp.jpg'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: _buildDropdownField(
                            'Boy', 'Boy (cm)', _selectedHeight, _updateHeight,
                            enabled: !_isSaved, start: 135)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildDropdownField(
                            'Kilo', 'Kilo (kg)', _selectedWeight, _updateWeight,
                            enabled: !_isSaved, start: 40)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: _buildDropdownField('Adım Sayar', 'Adım Sayar',
                            _selectedSteps, _updateSteps,
                            enabled: !_isSaved, readOnly: true)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildDropdownField(
                            'Yaş', 'Yaş', _selectedAge, _updateAge,
                            enabled: !_isSaved, start: 15)),
                  ],
                ),
                const SizedBox(height: 10),
                _buildGenderDropdown(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(color: Colors.white70),
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
                        'Adım sayınız hedeflenenin altında.',
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: !_isSaved ? _saveProfileInformation : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Bilgileri Kaydet'),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _isSaved ? _enableDataEntry : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Veri Ekle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateHeight(String? newValue) {
    setState(() {
      _selectedHeight = newValue;
    });
  }

  void _updateWeight(String? newValue) {
    setState(() {
      _selectedWeight = newValue;
    });
  }

  void _updateSteps(String? newValue) {
    setState(() {
      _selectedSteps = newValue;
    });
  }

  void _updateAge(String? newValue) {
    setState(() {
      _selectedAge = newValue;
    });
  }

  Widget _buildDropdownField(String label, String hintText, String? value,
      void Function(String?) onChanged,
      {bool enabled = true, bool readOnly = false, int start = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          items: _generateDropdownItems(start),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            labelText: hintText,
            border: const OutlineInputBorder(),
          ),
          disabledHint: Text(value ?? hintText),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _generateDropdownItems(int start) {
    return List.generate(100, (index) {
      final value = (index + start).toString();
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    });
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cinsiyet',
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 5),
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
            labelText: 'Cinsiyet',
            border: OutlineInputBorder(),
          ),
          disabledHint: Text(_selectedGender ?? 'Cinsiyet'),
        ),
      ],
    );
  }
}
