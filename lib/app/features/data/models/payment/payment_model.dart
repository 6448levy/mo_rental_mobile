// lib/app/features/data/models/payment/payment_model.dart

enum PaymentStatus {
  pending,
  completed,
  failed,
  cancelled,
  refunded,
  expired,
}

enum PaymentMethod {
  paynow,
  mobile_wallet,
  card,
  cash,
}

class RefundModel {
  final double amount;
  final String providerRef;
  final DateTime at;

  RefundModel({
    required this.amount,
    required this.providerRef,
    required this.at,
  });

  factory RefundModel.fromJson(Map<String, dynamic> json) {
    return RefundModel(
      amount: (json['amount'] ?? 0).toDouble(),
      providerRef: json['provider_ref'] ?? '',
      at: DateTime.parse(json['at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class PaymentInitiationResponse {
  final bool success;
  final String? redirectUrl;
  final String? pollUrl;
  final String? promoWarning;
  final PaymentModel? payment;

  PaymentInitiationResponse({
    required this.success,
    this.redirectUrl,
    this.pollUrl,
    this.promoWarning,
    this.payment,
  });

  factory PaymentInitiationResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInitiationResponse(
      success: json['success'] ?? false,
      redirectUrl: json['redirectUrl'],
      pollUrl: json['pollUrl'],
      promoWarning: json['promo_warning'],
      payment: json['payment'] != null ? PaymentModel.fromJson(json['payment']) : null,
    );
  }
}

class PaymentModel {
  final String id;
  final String? reservationId;
  final String? driverBookingId;
  final String userId;
  final String provider;
  final String method;
  final double amount;
  final String currency;
  final String paymentStatus;
  final String pollUrl;
  final double pricePaid;
  final bool promotionApplied;
  final double promotionDiscount;
  final DateTime? boughtAt;
  final String? providerRef;
  final DateTime? capturedAt;
  final String? paynowInvoiceId;
  final List<RefundModel> refunds;
  final String? promoCodeId;
  final String? promoCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentModel({
    required this.id,
    this.reservationId,
    this.driverBookingId,
    required this.userId,
    required this.provider,
    required this.method,
    required this.amount,
    required this.currency,
    required this.paymentStatus,
    required this.pollUrl,
    required this.pricePaid,
    required this.promotionApplied,
    required this.promotionDiscount,
    this.boughtAt,
    this.providerRef,
    this.capturedAt,
    this.paynowInvoiceId,
    required this.refunds,
    this.promoCodeId,
    this.promoCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'] ?? '',
      reservationId: json['reservation_id'],
      driverBookingId: json['driver_booking_id'],
      userId: json['user_id'] ?? '',
      provider: json['provider'] ?? 'paynow',
      method: json['method'] ?? 'wallet',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      currency: json['currency'] ?? 'USD',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      pollUrl: json['pollUrl'] ?? '',
      pricePaid: (json['pricePaid'] ?? 0).toDouble(),
      promotionApplied: json['promotionApplied'] ?? false,
      promotionDiscount: (json['promotionDiscount'] ?? 0).toDouble(),
      boughtAt: json['boughtAt'] != null ? DateTime.parse(json['boughtAt']) : null,
      providerRef: json['provider_ref'],
      capturedAt: json['captured_at'] != null ? DateTime.parse(json['captured_at']) : null,
      paynowInvoiceId: json['paynow_invoice_id'],
      refunds: (json['refunds'] as List?)?.map((e) => RefundModel.fromJson(e)).toList() ?? [],
      promoCodeId: json['promo_code_id'],
      promoCode: json['promo_code'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  bool get isCompleted => paymentStatus.toLowerCase() == 'completed' || paymentStatus.toLowerCase() == 'paid';
  bool get isPending => paymentStatus.toLowerCase() == 'pending';
  bool get isFailed => ['failed', 'cancelled', 'expired'].contains(paymentStatus.toLowerCase());
}
