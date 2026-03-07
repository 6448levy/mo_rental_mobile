// lib/app/features/modules/booking/controllers/booking_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/driver/driver_profile_model.dart';
import '../../../data/models/booking/booking_model.dart';
import '../../../data/services/booking_service.dart';
import '../../../../../../app/routes/app_routes.dart';

class BookingController extends GetxController {
  final BookingService _bookingService;
  BookingController({required BookingService bookingService})
      : _bookingService = bookingService;

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
  void saveCard() {
    final name = cardNameController.text.trim();
    final number = cardNumberController.text.trim();
    final expiry = cardExpiryController.text.trim();
    final cvv = cardCvvController.text.trim();

    if (name.isEmpty || number.isEmpty || expiry.isEmpty || cvv.isEmpty) {
      Get.snackbar(
        'Incomplete',
        'Please fill all card details',
        backgroundColor: Colors.orange.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    // Show last 4 digits
    final lastFour = number.length >= 4 ? number.substring(number.length - 4) : number;
    selectedPaymentMethod.value = 'Mastercard ****$lastFour';
    cardSaved.value = true;

    Get.back(); // Return to booking overview
    Get.snackbar(
      '✅ Card Saved',
      'Payment method updated successfully',
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
