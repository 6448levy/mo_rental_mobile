import '../config/app_config.dart';

class ApiConstants {
  // Base URL is resolved per-environment from AppConfig (single source of truth).
  // Select with --dart-define=ENV=dev|staging|prod (see AppConfig).
  static String get baseUrl => AppConfig.baseUrl;

  // Auth Endpoints (Ensure leading slash)
  static const String register = '/api/v1/users/register';
  static const String verifyEmail = '/api/v1/users/verify-email';
  static const String login = '/api/v1/users/login';
  // NOTE: backend has no verification-resend endpoint. For password reset use
  // /api/v1/users/forgot-password/request-otp instead.

  // Safe URL Joining Loophole Fix
  static String join(String endpoint) {
    String base = baseUrl;
    if (base.endsWith('/')) base = base.substring(0, base.length - 1);
    String path = endpoint;
    if (!path.startsWith('/')) path = '/$path';
    return '$base$path';
  }

  // Common Headers
  static const Map<String, String> headers = AppConfig.defaultHeaders;

  static const Duration apiTimeout = AppConfig.apiTimeout;
}