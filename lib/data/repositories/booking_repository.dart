// lib/data/repositories/booking_repository.dart
import '../models/booking_model.dart';
import '../services/booking_service.dart';
import '../../app/core/utils/logger.dart';

class BookingRepository {
  final BookingService _service;

  BookingRepository({required BookingService service}) : _service = service;

  /// Fetches bookings and handles server error messages
  Future<List<BookingModel>> getBookings() async {
    try {
      return await _service.getBookings();
    } catch (e) {
      // Log error for debugging (Required fix)
      Log.info('--- REPOSITORY ERROR: $e ---');
      rethrow;
    }
  }

  /// Optional detail retrieval
  Future<BookingModel> getBookingDetails(String id) async {
    return await _service.getBookingById(id);
  }
}
