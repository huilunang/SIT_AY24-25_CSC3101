import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<void> saveUserAuthToLocalStorage(
      String userId, String token) async {
    final prefs = await _prefs;
    await prefs.setString('user_id', userId);
    await prefs.setString('token', token);
  }

  static Future<Map<String, String?>> getUserAuthFromLocalStorage() async {
    final prefs = await _prefs;
    final userId = prefs.getString('user_id');
    final token = prefs.getString('token');

    return {'userId': userId, 'token': token};
  }

  static Future<void> removeUserAuthFromLocalStorage() async {
    final prefs = await _prefs;
    await prefs.remove('user_id');
    await prefs.remove('token');
  }
}
