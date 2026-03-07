import 'package:get/get.dart';
import '../features/data/services/api_service.dart';
import '../features/data/services/driver_service.dart';
import '../features/data/services/booking_service.dart';
import '../features/modules/auth/controllers/auth_controller.dart';
import '../features/modules/welcome_screens/onboarding_screens/controllers/onboarding_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Core API service — registered once, available app-wide
    if (!Get.isRegistered<ApiService>()) {
      Get.put<ApiService>(ApiService(), permanent: true);
    }

    // Global services registered at login so they are ready for any feature
    if (!Get.isRegistered<DriverService>()) {
      Get.put<DriverService>(DriverService(), permanent: true);
    }
    if (!Get.isRegistered<BookingService>()) {
      Get.put<BookingService>(BookingService(), permanent: true);
    }

    Get.lazyPut<OnboardingController>(() => OnboardingController());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}