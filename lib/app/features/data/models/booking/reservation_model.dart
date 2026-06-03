class Endpoint {
  final DateTime? at;
  final String branchId;

  Endpoint({
    this.at,
    required this.branchId,
  });

  factory Endpoint.fromJson(Map<String, dynamic> json) {
    return Endpoint(
      at: json['at'] != null ? DateTime.tryParse(json['at']) : null,
      branchId: json['branch_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        if (at != null) 'at': at!.toIso8601String(),
        'branch_id': branchId,
      };
}

class PricingBreakdownItem {
  final String label;
  final int quantity;
  final String unitAmount;
  final String total;

  PricingBreakdownItem({
    required this.label,
    required this.quantity,
    required this.unitAmount,
    required this.total,
  });

  factory PricingBreakdownItem.fromJson(Map<String, dynamic> json) {
    return PricingBreakdownItem(
      label: json['label'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitAmount: json['unit_amount']?.toString() ?? '0.00',
      total: json['total']?.toString() ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'quantity': quantity,
        'unit_amount': unitAmount,
        'total': total,
      };
}

class PricingFeeItem {
  final String code;
  final String amount;

  PricingFeeItem({required this.code, required this.amount});

  factory PricingFeeItem.fromJson(Map<String, dynamic> json) {
    return PricingFeeItem(
      code: json['code'] ?? '',
      amount: json['amount']?.toString() ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'amount': amount,
      };
}

class PricingTaxItem {
  final String code;
  final double rate;
  final String amount;

  PricingTaxItem({required this.code, required this.rate, required this.amount});

  factory PricingTaxItem.fromJson(Map<String, dynamic> json) {
    return PricingTaxItem(
      code: json['code'] ?? '',
      rate: (json['rate'] ?? 0.0).toDouble(),
      amount: json['amount']?.toString() ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'rate': rate,
        'amount': amount,
      };
}

class PricingDiscountItem {
  final String promoCodeId;
  final String amount;

  PricingDiscountItem({required this.promoCodeId, required this.amount});

  factory PricingDiscountItem.fromJson(Map<String, dynamic> json) {
    return PricingDiscountItem(
      promoCodeId: json['promo_code_id'] ?? '',
      amount: json['amount']?.toString() ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() => {
        'promo_code_id': promoCodeId,
        'amount': amount,
      };
}

class Pricing {
  final String currency;
  final List<PricingBreakdownItem> breakdown;
  final List<PricingFeeItem> fees;
  final List<PricingTaxItem> taxes;
  final List<PricingDiscountItem> discounts;
  final String grandTotal;
  final DateTime? computedAt;

  Pricing({
    required this.currency,
    required this.breakdown,
    required this.fees,
    required this.taxes,
    required this.discounts,
    required this.grandTotal,
    this.computedAt,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      currency: json['currency'] ?? 'USD',
      breakdown: (json['breakdown'] as List<dynamic>?)
              ?.map((e) => PricingBreakdownItem.fromJson(e))
              .toList() ??
          [],
      fees: (json['fees'] as List<dynamic>?)
              ?.map((e) => PricingFeeItem.fromJson(e))
              .toList() ??
          [],
      taxes: (json['taxes'] as List<dynamic>?)
              ?.map((e) => PricingTaxItem.fromJson(e))
              .toList() ??
          [],
      discounts: (json['discounts'] as List<dynamic>?)
              ?.map((e) => PricingDiscountItem.fromJson(e))
              .toList() ??
          [],
      grandTotal: json['grand_total']?.toString() ?? '0.00',
      computedAt: json['computed_at'] != null ? DateTime.tryParse(json['computed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'currency': currency,
        'breakdown': breakdown.map((e) => e.toJson()).toList(),
        'fees': fees.map((e) => e.toJson()).toList(),
        'taxes': taxes.map((e) => e.toJson()).toList(),
        'discounts': discounts.map((e) => e.toJson()).toList(),
        'grand_total': grandTotal,
        if (computedAt != null) 'computed_at': computedAt!.toIso8601String(),
      };
}

class PaymentSummary {
  final String status;
  final String paidTotal;
  final String outstanding;
  final DateTime? lastPaymentAt;

  PaymentSummary({
    required this.status,
    required this.paidTotal,
    required this.outstanding,
    this.lastPaymentAt,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      status: json['status'] ?? 'unpaid',
      paidTotal: json['paid_total']?.toString() ?? '0.00',
      outstanding: json['outstanding']?.toString() ?? '0.00',
      lastPaymentAt: json['last_payment_at'] != null ? DateTime.tryParse(json['last_payment_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'paid_total': paidTotal,
        'outstanding': outstanding,
        if (lastPaymentAt != null) 'last_payment_at': lastPaymentAt!.toIso8601String(),
      };
}

class DriverLicense {
  final String number;
  final String country;
  final String licenseClass;
  final DateTime? expiresAt;
  final bool verified;

  DriverLicense({
    required this.number,
    required this.country,
    required this.licenseClass,
    this.expiresAt,
    required this.verified,
  });

  factory DriverLicense.fromJson(Map<String, dynamic> json) {
    return DriverLicense(
      number: json['number'] ?? '',
      country: json['country'] ?? '',
      licenseClass: json['class'] ?? '',
      expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at']) : null,
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'country': country,
        'class': licenseClass,
        if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
        'verified': verified,
      };
}

class DriverSnapshot {
  final String fullName;
  final String phone;
  final String email;
  final DriverLicense? driverLicense;

  DriverSnapshot({
    required this.fullName,
    required this.phone,
    required this.email,
    this.driverLicense,
  });

  factory DriverSnapshot.fromJson(Map<String, dynamic> json) {
    return DriverSnapshot(
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      driverLicense: json['driver_license'] != null ? DriverLicense.fromJson(json['driver_license']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'phone': phone,
        'email': email,
        if (driverLicense != null) 'driver_license': driverLicense!.toJson(),
      };
}

class ReservationModel {
  final String id;
  final String code;
  final String userId;
  final String createdChannel;
  final String? vehicleId;
  final String vehicleModelId;
  final Endpoint pickup;
  final Endpoint dropoff;
  final String status;
  final Pricing pricing;
  final PaymentSummary paymentSummary;
  final DriverSnapshot? driverSnapshot;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReservationModel({
    this.id = '',
    this.code = '',
    required this.userId,
    this.createdChannel = 'web',
    this.vehicleId,
    required this.vehicleModelId,
    required this.pickup,
    required this.dropoff,
    this.status = 'pending',
    required this.pricing,
    required this.paymentSummary,
    this.driverSnapshot,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      userId: json['user_id'] ?? '',
      createdChannel: json['created_channel'] ?? 'web',
      vehicleId: json['vehicle_id'],
      vehicleModelId: json['vehicle_model_id'] ?? '',
      pickup: Endpoint.fromJson(json['pickup'] ?? {}),
      dropoff: Endpoint.fromJson(json['dropoff'] ?? {}),
      status: json['status'] ?? 'pending',
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
      paymentSummary: PaymentSummary.fromJson(json['payment_summary'] ?? {}),
      driverSnapshot: json['driver_snapshot'] != null ? DriverSnapshot.fromJson(json['driver_snapshot']) : null,
      notes: json['notes'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id.isNotEmpty) '_id': id,
        'code': code,
        'user_id': userId,
        'created_channel': createdChannel,
        'vehicle_id': vehicleId,
        'vehicle_model_id': vehicleModelId,
        'pickup': pickup.toJson(),
        'dropoff': dropoff.toJson(),
        'status': status,
        'pricing': pricing.toJson(),
        'payment_summary': paymentSummary.toJson(),
        if (driverSnapshot != null) 'driver_snapshot': driverSnapshot!.toJson(),
        if (notes != null) 'notes': notes,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };
}

class Availability {
  final String vehicleId;
  final DateTime start;
  final DateTime end;

  Availability({
    required this.vehicleId,
    required this.start,
    required this.end,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      vehicleId: json['vehicle_id'] ?? '',
      start: DateTime.parse(json['start'] ?? DateTime.now().toIso8601String()),
      end: DateTime.parse(json['end'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicle_id': vehicleId,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
      };
}
