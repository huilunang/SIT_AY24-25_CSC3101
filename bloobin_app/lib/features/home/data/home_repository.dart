import 'package:bloobin_app/config/config.dart';
import 'package:bloobin_app/features/auth/helper/auth_helper.dart';
import 'package:bloobin_app/features/home/domain/catalogue.dart';
import 'package:bloobin_app/features/home/domain/chart_data.dart';
import 'package:bloobin_app/features/home/domain/home.dart';
import 'package:bloobin_app/features/home/domain/points.dart';
import 'package:bloobin_app/features/home/domain/reward.dart';
import 'package:bloobin_app/utils/custom_exception.dart';
import 'package:bloobin_app/utils/logger.dart';
import 'package:dio/dio.dart';

class HomeRepository {
  final Dio dio = Dio();
  final logger = AppLogger();

  late int _userId;
  late String _token;

  HomeRepository() {
    dio.options.baseUrl = Config.baseServerUrl;
    initialize();
  }

  Future<void> initialize() async {
    final userAuth = await AuthHelper.getUserAuthFromLocalStorage();

    _userId = int.tryParse(userAuth['userId'] ?? '') ?? 0;
    _token = userAuth['token'] ?? '';
  }

  Future<Home> fetchHomeDetails({String frequency = 'Daily'}) async {
    try {
      final res = await dio
          .post('/home', data: {'user_id': _userId, 'interval': frequency});

      final Map<String, dynamic> jsonData = res.data['data'];

      final List<ChartData> chartData =
          (jsonData['chart_data'] as List<dynamic>?)
                  ?.map((item) => ChartData(
                        item['date'],
                        item['type'],
                        item['count'],
                      ))
                  .toList() ??
              [];

      final List<String> types = (jsonData['types'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [];

      return Home(
        jsonData['points'].toString(),
        jsonData['vouchers'].toString(),
        types,
        chartData,
      );
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
      logger.logError("Unexpected error when accessing home details: $e");
      throw CustomException("An unexpected error occurred. Please try again.");
    }
  }

  Future<Points> fetchPointDetails() async {
    try {
      final res = await dio.post('/transaction', data: {'user_id': _userId});

      final List<dynamic> jsonData = res.data['data'];

      final Map<String, List<String>> transactionData = {};
      for (var transaction in jsonData) {
        final date = transaction['date'] as String;
        transactionData[date] = List<String>.from(transaction['descriptions']);
      }

      return Points(transactionData: transactionData);
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
      logger
          .logError("Unexpected error when accessing transaction history: $e");
      throw CustomException("An unexpected error occurred. Please try again.");
    }
  }

  Future<List<Reward>> fetchRewardDetails() async {
    try {
      final res = await dio
          .post('/reward_transaction/retrieve', data: {'user_id': _userId});

      final List<dynamic> jsonData = res.data['data'];

      return jsonData
          .map((item) => Reward(
                item['id'],
                item['voucher_name'],
                item['voucher_serial'],
                item['valid_date'],
              ))
          .toList();
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
      logger.logError("Unexpected error when accessing claimable vouchers: $e");
      if (e is CustomException) {
        rethrow;
      } else {
        throw CustomException(
            "An unexpected error occurred. Please try again.");
      }
    }
  }

  Future<List<Catalogue>> fetchCatalogueDetails() async {
    try {
      final res = await dio.get('/voucher_catalogues');

      final List<dynamic> jsonData = res.data['data'];

      return jsonData
          .map((item) => Catalogue(item['id'], item['voucher_name'],
              item['cost'], item["immediate_claim"]))
          .toList();
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
      logger.logError("Unexpected error when accessing reward catalogue: $e");
      throw CustomException("An unexpected error occurred. Please try again.");
    }
  }

  Future<int> redeemCatalogueVoucher(String points, Catalogue catalogue) async {
    try {
      int difference = int.parse(points) - catalogue.cost;
      if (difference < 0) {
        throw CustomException(
            "You are short of ${difference.abs()} pts to claim ${catalogue.name}");
      }

      await dio.post('/reward_transaction', data: {
        'voucher_name': catalogue.name,
        'points': catalogue.cost,
        'immediate_claim': catalogue.immediateClaim,
        'user_id': _userId
      });

      return difference;
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
      logger.logError(
          "Unexpected error when redeeming catalogue voucher using pts: $e");
      if (e is CustomException) {
        rethrow;
      } else {
        throw CustomException(
            "An unexpected error occurred. Please try again.");
      }
    }
  }

  Future<void> claimRewardVoucher(Reward reward) async {
    try {
      await dio.post('/reward_transaction/claim',
          data: {'voucher_serial': reward.serialNo, 'user_id': _userId});
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
      logger
          .logError("Unexpected error when claiming to use reward voucher: $e");
      if (e is CustomException) {
        rethrow;
      } else {
        throw CustomException(
            "An unexpected error occurred. Please try again.");
      }
    }
  }
}
