import 'dart:convert';
import 'dart:io';

import 'package:bloobin_app/features/recycle/data/recycle_result_model.dart';

class RecycleRepository {
  Future<RecycleResultModel> analyzeImage(File imageFile) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      const mockResponse = '''
      {
        "material": "Plastic Bottle",
        "points": 1
      }
      ''';

      final Map<String, dynamic> jsonData = jsonDecode(mockResponse);

      return RecycleResultModel.fromJson(jsonData);
    } catch (e) {
      throw Exception("Error fetching home details: $e");
    }
  }
}
