import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/booking/booking_model.dart';
import '../../../data/models/booking/driver_booking_model.dart';
import '../../../data/models/booking/reservation_model.dart';
import '../../../data/models/driver/driver_profile_model.dart';
import '../../../data/models/payment/payment_model.dart';
import '../../../data/services/booking_service.dart';
import '../../../data/services/payment_service.dart';
import '../../../data/services/promo_code_service.dart';
import '../../../../core/utils/logger.dart';

class BookingController extends GetxController { 
  // FIX: Removed the closing brace that was here, allowing the following 
  // variables and methods to be part of the BookingController class.

  void saveCard() {  
    print("Saving card...");
    // Your logic here
  }

  // --- VARIABLES FOR PAYMENT ---
  var cardName = "".obs;
  var cardNumber = "".obs; 
  var cardExpiry = "".obs;
  var selectedPaymentMethod = PaymentMethod.mobile_wallet.obs;
  
  // Promo Code State
  final promoCodeController = TextEditingController();
  var isApplyingPromo = false.obs;
  var promoMessage = "".obs;
  var promoDiscount = 0.0.obs;
  var finalAmount = 0.0.obs;
  var baseAmount = 150.0.obs; // Default for now

  // Polling State
  Timer? _pollingTimer;
  var isPolling = false.obs;
  var currentPaymentId = "".obs;

  // --- VARIABLES FOR BOOKING ---
  var isCreatingBooking = false.obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var bookings = <BookingModel>[].obs;
  var driverBookings = <DriverBookingModel>[].obs;
  var reservations = <ReservationModel>[].obs;
  
  var latestBooking = Rxn<BookingModel>();
  var latestDriverBooking = Rxn<DriverBookingModel>();
  var latestReservation = Rxn<ReservationModel>();
  
  var selectedDriver = Rxn<DriverProfileModel>(); 

  // --- CONTROLLERS ---
  final cardNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cardExpiryController = TextEditingController();
  final cardCvvController = TextEditingController();
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();

  // --- SERVICES ---
  final BookingService _bookingService = Get.find<BookingService>();
  final PaymentService _paymentService = Get.find<PaymentService>();
  final PromoCodeService _promoCodeService = Get.find<PromoCodeService>();

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";
      
      final legacyRes = await _bookingService.getBookings();
      if (legacyRes.success) {
        bookings.value = legacyRes.data ?? [];
      }

      final driverRes = await _bookingService.getMyDriverBookings();
      if (driverRes.success) {
        driverBookings.value = driverRes.data ?? [];
      }

