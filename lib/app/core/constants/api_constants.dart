class ApiConstants {
  // Use 127.0.0.1 for local development (standard for web/mobile)
  static const String baseUrl = 'http://13.61.185.238:5050';
  
  // Production URL (Found in notes)
  // static const String baseUrl = 'https://car-rental-backend-system.onrender.com';

  // Auth Endpoints (Ensure leading slash)
  static const String register = '/api/v1/users/register';
  static const String verifyEmail = '/api/v1/users/verify-email';
  static const String login = '/api/v1/users/login'; 
  static const String resendOtp = '/api/v1/users/resend-otp'; 
  
  // Safe URL Joining Loophole Fix
  static String join(String endpoint) {
    String base = baseUrl;
    if (base.endsWith('/')) base = base.substring(0, base.length - 1);
    String path = endpoint;
    if (!path.startsWith('/')) path = '/$path';
    return '$base$path';
  }

  // Common Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static const Duration apiTimeout = Duration(seconds: 30);
}