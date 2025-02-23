import 'dart:io';

import 'package:bloobin_app/config/config.dart';
import 'package:bloobin_app/features/auth/helper/auth_helper.dart';
import 'package:bloobin_app/features/recycle/data/recycle_result_model.dart';
import 'package:bloobin_app/utils/custom_exception.dart';
import 'package:bloobin_app/utils/logger.dart';
import 'package:dio/dio.dart';

class RecycleRepository {
  final Dio dio = Dio();
  final logger = AppLogger();

  late String _token;

  RecycleRepository() {
    dio.options.baseUrl = Config.baseServerUrl;
    initialize();
  }

  Future<void> initialize() async {
    final userAuth = await AuthHelper.getUserAuthFromLocalStorage();
    _token = userAuth['token'] ?? '';
    dio.options.headers['authorization'] = _token;
  }

  Future<RecycleResultModel> analyzeImage(File imageFile) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path,
            filename: imageFile.path.split('/').last),
      });

      final res = await dio.post('/recycle_transactions', data: formData);

      return RecycleResultModel.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorMessage =
            e.response!.data["error"] ?? "Unknown error occurred";
        throw CustomException(errorMessage);
      } else {
        logger.logError(e.toString());
        throw CustomException("Network error. Please try again.");
      }
    } catch (e) {
      logger.logError("Unexpected error when recycling: $e");
      throw CustomException("An unexpected error occurred. Please try again.");
    }
  }
}
