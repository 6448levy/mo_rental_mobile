// lib/app/features/modules/booking/bindings/booking_binding.dart
import 'package:get/get.dart';
import '../controllers/booking_controller.dart';
import '../../../data/services/booking_service.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/payment/payment_service.dart';
import '../../../data/services/payment/stub_payment_service.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiService is registered
    if (!Get.isRegistered<ApiService>()) {
      Get.put<ApiService>(ApiService(), permanent: true);
    }

    // Payment seam — swap StubPaymentService for a real gateway impl when ready.
    if (!Get.isRegistered<PaymentService>()) {
      Get.put<PaymentService>(StubPaymentService(), permanent: true);
    }

    // Register BookingService globally
    if (!Get.isRegistered<BookingService>()) {
      Get.put<BookingService>(BookingService(), permanent: true);
    }

    // Register BookingController
    if (!Get.isRegistered<BookingController>()) {
      Get.put<BookingController>(
        BookingController(bookingService: Get.find<BookingService>()),
        permanent: true,
      );
    }
  }
}
