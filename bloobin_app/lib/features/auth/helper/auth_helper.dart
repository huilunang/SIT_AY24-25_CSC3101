import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<void> saveUserIdToLocalStorage(String userId) async {
    final prefs = await _prefs;
    await prefs.setString('user_id', userId);
  }

  static Future<String?> getUserIdFromLocalStorage() async {
    final prefs = await _prefs;
    return prefs.getString('user_id');
  }

  static Future<void> removeUserIdFromLocalStorage() async {
    final prefs = await _prefs;
    await prefs.remove('user_id');
  }
}
