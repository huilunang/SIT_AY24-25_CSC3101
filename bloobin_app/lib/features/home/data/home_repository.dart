import 'dart:convert';

import 'package:bloobin_app/features/auth/helper/auth_helper.dart';
import 'package:bloobin_app/features/home/domain/catalogue.dart';
import 'package:bloobin_app/features/home/domain/chart_data.dart';
import 'package:bloobin_app/features/home/domain/home.dart';
import 'package:bloobin_app/features/home/domain/points.dart';
import 'package:bloobin_app/features/home/domain/rewards.dart';

class HomeRepository {
  late String _userId;

  HomeRepository() {
    initialize();
  }

  Future<void> initialize() async {
    _userId = await AuthHelper.getUserIdFromLocalStorage() ?? '';
  }

  Future<Home> fetchHomeDetails({String frequency = 'Daily'}) async {
    try {
      const mockResponse = '''
      {
        "point": "105",
        "reward": "20",
        "chartData": [
          { "date": "2024-11-11T00:00:00Z", "type": "Plastic", "count": 12 },
          { "date": "2024-12-11T00:00:00Z", "type": "Cardboard", "count": 8 },
          { "date": "2024-12-31T00:00:00Z", "type": "Metal", "count": 5 },
          { "date": "2025-01-02T00:00:00Z", "type": "Plastic", "count": 10 },
          { "date": "2025-01-02T00:00:00Z", "type": "Cardboard", "count": 6 },
          { "date": "2025-01-02T00:00:00Z", "type": "Metal", "count": 3 },
          { "date": "2025-01-03T00:00:00Z", "type": "Plastic", "count": 6 }
        ]
      }
      ''';

      final Map<String, dynamic> jsonData = jsonDecode(mockResponse);

      final List<ChartData> chartData = (jsonData['chartData'] as List<dynamic>)
          .map((item) => ChartData(
                item['date'],
                item['type'],
                item['count'],
              ))
          .toList();

      return Home(
        jsonData['point'],
        jsonData['reward'],
        chartData,
      );
    } catch (e) {
      throw Exception("Error fetching home details: $e");
    }
  }

  Future<Points> fetchPointDetails() async {
    try {
      const mockResponse = '''
      {
        "2024-11-11T00:00:00Z": [
          "+ 3 pts from recycling",
          "- 100 pts to redeem voucher",
          "+ 3 pts from recycling"
        ],
        "2024-12-11T00:00:00Z": [
          "+ 2 pts from recycling",
          "- 50 pts to redeem voucher",
          "- 100 pts to redeem voucher",
          "+ 3 pts from recycling"
        ],
        "2024-01-11T00:00:00Z": [
          "+ 2 pts from recycling",
          "- 50 pts to redeem voucher",
          "- 100 pts to redeem voucher",
          "+ 3 pts from recycling"
        ]
      }
      ''';

      final Map<String, dynamic> jsonData = jsonDecode(mockResponse);
      final transactionData = jsonData.map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      );

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
