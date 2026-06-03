import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/utils/logger.dart';
import '../../../data/models/driver/driver_profile_model.dart';
import '../../../data/services/driver_service.dart';
import '../../../data/services/socket_service.dart';

class DriverController extends GetxController {
  final DriverService _driverService = Get.find<DriverService>();
  final SocketService _socketService = Get.find<SocketService>();
  final GetStorage _storage = GetStorage();

  // ─── UI Mode ────────────────────────────────────────────────────────────────
  var isRideHailingMode = true.obs; // true = Ride Hailing, false = Car Rental
  var isOnline = false.obs;

  // ─── Loading / Error ────────────────────────────────────────────────────────
  var isLoadingProfile = false.obs;
  var profileError = ''.obs;

  // ─── Driver Profile (from API) ───────────────────────────────────────────
  var driverProfile = Rxn<DriverProfileModel>();
  var publicProfiles = <DriverProfileModel>[].obs;

  // ─── Ride Hailing State ──────────────────────────────────────────────────
  var incomingRequest = Rxn<Map<String, dynamic>>();
  var activeTrip = Rxn<Map<String, dynamic>>();

  // ─── Car Rental State ────────────────────────────────────────────────────
  var activeRental = Rxn<Map<String, dynamic>>();
  var upcomingRentals = <Map<String, dynamic>>[].obs;

  // ─── Earnings ────────────────────────────────────────────────────────────
  var dailyEarnings = 0.0.obs;
  var weeklyEarnings = 0.0.obs;

  // ─── Documents (mapped from driver profile license + identity doc) ────────
  var documents = <Map<String, dynamic>>[].obs;

  // ─── Convenience Getters ─────────────────────────────────────────────────
  String get driverName => driverProfile.value?.displayName ?? 'Driver';
  double get driverRating => driverProfile.value?.ratingAverage ?? 0.0;
  bool get isVerified => driverProfile.value?.isApproved ?? false;
  String? get profileImageUrl => driverProfile.value?.profileImage;
  String get baseCity => driverProfile.value?.baseCity ?? '';
  String get bio => driverProfile.value?.bio ?? '';
  double get hourlyRate => driverProfile.value?.hourlyRate ?? 0.0;
  int get yearsExperience => driverProfile.value?.yearsExperience ?? 0;
  List<String> get languages => driverProfile.value?.languages ?? [];

  @override
  void onInit() {
    super.onInit();
    fetchPublicDriverProfiles();
    _tryLoadMyProfile();
    _loadMockEarningsData();
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _socketService.on('new_booking', (data) {
      Log.info('🔔 NEW BOOKING RECEIVED VIA SOCKET: $data');
      incomingRequest.value = Map<String, dynamic>.from(data);
      Get.snackbar(
        "New Ride Request", 
        "A customer is requesting a ride near you!",
        duration: const Duration(seconds: 10),
        mainButton: TextButton(
          onPressed: () => Get.toNamed('/driver-dashboard'), // Navigate to accept screen
          child: const Text("VIEW", style: TextStyle(color: Colors.white)),
        ),
      );
    });
  }

  // ─── API Calls ──────────────────────────────────────────────────────────

  /// Fetches all approved public driver profiles (no auth needed)
  Future<void> fetchPublicDriverProfiles() async {
    isLoadingProfile.value = true;
    profileError.value = '';

    final response = await _driverService.getPublicDriverProfiles();

    if (response.success && response.data != null) {
      publicProfiles.assignAll(response.data!);
      // If we don't have an authenticated profile yet, show the first one as preview
      if (driverProfile.value == null && response.data!.isNotEmpty) {
        _setProfileFromModel(response.data!.first);
      }
    } else {
      profileError.value = response.message;
      Log.info('❌ Failed to load driver profiles: ${response.message}');
    }

    isLoadingProfile.value = false;
  }

  /// Tries to load the logged-in driver's own profile using auth token
  Future<void> _tryLoadMyProfile() async {
    final token = _storage.read<String>('auth_token');
    if (token == null || token.isEmpty) {
      Log.info('⚠️ No auth token – skipping my profile fetch');
      return;
    }

    final response = await _driverService.getMyDriverProfile();
    if (response.success && response.data != null) {
      driverProfile.value = response.data;
      _setProfileFromModel(response.data!);
      Log.info('✅ My driver profile loaded: ${response.data!.displayName}');
    } else {
      Log.info(
          '⚠️ My profile not found (${response.message}) – using public list');
    }
  }

