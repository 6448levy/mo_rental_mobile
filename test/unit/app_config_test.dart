import 'package:carrental/app/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig (default build — no --dart-define)', () {
    test('defaults to the dev environment', () {
      expect(AppConfig.environment, Environment.dev);
    });

    test('dev base URL points at the local backend', () {
      expect(AppConfig.baseUrl, 'http://13.61.185.238:5050');
    });

    test('verbose logging is enabled outside production', () {
      expect(AppConfig.enableVerboseLogging, isTrue);
      expect(AppConfig.isProduction, isFalse);
    });

    test('exposes a sane API timeout and JSON headers', () {
      expect(AppConfig.apiTimeout, const Duration(seconds: 30));
      expect(AppConfig.defaultHeaders['Content-Type'], 'application/json');
    });
  });
}
