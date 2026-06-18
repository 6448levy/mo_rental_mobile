// features/data/services/payment/payment_service.dart
import 'package:get/get.dart';
import 'payment_models.dart';

/// Provider-agnostic payment seam.
///
/// Swap [StubPaymentService] for a real implementation (Paystack / Flutterwave /
/// Stripe) without touching the booking flow — only the binding changes.
/// Keys must be injected at build time (--dart-define), never committed.
abstract class PaymentService extends GetxService {
  /// Tokenize/save a card for later use. Real gateways return a token instead of
  /// the raw PAN; we only keep the masked label + reference.
  Future<PaymentResult> savePaymentMethod(PaymentCard card);

  /// Charge an amount. [reference] ties the charge to a booking/order.
  Future<PaymentResult> charge({
    required double amount,
    required String currency,
    PaymentCard? card,
    String? savedReference,
    String? reference,
  });
}