  void _setProfileFromModel(DriverProfileModel profile) {
    driverProfile.value = profile;

    // Sync online status
    isOnline.value = profile.isAvailable;

    // Build documents list from license + identity doc
    final docs = <Map<String, dynamic>>[];

    if (profile.driverLicense != null) {
      final license = profile.driverLicense!;
      final isExpired = _isExpired(license.expiresAt);
      docs.add({
        'name': 'Driver License (${license.licenseClass})',
        'status': license.verified
            ? 'Verified'
            : isExpired
                ? 'Expired'
                : 'Pending',
        'expiry': profile.licenseExpiryFormatted,
        'number': license.number,
      });
    }

    if (profile.identityDocument != null) {
      docs.add({
        'name':
            'Identity Document (${profile.identityDocument!.type.replaceAll('_', ' ').toUpperCase()})',
        'status': profile.isApproved ? 'Verified' : 'Pending',
        'expiry': null,
      });
    }

    documents.assignAll(docs);
  }

  bool _isExpired(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return date.isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  // ─── Mock Earnings ──────────────────────────────────────────────────────
  void _loadMockEarningsData() {
    dailyEarnings.value = 124.50;
    weeklyEarnings.value = 850.00;
    activeRental.value = {
      'carModel': 'Toyota Camry 2024',
      'plateNumber': 'ABC-1234',
      'startDate': '2024-03-10',
      'endDate': '2024-03-15',
      'status': 'Active',
    };
  }

  // ─── Trip Actions ───────────────────────────────────────────────────────
  Future<void> acceptRequest() async {
    if (incomingRequest.value == null) return;
    
    final bookingId = incomingRequest.value!['_id'] ?? incomingRequest.value!['id'];
    if (bookingId == null) return;

    final response = await _driverService.updateBookingStatus(
      bookingId: bookingId,
      status: 'accepted',
    );

    if (response.success) {
      activeTrip.value = incomingRequest.value;
      activeTrip.value!['status'] = 'Picking Up';
      incomingRequest.value = null;
      Get.snackbar("Trip Accepted", "Navigate to the pickup location.");
    } else {
      Get.snackbar("Error", response.message);
    }
  }

  Future<void> rejectRequest() async {
    incomingRequest.value = null;
  }

  Future<void> updateStatus(String status) async {
    if (activeTrip.value == null) return;
    
    final bookingId = activeTrip.value!['_id'] ?? activeTrip.value!['id'];
    if (bookingId == null) return;

    final response = await _driverService.updateBookingStatus(
      bookingId: bookingId,
      status: status,
    );

    if (response.success) {
      activeTrip.update((val) {
        val!['status'] = status;
      });
      if (status.toLowerCase() == 'completed') {
        activeTrip.value = null;
        Get.snackbar("Trip Completed", "Well done! Your earnings have been updated.");
      }
    } else {
      Get.snackbar("Error", response.message);
    }
  }

  void startTrip() => updateStatus('started');
  void arriveAtPickup() => updateStatus('arrived');
  void endTrip() => updateStatus('completed');

  // ─── Mode ───────────────────────────────────────────────────────────────
  void toggleMode() {
    isRideHailingMode.toggle();
  }

  // ─── Online Toggle ──────────────────────────────────────────────────────
  Future<void> toggleOnlineStatus(bool value) async {
    isOnline.value = value;

    // Push to API if we have a profile & token
    final token = _storage.read<String>('auth_token');
    final profileId = driverProfile.value?.id;

    if (token != null && profileId != null) {
      final response = await _driverService.toggleAvailability(
        profileId: profileId,
        isAvailable: value,
      );
      if (!response.success) {
        Log.info('⚠️ Failed to sync online status: ${response.message}');
        // Revert on failure
        isOnline.value = !value;
      }
    }
  }

  /// Call this to reload profile data (e.g. pull-to-refresh)
  Future<void> refreshProfile() async {
    await fetchPublicDriverProfiles();
    await _tryLoadMyProfile();
  }
}
