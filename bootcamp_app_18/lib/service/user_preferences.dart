import 'dart:convert';
import 'package:bootcamp_app_18/models/new_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPreferences? _prefs;

  // SharedPreferences'i başlat
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Kullanıcı bilgilerini kaydet
  static Future<void> saveUserInfo(NewUser user) async {
    String userJson = jsonEncode(user.toJson());
    await _prefs?.setString(user.email!, userJson);
  }

  // Kullanıcı bilgilerini yükle
  static Future<NewUser?> getUserInfo(String email) async {
    String? userJson =
        _prefs?.getString(email); // Email'i anahtar olarak kullan
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return NewUser.fromJson(userMap);
    }
      NewUser newUser=NewUser(email: email, name: "Bilinmiyor", age: null, height: null, weight: null, additionalInfo: null, gender: null, steps: null);
      SharedPrefService.saveUserInfo(newUser);
     return newUser;
  }

  static Future<void> updateUserProfile(NewUser userInfo) async {
    // Mevcut bilgileri Shared Preferences'den alın
    NewUser? user = await getUserInfo(userInfo.email!);

    if (user != null) {
      // Güncellemeleri yap
      user.age = userInfo.age;
      user.height = userInfo.height;
      user.weight = userInfo.weight;
      user.gender = userInfo.gender;
      user.additionalInfo = userInfo.additionalInfo;
      // Güncellenmiş bilgileri kaydet
      saveUserInfo(user);
    }
  }

  // Kullanıcı bilgilerini temizle
  static Future<void> clearUserInfo(String email) async {
    await _prefs?.remove(email);
  }
}
