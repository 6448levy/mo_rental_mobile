// lib/app/features/modules/booking/bindings/booking_binding.dart
import 'package:get/get.dart';
import '../controllers/booking_controller.dart';
import '../../../data/services/booking_service.dart';
import '../../../data/services/api_service.dart';

import '../../../data/services/payment_service.dart';
import '../../../data/services/promo_code_service.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    // ApiService & BookingService are stateless singletons — keep permanent
    if (!Get.isRegistered<ApiService>()) {
      Get.put<ApiService>(ApiService(), permanent: true);
    }
    if (!Get.isRegistered<BookingService>()) {
      Get.put<BookingService>(BookingService(), permanent: true);
    }
    if (!Get.isRegistered<PaymentService>()) {
      Get.put<PaymentService>(PaymentService(), permanent: true);
    }
    if (!Get.isRegistered<PromoCodeService>()) {
      Get.put<PromoCodeService>(PromoCodeService(), permanent: true);
    }

    // BookingController holds per-booking state (selectedDriver, form fields).
    // fenix: true means GetX recreates it automatically after it is disposed,
    // so navigating back and picking a new driver always starts fresh.
    Get.lazyPut<BookingController>(
      () => BookingController(),
      fenix: true,
    );
  }
}

