import 'package:bloobin_app/features/auth/helper/auth_helper.dart';

class AuthRepository {
  Future<void> signIn(String email, String password) async {
    // TODO: Handle req to server
    final userId = '1';

    await AuthHelper.saveUserIdToLocalStorage(userId);
  }

  void signUp(String email, String password, String confirmPassword) {
    // TODO: Handle req to server
  }
}
