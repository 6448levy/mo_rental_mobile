import 'package:logger/logger.dart';

/// Central logging utility for the MoRental application.
/// Use this instead of 'print' to ensure consistent formatting and
/// easy log management across debug and production environments.
class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 100, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat
          .dateAndTime, // Should each log print contain a timestamp
    ),
  );

  /// Log a message at level debug.
  static void debug(dynamic message) => _logger.d(message);

  /// Log a message at level info.
  static void info(dynamic message) => _logger.i(message);

  /// Log a message at level warning.
  static void warning(dynamic message) => _logger.w(message);

  /// Log a message at level error.
  static void error(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
