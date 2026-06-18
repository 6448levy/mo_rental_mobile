// lib/app/features/modules/booking/controllers/booking_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/driver/driver_profile_model.dart';
import '../../../data/models/booking/booking_model.dart';
import '../../../data/services/booking_service.dart';
import '../../../data/services/payment/payment_models.dart';
import '../../../data/services/payment/payment_service.dart';
import '../../../../../../app/routes/app_routes.dart';

class BookingController extends GetxController {
  final BookingService _bookingService;
  final PaymentService _paymentService = Get.find<PaymentService>();
  BookingController({required BookingService bookingService})
      : _bookingService = bookingService;

  // Gateway token for the saved card (from PaymentService). Never the raw PAN.
  String? _savedPaymentReference;

  // ─── State ───────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool isCreatingBooking = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  // ─── Selected driver for current booking flow ─────────────────────────────
  final Rx<DriverProfileModel?> selectedDriver = Rx<DriverProfileModel?>(null);

  // ─── Booking form fields ──────────────────────────────────────────────────
  final pickupController = TextEditingController(text: 'Harare CBD');
  final destinationController = TextEditingController(text: 'Borrowdale');
  final RxString selectedPaymentMethod = 'Mastercard ****1234'.obs;

  // ─── Payment card fields ──────────────────────────────────────────────────
  final cardNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cardExpiryController = TextEditingController();
  final cardCvvController = TextEditingController();
  final RxBool cardSaved = false.obs;

  // ─── Latest booking result ────────────────────────────────────────────────
  final Rx<BookingModel?> latestBooking = Rx<BookingModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  @override
  void onClose() {
    pickupController.dispose();
    destinationController.dispose();
    cardNameController.dispose();
    cardNumberController.dispose();
    cardExpiryController.dispose();
    cardCvvController.dispose();
    super.onClose();
  }

  // ─── Navigate to booking overview ────────────────────────────────────────
  void startBookingFlow(DriverProfileModel driver) {
    selectedDriver.value = driver;
    Get.toNamed(AppRoutes.bookingOverview);
  }

  // ─── Fetch my bookings ────────────────────────────────────────────────────
  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _bookingService.getBookings();
      if (response.success && response.data != null) {
        bookings.assignAll(response.data!);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Error loading bookings: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Confirm booking / POST /bookings ─────────────────────────────────────
  Future<void> confirmBooking() async {
    final driver = selectedDriver.value;
    if (driver == null) return;

    try {
      isCreatingBooking.value = true;
      errorMessage.value = '';

      // Take payment through the provider-agnostic seam. With the stub this is
      // test mode (always succeeds, no real charge); a real gateway plugs in
      // here without changing this flow.
      final amount = driver.hourlyRate + 2.0; // matches the cost estimate UI
      final payment = await _paymentService.charge(
        amount: amount,
        currency: 'USD',
        savedReference: _savedPaymentReference,
        reference: 'booking_${driver.id}',
      );
      if (!payment.isSuccess) {
        Get.snackbar(
          'Payment Failed',
          payment.message,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      final response = await _bookingService.createBooking(
        driverId: driver.id,
        pickupLocation: pickupController.text.trim(),
        destination: destinationController.text.trim(),
        paymentMethod: 'card',
      );

      if (response.success) {
        latestBooking.value = response.data;
        // Refresh the bookings list in background
        fetchBookings();
        Get.toNamed(AppRoutes.bookingSuccess);
      } else {
        Get.snackbar(
          'Booking Failed',
          response.message,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCreatingBooking.value = false;
    }
  }

  // ─── Save payment card ────────────────────────────────────────────────────
  Future<void> saveCard() async {
    final card = PaymentCard(
      holderName: cardNameController.text.trim(),
      number: cardNumberController.text.trim(),
      expiry: cardExpiryController.text.trim(),
      cvv: cardCvvController.text.trim(),
    );

    if (!card.isValid) {
      Get.snackbar(
        'Incomplete',
        'Please enter valid card details',
        backgroundColor: Colors.orange.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    // Tokenize through the payment seam (raw card data is never stored).
    final result = await _paymentService.savePaymentMethod(card);
    if (!result.isSuccess) {
      Get.snackbar(
        'Card Error',
        result.message,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    _savedPaymentReference = result.reference;
    selectedPaymentMethod.value = card.maskedLabel;
    cardSaved.value = true;

    Get.back(); // Return to booking overview
    Get.snackbar(
      result.isStub ? '✅ Card Saved · Test Mode' : '✅ Card Saved',
      result.isStub
          ? 'No real charge occurs in test mode'
          : 'Payment method updated successfully',
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
