// lib/presentation/providers/booking_provider.dart
import 'package:flutter/material.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository.dart';

enum BookingStatus { initial, loading, loaded, error, empty }

class BookingProvider extends ChangeNotifier {
  final BookingRepository _repository;

  BookingProvider({required BookingRepository repository}) : _repository = repository;

  List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;

  BookingStatus _status = BookingStatus.initial;
  BookingStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Fetch bookings and handle all UI states
  Future<void> loadBookings() async {
    _status = BookingStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final results = await _repository.getBookings();
      _bookings = results;
      
      if (_bookings.isEmpty) {
        _status = BookingStatus.empty;
      } else {
        _status = BookingStatus.loaded;
      }
    } catch (e) {
      _status = BookingStatus.error;
      _errorMessage = e.toString();
      // Even if we fail, we log it clearly
      print('--- PROVIDER ERROR: $e ---');
    }
    
    notifyListeners();
  }

  /// Retry logic for the Error state
  void retry() {
    loadBookings();
  }
}
