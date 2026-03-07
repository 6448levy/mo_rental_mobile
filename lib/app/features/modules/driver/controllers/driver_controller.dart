import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/driver/driver_profile_model.dart';
import '../../../data/services/driver_service.dart';

class DriverController extends GetxController {
  final DriverService _driverService = Get.find<DriverService>();
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
      print('❌ Failed to load driver profiles: ${response.message}');
    }

    isLoadingProfile.value = false;
  }

  /// Tries to load the logged-in driver's own profile using auth token
  Future<void> _tryLoadMyProfile() async {
    final token = _storage.read<String>('auth_token');
    if (token == null || token.isEmpty) {
      print('⚠️ No auth token – skipping my profile fetch');
      return;
    }

    final response = await _driverService.getMyDriverProfile(token: token);
    if (response.success && response.data != null) {
      driverProfile.value = response.data;
      _setProfileFromModel(response.data!);
      print('✅ My driver profile loaded: ${response.data!.displayName}');
    } else {
      print('⚠️ My profile not found (${response.message}) – using public list');
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
        'name': 'Identity Document (${profile.identityDocument!.type.replaceAll('_', ' ').toUpperCase()})',
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
  void acceptRequest() {
    if (incomingRequest.value != null) {
      activeTrip.value = incomingRequest.value;
      activeTrip.value!['status'] = 'Picking Up';
      incomingRequest.value = null;
    }
  }

  void rejectRequest() {
    incomingRequest.value = null;
  }

  void startTrip() {
    if (activeTrip.value != null) {
      activeTrip.update((val) {
        val!['status'] = 'In Progress';
      });
    }
  }

  void endTrip() {
    activeTrip.value = null;
  }

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
        token: token,
        isAvailable: value,
      );
      if (!response.success) {
        print('⚠️ Failed to sync online status: ${response.message}');
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
