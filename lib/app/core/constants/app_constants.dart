import '../config/app_config.dart';

/// Legacy constants. Configuration now lives in [AppConfig] — prefer that.
/// These forwarders remain so older references keep compiling.
class AppConstants {
  @Deprecated('Use AppConfig.baseUrl')
  static String get baseUrl => AppConfig.baseUrl;

  static const String registerEndpoint = '/api/v1/users/register';
  static const String verifyEmailEndpoint = '/api/v1/users/verify-email';

  @Deprecated('Use AppConfig.apiTimeout')
  static const Duration apiTimeout = AppConfig.apiTimeout;

  @Deprecated('Use AppConfig.defaultHeaders')
  static const Map<String, String> headers = AppConfig.defaultHeaders;
}
