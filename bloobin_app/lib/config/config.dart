import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String baseServerUrl = dotenv.env['BASE_SERVER_URL'] ?? 'http://localhost:8080';
}