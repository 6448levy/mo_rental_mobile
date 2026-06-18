// core/utils/app_logger.dart
import 'package:logger/logger.dart';
import '../config/app_config.dart';

/// Centralized logging. Verbose output is automatically silenced in production
/// (see [AppConfig.enableVerboseLogging]); warnings/errors always emit.
///
/// Prefer this over `print()` everywhere. Never log secrets, tokens, full card
/// numbers, or other PII.
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    level: AppConfig.enableVerboseLogging ? Level.debug : Level.warning,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  static void d(dynamic message) => _logger.d(message);
  static void i(dynamic message) => _logger.i(message);
  static void w(dynamic message) => _logger.w(message);
  static void e(dynamic message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
