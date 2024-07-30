import 'package:bootcamp_app_18/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyEmail = 'email';
  static const String _keyName = 'name';
  static const String _keyAge = 'age';
  static const String _keyHeight = 'height';
  static const String _keyWeight = 'weight';
  static const String _keyGender = 'gender';
  static const String _keyAdditionalInfo = 'additional_info';

  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyAge, user.age);
    await prefs.setDouble(_keyHeight, user.height);
    await prefs.setDouble(_keyWeight, user.weight);
    await prefs.setString(_keyGender, user.gender);
    await prefs.setString(_keyAdditionalInfo, user.additionalInfo);
  }
}
