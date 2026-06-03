import 'package:get/get.dart';
import '../../../data/models/booking/reservation_model.dart';
import '../../../data/services/booking_service.dart';
import '../../../../core/utils/logger.dart';

class RentalHistoryController extends GetxController {
  final BookingService _bookingService = Get.find<BookingService>();

  // --- Observable Lists ---
  final RxList<ReservationModel> activeReservations = <ReservationModel>[].obs;
  final RxList<ReservationModel> pastReservations = <ReservationModel>[].obs;

  // --- State ---
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllHistory();
  }

  Future<void> fetchAllHistory() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Parallel fetch for better performance
      final results = await Future.wait([
        _bookingService.getMyReservations(), // Fetch all to filter locally or make specific calls
      ]);

      final response = results[0];

      if (response.success && response.data != null) {
        final all = response.data!;
        
        // Filter into Active vs Past
        activeReservations.value = all.where((r) => 
          r.status.toLowerCase() == 'pending' || 
          r.status.toLowerCase() == 'confirmed' || 
          r.status.toLowerCase() == 'checked_out'
        ).toList();

        pastReservations.value = all.where((r) => 
          r.status.toLowerCase() == 'returned' || 
          r.status.toLowerCase() == 'cancelled' || 
          r.status.toLowerCase() == 'no_show'
        ).toList();

        Log.info('History Loaded: ${activeReservations.length} Active, ${pastReservations.length} Past');
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load history: $e';
      Log.error('History Fetch Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper to refresh data
  Future<void> refreshHistory() async => await fetchAllHistory();
}
