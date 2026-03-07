// lib/data/repositories/booking_repository.dart
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingRepository {
  final BookingService _service;

  BookingRepository({required BookingService service}) : _service = service;

  /// Fetches bookings and handles server error messages
  Future<List<BookingModel>> getBookings() async {
    try {
      return await _service.fetchBookings();
    } catch (e) {
      // Log error for debugging (Required fix)
      print('--- REPOSITORY ERROR: $e ---');
      rethrow;
    }
  }

  /// Optional detail retrieval
  Future<BookingModel> getBookingDetails(String id) async {
    return await _service.fetchBookingById(id);
  }
}
