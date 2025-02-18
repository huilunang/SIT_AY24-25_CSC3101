import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() {
    return _instance;
  }

  late Logger logger;

  AppLogger._internal() {
    logger = Logger(
      filter: ProductionFilter(),
      printer: PrettyPrinter(),
      output: ConsoleOutput(),
    );
  }

  void logInfo(String message) => logger.i(message);
  void logWarning(String message) => logger.w(message);
  void logError(String message) => logger.e(message);
  void logDebug(String message) => logger.d(message);
}
