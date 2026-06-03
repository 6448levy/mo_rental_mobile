import 'package:get/get.dart';
import '../../../../app/core/utils/logger.dart';
import '../models/auth_models/api_response.dart';
import '../models/payment/payment_model.dart';
import 'api_service.dart';
import '../../../core/constants/api_constants.dart';

class PaymentService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ---------------------------------------------------------------------------
  // INITIALIZE PAYMENT (POST /api/v1/payments)
  // ---------------------------------------------------------------------------

  Future<ApiResponse<PaymentInitiationResponse>> initializePayment({
    String? reservationId,
    String? driverBookingId,
    required double amount,
    String currency = 'USD',
    String? promoCode,
    String? reference,
    String? email,
    String? lineItem,
  }) async {
    Log.info('\n💳 INITIALIZING PAYMENT: Amount $amount $currency');
    
    final payload = {
      if (reservationId != null) 'reservation_id': reservationId,
      if (driverBookingId != null) 'driver_booking_id': driverBookingId,
      'amount': amount,
      'currency': currency,
      if (promoCode != null) 'promo_code': promoCode,
      if (reference != null) 'reference': reference,
      if (email != null) 'email': email,
      if (lineItem != null) 'lineItem': lineItem,
    };

    return await _apiService.post<PaymentInitiationResponse>(
      ApiConstants.PAYMENTS,
      payload,
      fromJson: (json) => PaymentInitiationResponse.fromJson(json),
    );
  }

  // ---------------------------------------------------------------------------
  // POLL PAYMENT STATUS (/api/v1/payments/poll/:id)
  // ---------------------------------------------------------------------------

  /// Poll payment status (POST /api/v1/payments/:id/poll)
  Future<ApiResponse<PaymentModel>> pollPaymentStatus(String paymentId) async {
    Log.info('\n🔄 POLLING PAYMENT STATUS: $paymentId');
    return await _apiService.post<PaymentModel>(
      '${ApiConstants.PAYMENTS}/$paymentId/poll',
      {}, // Empty body for POST polling
      fromJson: (json) => PaymentModel.fromJson(json),
    );
  }

  /// Fetch all payments for the current user
  /// GET /api/v1/payments?mine=true
  Future<ApiResponse<List<PaymentModel>>> getMyPayments({
    String? status,
    bool mine = true,
  }) async {
    Log.info('\n📋 FETCHING MY PAYMENTS');
    final queryParams = {
      'mine': mine.toString(),
      if (status != null) 'status': status,
    };

    return await _apiService.get<List<PaymentModel>>(
      ApiConstants.PAYMENTS,
      queryParams: queryParams,
      fromJson: (json) {
        final List<dynamic> data = json is List ? json : (json['data'] ?? []);
        return data.map((e) => PaymentModel.fromJson(e)).toList();
      },
    );
  }
}
