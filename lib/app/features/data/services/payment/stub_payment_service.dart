// features/data/services/payment/stub_payment_service.dart
import '../../../../core/utils/app_logger.dart';
import 'payment_models.dart';
import 'payment_service.dart';

/// TEST-MODE payment service. Validates input and simulates success WITHOUT
/// moving any money. Replace with a real gateway implementation before launch
/// (see PaymentService). Every result is flagged `isStub: true` so the UI can
/// show a clear "test mode" notice.
class StubPaymentService extends PaymentService {
  @override
  Future<PaymentResult> savePaymentMethod(PaymentCard card) async {
    if (!card.isValid) {
      return const PaymentResult(
        status: PaymentStatus.failed,
        message: 'Invalid card details',
        isStub: true,
      );
    }
    AppLogger.w('StubPaymentService.savePaymentMethod — TEST MODE, no real tokenization');
    // A real gateway would return a vault token here instead of card data.
    return PaymentResult(
      status: PaymentStatus.success,
      message: 'Card saved (test mode)',
      reference: 'stub_tok_${card.last4}',
      isStub: true,
    );
  }

  @override
  Future<PaymentResult> charge({
    required double amount,
    required String currency,
    PaymentCard? card,
    String? savedReference,
    String? reference,
  }) async {
    AppLogger.w('StubPaymentService.charge — TEST MODE, no real charge of '
        '$currency ${amount.toStringAsFixed(2)}');
    return PaymentResult(
      status: PaymentStatus.success,
      message: 'Payment simulated (test mode)',
      reference: reference ?? 'stub_chg',
      isStub: true,
    );
  }
}