      final reservationRes = await _bookingService.getMyReservations();
      if (reservationRes.success) {
        reservations.value = reservationRes.data ?? [];
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // FIX: Updated to assign the driver to selectedDriver.value
  void startBookingFlow(DriverProfileModel driver) {
    selectedDriver.value = driver; 
    debugPrint("Starting booking flow for: ${driver.displayName}");
    Get.toNamed('/booking-overview');
  }

  Future<void> applyPromoCode() async {
    final code = promoCodeController.text.trim();
    if (code.isEmpty) return;

    isApplyingPromo.value = true;
    promoMessage.value = "";
    
    try {
      final res = await _promoCodeService.validatePromoCode(
        code: code,
        baseAmount: baseAmount.value,
        // driverProfileId not supported by service
        // Add more constraints if we are in a car rental flow
      );

      if (res.success && res.data != null) {
        if (res.data!.valid) {
          promoDiscount.value = res.data!.discountAmount;
          finalAmount.value = res.data!.finalAmount;
          promoMessage.value = "Promo code applied!";
          Get.snackbar("Success", promoMessage.value, 
            backgroundColor: Colors.green.withValues(alpha: 0.7), 
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
        } else {
          promoDiscount.value = 0.0;
          finalAmount.value = baseAmount.value;
          promoMessage.value = res.data!.message;
          Get.snackbar("Invalid Code", promoMessage.value, 
            backgroundColor: Colors.red.withValues(alpha: 0.7), 
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        promoMessage.value = res.message ?? "Failed to validate promo code.";
        Get.snackbar("Error", promoMessage.value, 
          backgroundColor: Colors.red.withValues(alpha: 0.7), 
          colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isApplyingPromo.value = false;
    }
  }

  Future<void> confirmBooking() async {
    if (selectedDriver.value == null) {
      Get.snackbar("Error", "Please select a driver first.");
      return;
    }

    try {
      isCreatingBooking.value = true;
      errorMessage.value = "";

      // 1. Create the Driver Booking first to get a real ID
      final bookingData = {
        'driver_profile_id': selectedDriver.value!.id,
        'pickup_location': pickupController.text.isEmpty ? 'Current Location' : pickupController.text,
        'destination': destinationController.text.isEmpty ? 'Standard Route' : destinationController.text,
        'amount': finalAmount.value > 0 ? finalAmount.value : baseAmount.value,
      };

      Log.info('Step 1: Creating Backend Booking...');
      final bookingRes = await _bookingService.createDriverBooking(bookingData: bookingData);

      if (!bookingRes.success || bookingRes.data == null) {
        throw Exception(bookingRes.message ?? "Failed to create booking on server.");
      }

      final realBookingId = bookingRes.data!.id;
      Log.info('Step 2: Initializing Payment for Booking ID: $realBookingId');

      // 2. Initialize Payment with the real ID
      final paymentRes = await _paymentService.initializePayment(
        driverBookingId: realBookingId,
        amount: finalAmount.value > 0 ? finalAmount.value : baseAmount.value,
        promoCode: promoDiscount.value > 0 ? promoCodeController.text : null,
        reference: 'RIDE-$realBookingId',
        // In a real app, we would get email from auth state
        email: 'user@example.com', 
      );

      if (paymentRes.success && paymentRes.data != null) {
        final initData = paymentRes.data!;
        
        if (initData.payment != null) {
          currentPaymentId.value = initData.payment!.id;
        }

        // 3. Handle Paynow Redirect or Mobile Wallet Push
        if (initData.redirectUrl != null && initData.redirectUrl!.isNotEmpty) {
          final uri = Uri.parse(initData.redirectUrl!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        } else if (selectedPaymentMethod.value == PaymentMethod.mobile_wallet) {
          Get.snackbar(
            "Check your phone", 
            "Please enter your PIN to confirm the EcoCash/OneMoney payment.",
            backgroundColor: Colors.blue.withValues(alpha: 0.7),
            colorText: Colors.white,
            duration: const Duration(seconds: 8),
          );
        }

        // 4. Start polling for success
        _startPaymentPolling(currentPaymentId.value);
        
      } else {
        errorMessage.value = paymentRes.message ?? "Payment initiation failed.";
        Get.snackbar("Payment Error", errorMessage.value, 
          backgroundColor: Colors.red.withValues(alpha: 0.7), 
          colorText: Colors.white);
      }
      
    } catch (e) {
      errorMessage.value = "Failed to process: $e";
      Get.snackbar("Error", errorMessage.value,
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white);
      Log.error('Checkout Error: $e');
    } finally {
      isCreatingBooking.value = false;
    }
  }

  void _startPaymentPolling(String paymentId) {
    if (isPolling.value || paymentId.isEmpty) return;
    isPolling.value = true;
    int attempts = 0;
    const maxAttempts = 40; // ~3.5 minutes total

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      attempts++;
      
      try {
        final res = await _paymentService.pollPaymentStatus(paymentId);
        if (res.success && res.data != null) {
          final payment = res.data!;
          
          if (payment.isCompleted) {
            _pollingTimer?.cancel();
            isPolling.value = false;
            
            Get.offNamed('/booking-success');
            Get.snackbar("Success", "Payment confirmed! Your ride is on the way.", 
              backgroundColor: Colors.green.withValues(alpha: 0.8), 
              colorText: Colors.white);
          } else if (payment.isFailed) {
            _pollingTimer?.cancel();
            isPolling.value = false;
            Get.snackbar("Payment Failed", "The transaction was unsuccessful. Please try again.", 
              backgroundColor: Colors.red.withValues(alpha: 0.8), 
              colorText: Colors.white);
          }
        }
      } catch (e) {
        debugPrint("Polling error: $e");
      }

      if (attempts >= maxAttempts) {
        _pollingTimer?.cancel();
        isPolling.value = false;
        Get.snackbar("Still Pending", "We haven't received confirmation yet. Don't worry, we'll update you via notification.", 
          backgroundColor: Colors.orange.withValues(alpha: 0.8), 
          colorText: Colors.white);
      }
    });
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    cardNameController.dispose();
    cardNumberController.dispose();
    cardExpiryController.dispose();
    cardCvvController.dispose();
    pickupController.dispose();
    destinationController.dispose();
    promoCodeController.dispose();
    super.onClose();
  }
} // FIX: This is now the only closing brace for the class.