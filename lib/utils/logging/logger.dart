import 'package:logger/logger.dart';

class AppLoggerHelper {
  // Logger instance with pretty print & debug level
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
    level: Level.debug,
  );

  // Debug log
  static void debug(String message) {
    _logger.d(message);
  }

  // Info log
  static void info(String message) {
    _logger.i(message);
  }

  // Warning log
  static void warning(String message) {
    _logger.w(message);
  }

  // Error log with optional error & stacktrace
  static void error(String message, [dynamic error]) {
    _logger.e(message, error: error, stackTrace: StackTrace.current);
  }
}
