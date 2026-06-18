// core/config/app_config.dart
//
// Single source of truth for environment-specific configuration.
//
// Select the environment at build/run time with --dart-define:
//   flutter run                              -> dev   (local backend)
//   flutter run --dart-define=ENV=staging    -> staging
//   flutter build apk --dart-define=ENV=prod -> prod  (HTTPS backend)
//
// You can also override the base URL directly for one-off builds:
//   --dart-define=API_BASE_URL=https://api.example.com
//
// No secrets belong in this file or anywhere in source control. Anything
// sensitive (API keys, tokens) must be injected via --dart-define at build time.

enum Environment { dev, staging, prod }

class AppConfig {
  AppConfig._();

  static const String _envName =
      String.fromEnvironment('ENV', defaultValue: 'dev');

  /// Optional explicit override of the backend base URL.
  static const String _overrideBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static Environment get environment {
    switch (_envName) {
      case 'prod':
      case 'production':
        return Environment.prod;
      case 'staging':
      case 'stage':
        return Environment.staging;
      default:
        return Environment.dev;
    }
  }

  /// The backend base URL for the active environment.
  ///
  /// Dev defaults to the local HTTP server. Prod/staging have NO baked-in URL:
  /// the previously-noted Render URL was unreachable and is unconfirmed, so a
  /// prod/staging build MUST supply one explicitly to avoid silently shipping a
  /// dead endpoint:
  ///   --dart-define=ENV=prod --dart-define=API_BASE_URL=https://your-api
  static String get baseUrl {
    if (_overrideBaseUrl.isNotEmpty) return _overrideBaseUrl;
    switch (environment) {
      case Environment.prod:
      case Environment.staging:
        throw StateError(
          'No backend URL configured for ENV=$_envName. Pass '
          '--dart-define=API_BASE_URL=https://your-confirmed-api when building '
          'for $_envName. (The previous Render URL was unreachable.)',
        );
      case Environment.dev:
        return 'http://13.61.185.238:5050';
    }
  }

  static bool get isProduction => environment == Environment.prod;

  /// Verbose console logging is enabled outside production only.
  static bool get enableVerboseLogging => !isProduction;

  static const Duration apiTimeout = Duration(seconds: 30);

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
