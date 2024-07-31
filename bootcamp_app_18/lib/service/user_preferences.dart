import 'dart:convert';
import 'package:bootcamp_app_18/models/new_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  // Kullanıcı bilgilerini kaydet
  static Future<void> saveUserInfo(NewUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString(user.email!, userJson);
  }

  // Kullanıcı bilgilerini yükle
  static Future<NewUser?> getUserInfo(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(email); // Email'i anahtar olarak kullan
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return NewUser.fromJson(userMap);
    }
    return null;
  }

  void updateUserProfile(NewUser userInfo) async {
    // Mevcut bilgileri Shared Preferences'den alın
    NewUser? user = await SharedPrefService.getUserInfo(userInfo.email!);

    if (user != null) {
      // Güncellemeleri yap
      user.age = userInfo.age;
      user.height = userInfo.height;
      user.weight = userInfo.weight;
      user.gender = userInfo.gender;
      user.additionalInfo = userInfo.additionalInfo;
      // Güncellenmiş bilgileri kaydet
      SharedPrefService.saveUserInfo(user);
    }
  }

  // Kullanıcı bilgilerini temizle
  static Future<void> clearUserInfo(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(email);
  }
}
