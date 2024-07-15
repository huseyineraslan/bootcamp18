import 'package:bootcamp_app_18/pages/login_page.dart';
import 'package:bootcamp_app_18/service/firebase_auth.dart';
import 'package:bootcamp_app_18/service/phone_validation_service.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final AuthService _firebaseService = AuthService();
  final _phoneNumberController = TextEditingController();

  //Phone number will be checked with _focusNode when writing is finished
  final _focusNode = FocusNode();
  bool? _isValid;
  String? _errorMessage;
  String? _country;
  String? _location;
  String? _locInfo;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _phoneNumberController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

// Telefon numarası değiştiğinde _validatePhoneNumber ı çağır
  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _validatePhoneNumber();
    }
  }

  void _validatePhoneNumber() async {
    if (!mounted) return; // Widget dispose edildiyse işlem yapma

    final service = PhoneValidationService();
    final phoneNumber = _phoneNumberController.text;

    try {
      final result = await service.validatePhoneNumber(phoneNumber);
      if (!mounted) return; // Widget dispose edildiyse işlem yapma

      //başarılı bir response gelirse bilgileri güncelle
      setState(() {
        _isValid = result['is_valid'];
        _country = result['country'];
        _location = result['location'];
        _locInfo = (_country != _location)
            ? 'Country: $_country, Location: $_location'
            : 'Country: $_country';

        _errorMessage = null;
      });
    } catch (e) {
      //Başarısız response
      if (!mounted) return; // Widget dispose edildiyse işlem yapma
      setState(() {
        _isValid = null;
        _country = null;
        _location = null;
        _locInfo = null;
        _errorMessage = 'Failed to validate phone number: $e';
      });
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
//----------------------------
            //Bu kısma farklı profil bilgi girş kısımları eklenecek
//----------------------------

/*
Dünya genelinde kullanılan telefon 
numaralarının maksimum uzunluğu genellikle 15 hane olarak kabul edilir.
Bu standart, Uluslararası Telekomünikasyon Birliği (ITU) tarafından belirlenen 
E.164 numaralandırma planına dayanmaktadır. E.164 formatında bir telefon numarası, 
ülke kodu da dahil olmak üzere maksimum 15 basamaktan oluşabilir.
*/
            //Geçerli Telefon Numarası kontrolü
            Row(
              children: [
                // Phone number text
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController,
                    focusNode: _focusNode,
                    maxLength: 15,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (+X0564XXXXXXX)',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                if (_isValid != null)
                  _isValid!
                      ? const Icon(Icons.check_circle,
                          color: Colors.green) //valid number icon
                      : const Icon(Icons.cancel,
                          color: Colors.red), //invalid number icon
              ],
            ),
            const SizedBox(height: 8),
            if (_errorMessage != null) //Geçersiz telefon numarası
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            if (_isValid != null &&
                _isValid! &&
                _locInfo != null) //Geçerli phone number
              Text(_locInfo!, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
