// features/data/services/payment/payment_models.dart

/// A payment card captured from the UI. Only the masked tail is ever persisted;
/// full PAN/CVV must never be stored or logged.
class PaymentCard {
  final String holderName;
  final String number; // raw entry; tokenize via the gateway, never store
  final String expiry; // MM/YY
  final String cvv;

  const PaymentCard({
    required this.holderName,
    required this.number,
    required this.expiry,
    required this.cvv,
  });

  String get last4 {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 4 ? digits.substring(digits.length - 4) : digits;
  }

  String get maskedLabel => 'Card ****$last4';

  bool get isValid =>
      holderName.trim().isNotEmpty &&
      number.replaceAll(RegExp(r'\D'), '').length >= 12 &&
      RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry.trim()) &&
      cvv.trim().length >= 3;
}

enum PaymentStatus { success, failed, pending }

/// Result of a payment/tokenization attempt.
class PaymentResult {
  final PaymentStatus status;
  final String message;

  /// Gateway reference / token. For real gateways this is the charge id or the
  /// saved-card token returned in place of the raw card details.
  final String? reference;

  /// True when produced by the stub (no real money moved). Lets the UI surface
  /// a clear "test mode" indicator until a real gateway is wired in.
  final bool isStub;

  const PaymentResult({
    required this.status,
    required this.message,
    this.reference,
    this.isStub = false,
  });

  bool get isSuccess => status == PaymentStatus.success;
}
