// lib/app/features/modules/drivers/controllers/drivers_controller.dart
import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/driver/driver_profile_model.dart';
import '../../../data/services/driver_service.dart';
import '../../booking/controllers/booking_controller.dart';

class DriversController extends GetxController {
  final DriverService driverService;
  DriversController({required this.driverService});

  // ─── Observable state ─────────────────────────────────────────────────────
  final RxList<DriverProfileModel> drivers = <DriverProfileModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString filterStatus = 'all'.obs; // 'all' | 'online' | 'offline'

  // ─── Real-time polling ────────────────────────────────────────────────────
  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    fetchDrivers();
    _startPolling();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      refreshDrivers(); // silent background refresh
    });
  }

  // ─── Filtered list based on filter chip selection ─────────────────────────
  List<DriverProfileModel> get filteredDrivers {
    if (filterStatus.value == 'online') {
      return drivers.where((d) => d.isAvailable).toList();
    } else if (filterStatus.value == 'offline') {
      return drivers.where((d) => !d.isAvailable).toList();
    }
    return drivers.toList();
  }

  // ─── Fetch (initial / manual refresh) ────────────────────────────────────
  Future<void> fetchDrivers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await driverService.getPublicDriverProfiles();
      if (response.success && response.data != null) {
        drivers.assignAll(response.data!);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Silent background refresh (no loading indicator) ───────────────────
  Future<void> refreshDrivers() async {
    try {
      final response = await driverService.getPublicDriverProfiles();
      if (response.success && response.data != null) {
        drivers.assignAll(response.data!);
      }
    } catch (e) {
      print('Polling error: $e');
    }
  }

  // ─── Navigate to booking overview ─────────────────────────────────────────
  void bookDriver(DriverProfileModel driver) {
    // Ensure BookingController is registered before navigating
    if (!Get.isRegistered<BookingController>()) {
      Get.lazyPut<BookingController>(
        () => BookingController(
          bookingService: Get.find(),
        ),
      );
    }
    Get.find<BookingController>().startBookingFlow(driver);
  }
}
