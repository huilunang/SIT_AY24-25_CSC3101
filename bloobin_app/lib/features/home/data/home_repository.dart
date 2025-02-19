import 'dart:convert';

import 'package:bloobin_app/config/config.dart';
import 'package:bloobin_app/features/auth/helper/auth_helper.dart';
import 'package:bloobin_app/features/home/domain/catalogue.dart';
import 'package:bloobin_app/features/home/domain/chart_data.dart';
import 'package:bloobin_app/features/home/domain/home.dart';
import 'package:bloobin_app/features/home/domain/points.dart';
import 'package:bloobin_app/features/home/domain/rewards.dart';
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
      final res =
          await dio.post('/home', data: {'user_id': _userId, 'interval': frequency});

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
      const mockResponse = '''
      [
        {
          "date": "2024-11-11T00:00:00Z",
          "descriptions": [
            "+ 3 pts from recycling",
            "- 100 pts to redeem voucher",
            "+ 3 pts from recycling"
          ]
        },
        {
          "date": "2024-12-11T00:00:00Z",
          "descriptions": [
            "+ 2 pts from recycling",
            "- 50 pts to redeem voucher",
            "- 100 pts to redeem voucher",
            "+ 3 pts from recycling"
          ]
        },
        {
          "date": "2024-01-11T00:00:00Z",
          "descriptions": [
            "+ 2 pts from recycling",
            "- 50 pts to redeem voucher",
            "- 100 pts to redeem voucher",
            "+ 3 pts from recycling"
          ]
        }
      ]
      ''';

      final List<dynamic> jsonData = jsonDecode(mockResponse);

      final Map<String, List<String>> transactionData = {};
      for (var transaction in jsonData) {
        final date = transaction['date'] as String;
        final descriptions = List<String>.from(transaction['descriptions']);
        transactionData[date] = descriptions;
      }

      return Points(transactionData: transactionData);
    } catch (e) {
      throw Exception("Error fetching transactions: $e");
    }
  }

  Future<List<Rewards>> fetchRewardDetails() async {
    try {
      const mockResponse = '''
      [
        { "id": "1", "name": "\$5 HPB Voucher", "validDate": "2024-03-00T00:00:00Z" },
        { "id": "2", "name": "\$10 Fairprice Voucher", "validDate": "2024-04-00T00:00:00Z" },
        { "id": "3", "name": "\$10 HPB Voucher", "validDate": "2024-04-00T00:00:00Z" },
        { "id": "2", "name": "\$10 Fairprice Voucher", "validDate": "2024-04-00T00:00:00Z" },
        { "id": "3", "name": "\$10 HPB Voucher", "validDate": "2024-04-00T00:00:00Z" },
        { "id": "2", "name": "\$10 Fairprice Voucher", "validDate": "2024-04-00T00:00:00Z" }
      ]
      ''';

      final List<dynamic> jsonData = jsonDecode(mockResponse);

      return jsonData
          .map((item) => Rewards(
                item['id'],
                item['name'],
                item['validDate'],
              ))
          .toList();
    } catch (e) {
      throw Exception("Error fetching rewards: $e");
    }
  }

  Future<List<Catalogue>> fetchCatalogueDetails() async {
    try {
      const mockResponse = '''
      [
        { "id": "1", "name": "\$5 HPB Voucher", "cost": 100 },
        { "id": "2", "name": "\$10 Fairprice Voucher", "cost": 200 },
        { "id": "3", "name": "\$10 HPB Voucher", "cost": 200 },
        { "id": "2", "name": "\$10 Fairprice Voucher", "cost": 200 },
        { "id": "3", "name": "\$10 HPB Voucher", "cost": 200 },
        { "id": "2", "name": "\$10 Fairprice Voucher", "cost": 200 }
      ]
      ''';

      final List<dynamic> jsonData = jsonDecode(mockResponse);

      return jsonData
          .map((item) => Catalogue(
                item['id'],
                item['name'],
                item['cost'],
              ))
          .toList();
    } catch (e) {
      throw Exception("Error fetching rewards: $e");
    }
  }
}
