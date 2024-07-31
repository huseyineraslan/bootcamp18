import 'dart:async';
import 'package:bootcamp_app_18/models/new_user_model.dart';
import 'package:bootcamp_app_18/pages/home_page.dart';
import 'package:bootcamp_app_18/provider/app_provider.dart';
import 'package:bootcamp_app_18/service/firebase_auth.dart';
import 'package:bootcamp_app_18/service/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({
    super.key,
  });

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final AuthService _firebaseService = AuthService();
  late AppProvider appProvider;
  String? email;

  String? _selectedWeight;
  String? _selectedHeight;
  String? _selectedSteps;
  String? _selectedAge;
  String? _selectedGender;

  bool _isSaved = false;

  NewUser? activeUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appProvider = Provider.of<AppProvider>(context);
    email = appProvider.activeUserEmail ?? "";
    if (email != null) {
      getActiveUserInfo(email!);
    }
  }

  Future<void> _saveProfileInformation() async {
    //  profil bilgilerini kaydet

    if (activeUser != null) {
      // Eğer yeni değerler seçilmişse, activeUser objesini güncelle
      activeUser?.weight = _selectedWeight ?? activeUser?.weight;
      activeUser?.height = _selectedHeight ?? activeUser?.height;
      activeUser?.age = _selectedAge ?? activeUser?.age;
      activeUser?.gender = _selectedGender ?? activeUser?.gender;
      activeUser?.steps = _selectedSteps ?? activeUser?.steps;

      // Güncellenmiş bilgileri Shared Preferences'e kaydet
      await SharedPrefService.saveUserInfo(activeUser!);

      // UI'yı güncelle
      setState(() {
        _isSaved = true;
      });

      saveInfoMessage('Profil bilgileri kaydedildi.');
    } else {
      // Kullanıcı bilgisi yoksa ya da hatalı ise uygun bir mesaj göster
      saveInfoMessage('Kullanıcı bilgileri bulunamadı veya güncellenemedi.');
    }
  }

  void saveInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
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
        //appbar
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profil', style: Theme.of(context).textTheme.headlineSmall),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _firebaseService.signOut();
                  Provider.of<AppProvider>(context, listen: false)
                      .logout(context);
                },
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ),

        //body
        body: Consumer<AppProvider>(builder: (context, appProvider, child) {
          return Container(
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
                    // profil avatar
                    const Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage('lib/assets/images/profile_picpp.jpg'),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Kullanıcı name hoşgeldiniz
                    Center(
                      child: Text(activeUser?.name != null
                          ? "Hoşgeldin 👋🏻 ${activeUser!.name!.toUpperCase()} 🚀"
                          : "$email 🚀"),
                    ),
                    const SizedBox(height: 20),
                    // Boy - Kilo dropdown
                    Row(
                      children: [
                        Expanded(
                            child: _buildDropdownField('Boy', 'Boy (cm)',
                                _selectedHeight, _updateHeight,
                                enabled: !_isSaved, start: 130)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _buildDropdownField('Kilo', 'Kilo (kg)',
                                _selectedWeight, _updateWeight,
                                enabled: !_isSaved, start: 40)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // adım sayar - Yaş dropdown
                    Row(
                      children: [
                        Expanded(
                            child: _buildDropdownField('Adım Sayısı',
                                'Adım Sayar', _selectedSteps, _updateSteps,
                                enabled: !_isSaved, readOnly: true)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _buildDropdownField(
                                'Yaş', 'Yaş', _selectedAge, _updateAge,
                                enabled: !_isSaved, start: 15)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Gender dropdown
                    _buildGenderDropdown(),
                    const SizedBox(height: 20),
                    // Ek bilgi kutucuğu
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
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Save button
                    ElevatedButton(
                      onPressed: !_isSaved ? _saveProfileInformation : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Bilgileri Kaydet'),
                    ),
                    const SizedBox(height: 10),
                    // Değişiklik yap button
                    ElevatedButton.icon(
                      onPressed: _isSaved ? _enableDataEntry : null,
                      icon: const Icon(Icons.add),
                      label: const Text('Veri Ekle - Değişiklik Yap'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  Future<void> getActiveUserInfo(String email) async {
    activeUser = await SharedPrefService.getUserInfo(email);
    if (mounted) {
      setState(() {
        // Kullanıcı verileri UI'da güncellendi
        _selectedWeight = activeUser?.weight;
        _selectedHeight = activeUser?.height;
        _selectedAge = activeUser?.age;
        _selectedGender = activeUser?.gender;
        _selectedSteps = activeUser?.steps;
      });
    }
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
