import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/fleet/vehicle_model.dart';
import '../../../data/models/rate_plan/rate_plan_request.dart';
import '../../../data/models/rate_plan/rate_plan_response.dart';
import '../../../data/services/rate_plan_service.dart';
import '../../../data/services/booking_service.dart';
import '../../../data/services/payment_service.dart';
import '../../../../core/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class RentalBookingController extends GetxController {
  final RatePlanService _ratePlanService = Get.find<RatePlanService>();
  final BookingService _bookingService = Get.find<BookingService>();
  final PaymentService _paymentService = Get.find<PaymentService>();
  final GetStorage _storage = GetStorage();

  // --- Input State ---
  final Rxn<DateTimeRange> selectedDates = Rxn<DateTimeRange>();
  final Rxn<RatePlan> activeRatePlan = Rxn<RatePlan>();
  final Rxn<VehicleModel> selectedVehicleModel = Rxn<VehicleModel>();
  final RxString selectedBranchId = ''.obs;

  // --- Calculation State ---
  final RxDouble basePrice = 0.0.obs;
  final RxDouble taxTotal = 0.0.obs;
  final RxDouble feeTotal = 0.0.obs;
  final RxDouble finalTotal = 0.0.obs;
  final RxInt rentalDays = 0.obs;

  // --- Loading State ---
  final RxBool isLoading = false.obs;

  void setupRental(VehicleModel model, String branchId) {
    selectedVehicleModel.value = model;
    selectedBranchId.value = branchId;
    _fetchBestRatePlan();
  }

  Future<void> _fetchBestRatePlan() async {
    if (selectedVehicleModel.value == null || selectedBranchId.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await _ratePlanService.getRatePlans(
        token: _storage.read('auth_token') ?? '',
        request: RatePlanRequest(
          branchId: selectedBranchId.value,
          vehicleClass: selectedVehicleModel.value!.category.toLowerCase(),
        ),
      );

      if (response.success && response.data != null && response.data!.plans.isNotEmpty) {
        // Pick the most specific plan (or first active one)
        activeRatePlan.value = response.data!.plans.firstWhere((p) => p.active, orElse: () => response.data!.plans.first);
        calculatePrice();
      }
    } catch (e) {
      Log.error('Error fetching rate plan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onDatesSelected(DateTimeRange range) {
    selectedDates.value = range;
    rentalDays.value = range.duration.inDays == 0 ? 1 : range.duration.inDays;
    calculatePrice();
  }

  void calculatePrice() {
    final plan = activeRatePlan.value;
    final days = rentalDays.value;

    if (plan == null || days == 0) return;

    // 1. Base Price
    double base = plan.dailyRate * days;
    
    // 2. Check for weekly/monthly rates if applicable
    if (days >= 30 && plan.monthlyRate != null) {
      base = plan.monthlyRate!;
    } else if (days >= 7 && plan.weeklyRate != null) {
      base = plan.weeklyRate! * (days / 7);
    }

    // 3. Taxes
    double taxes = 0;
    for (var tax in plan.taxes) {
      taxes += base * tax.rate;
    }

    // 4. Fees
    double fees = 0;
    for (var fee in plan.fees) {
      fees += fee.amount;
    }

    basePrice.value = base;
    taxTotal.value = taxes;
    feeTotal.value = fees;
    finalTotal.value = base + taxes + fees;

    Log.info('Price Calculated: Base=$base, Taxes=$taxes, Fees=$fees, Total=${finalTotal.value}');
  }

  Future<void> confirmBooking() async {
    if (selectedDates.value == null || selectedVehicleModel.value == null) return;

    isLoading.value = true;
    try {
      // 1. Create Reservation
      final reservationData = {
        'vehicle_model_id': selectedVehicleModel.value!.id,
        'pickup': {
          'at': selectedDates.value!.start.toIso8601String(),
          'branch_id': selectedBranchId.value,
        },
        'dropoff': {
          'at': selectedDates.value!.end.toIso8601String(),
          'branch_id': selectedBranchId.value,
        },
      };

      final resResponse = await _bookingService.createReservation(reservationData: reservationData);

      if (resResponse.success && resResponse.data != null) {
        final reservationId = resResponse.data!.id;
        
        // 2. Initialize Payment
        final payResponse = await _paymentService.initializePayment(
          reservationId: reservationId,
          amount: finalTotal.value,
          email: 'user@example.com', // Replace with Auth state later
        );

        if (payResponse.success && payResponse.data != null) {
          final redirectUrl = payResponse.data!.redirectUrl;
          if (redirectUrl != null && redirectUrl.isNotEmpty) {
            final uri = Uri.parse(redirectUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              // 3. Start Polling for Success
              if (payResponse.data!.payment != null) {
                _startPaymentPolling(payResponse.data!.payment!.id);
              }
            }
          }
        } else {
          Get.snackbar('Payment Error', payResponse.message);
        }
      } else {
        Get.snackbar('Booking Error', resResponse.message);
      }
    } catch (e) {
      Log.error('Checkout failed: $e');
      Get.snackbar('Error', 'An unexpected error occurred during checkout.');
    } finally {
      isLoading.value = false;
    }
  }

  // Polling State
  Timer? _pollingTimer;
  final RxBool isPolling = false.obs;

  void _startPaymentPolling(String paymentId) {
    if (isPolling.value || paymentId.isEmpty) return;
    isPolling.value = true;
    int attempts = 0;
    const maxAttempts = 40; // ~3.5 minutes total

    Log.info('🚀 Starting payment polling for $paymentId...');

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      attempts++;
      
      try {
        final res = await _paymentService.pollPaymentStatus(paymentId);
        if (res.success && res.data != null) {
          final payment = res.data!;
          
          if (payment.isCompleted) {
            _pollingTimer?.cancel();
            isPolling.value = false;
            
            // Navigate to success with arguments
            Get.offAllNamed(
              '/booking-success', 
              arguments: {
                'type': 'rental',
                'vehicle': selectedVehicleModel.value?.fullName ?? 'Vehicle',
                'days': rentalDays.value,
                'total': finalTotal.value,
              }
            );
            Get.snackbar(
              "Success", 
              "Payment confirmed! Your rental is ready.", 
              backgroundColor: Colors.green.withValues(alpha: 0.8), 
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          } else if (payment.isFailed) {
            _pollingTimer?.cancel();
            isPolling.value = false;
            Get.snackbar(
              "Payment Failed", 
              "The transaction was unsuccessful. Please try again.", 
              backgroundColor: Colors.red.withValues(alpha: 0.8), 
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      } catch (e) {
        Log.error("Polling error: $e");
      }

      if (attempts >= maxAttempts) {
        _pollingTimer?.cancel();
        isPolling.value = false;
        Get.snackbar(
          "Still Pending", 
          "We haven't received confirmation yet. We'll update your booking status shortly.", 
          backgroundColor: Colors.orange.withValues(alpha: 0.8), 
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }
}
