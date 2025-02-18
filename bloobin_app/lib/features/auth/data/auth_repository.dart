import 'package:bloobin_app/config/config.dart';
import 'package:bloobin_app/features/auth/data/user_model.dart';
import 'package:bloobin_app/features/auth/helper/auth_helper.dart';
import 'package:bloobin_app/utils/custom_exception.dart';
import 'package:bloobin_app/utils/logger.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final Dio dio = Dio();
  final logger = AppLogger();

  AuthRepository() {
    dio.options.baseUrl = Config.baseServerUrl;
  }

  Future<void> signIn(String email, String password) async {
    try {
      final res = await dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (res.statusCode == 200) {
        final data = UserSignInModel.fromJson(res.data);
        await AuthHelper.saveUserAuthToLocalStorage(
            data.userId.toString(), data.jwtToken);

        logger.logInfo("User '$email' login success");
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorMessage =
            e.response!.data["error"] ?? "Unknown error occurred";
        throw CustomException(errorMessage);
      } else {
        throw CustomException("Network error. Please try again.");
      }
    } catch (e) {
      logger.logError("Unexpected error when signing in: $e");
      throw CustomException("An unexpected error occurred. Please try again.");
    }
  }

  Future<void> signUp(
      String email, String password, String confirmPassword) async {
    try {
      await dio.post('/register', data: {
        'email': email,
        'password': password,
        'confirm_password': confirmPassword
      });

      logger.logInfo("User '$email' successfully created");
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorMessage =
            e.response!.data["error"] ?? "Unknown error occurred";
        throw CustomException(errorMessage);
      } else {
        throw CustomException("Network error. Please try again.");
      }
    } catch (e) {
      logger.logError("Unexpected error when signing up: $e");
      throw CustomException("An unexpected error occurred. Please try again.");
    }
  }
}
