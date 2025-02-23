import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<void> saveUserAuthToLocalStorage(String token) async {
    final prefs = await _prefs;

    await prefs.setString('token', token);
  }

  static Future<Map<String, String?>> getUserAuthFromLocalStorage() async {
    final prefs = await _prefs;

    final token = prefs.getString('token');

    return {'token': token};
  }

  static Future<void> removeUserAuthFromLocalStorage() async {
    final prefs = await _prefs;

    await prefs.remove('token');
  }
}
