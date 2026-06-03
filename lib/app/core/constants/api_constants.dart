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
  static const String me = '/api/v1/users/me';

  // Profile Endpoints
  static const String profiles = '/api/v1/profiles';
  static const String myProfile = '/api/v1/profiles/me'; // + /{role}

  // Driver Bookings
  static const String driverBookings = '/api/v1/driver-bookings';
  static const String DRIVER_BOOKINGS = driverBookings;

  // Reservations
  static const String reservations = '/api/v1/reservations';
  static const String RESERVATIONS = reservations;

  // Vehicles & Models
  static const String vehicles = '/api/v1/vehicles';
  static const String VEHICLES = vehicles;
  static const String vehicleModels = '/api/v1/vehicle-models';
  static const String VEHICLE_MODELS = vehicleModels;

  // Payments & Rate Plans
  static const String payments = '/api/v1/payments';
  static const String PAYMENTS = payments;
  static const String ratePlans = '/api/v1/rate-plans';

  // Branches
  static const String branches = '/api/v1/branches';
  static const String BRANCHES = branches;

  // Promo Codes
  static const String promoCodes = '/api/v1/promo-codes';
  static const String PROMO_CODES = promoCodes;

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
