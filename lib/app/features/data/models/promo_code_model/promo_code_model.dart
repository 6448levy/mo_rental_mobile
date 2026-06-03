// lib/app/features/data/models/promo_code_model/promo_code_model.dart

class PromoCodeConstraints {
  final List<String> allowedClasses;
  final int minDays;
  final List<String> branchIds;

  PromoCodeConstraints({
    required this.allowedClasses,
    required this.minDays,
    required this.branchIds,
  });

  factory PromoCodeConstraints.fromJson(Map<String, dynamic> json) {
    return PromoCodeConstraints(
      allowedClasses: List<String>.from(json['allowed_classes'] ?? []),
      minDays: json['min_days'] ?? 0,
      branchIds: List<String>.from(json['branch_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'allowed_classes': allowedClasses,
    'min_days': minDays,
    'branch_ids': branchIds,
  };
}

class PromoCode {
  final String id;
  final String code;
  final String type; // 'percent' or 'fixed'
  final double value;
  final String currency;
  final bool active;
  final DateTime? validFrom;
  final DateTime? validTo;
  final int? usageLimit;
  final PromoCodeConstraints? constraints;
  final String? notes;

  PromoCode({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    required this.currency,
    required this.active,
    this.validFrom,
    this.validTo,
    this.usageLimit,
    this.constraints,
    this.notes,
  });

  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      id: json['_id'] ?? json['id'] ?? '',
      code: json['code'] ?? '',
      type: json['type'] ?? 'percent',
      value: (json['value'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      active: json['active'] ?? false,
      validFrom: json['valid_from'] != null ? DateTime.parse(json['valid_from']) : null,
      validTo: json['valid_to'] != null ? DateTime.parse(json['valid_to']) : null,
      usageLimit: json['usage_limit'],
      constraints: json['constraints'] != null ? PromoCodeConstraints.fromJson(json['constraints']) : null,
      notes: json['notes'],
    );
  }

  bool get isValid {
    final now = DateTime.now();
    final isNotExpired = validTo == null || now.isBefore(validTo!);
    final hasStarted = validFrom == null || now.isAfter(validFrom!);
    return active && isNotExpired && hasStarted;
  }

  DateTime? get validUntil => validTo;

  double calculateDiscount(double originalPrice) {
    if (type == 'percent') {
      return originalPrice * (value / 100);
    } else if (type == 'fixed' || type == 'amount') {
      return value;
    }
    return 0;
  }
}

class PromoCodeValidationResult {
  final bool valid;
  final String message;
  final double discountAmount;
  final double finalAmount;
  final String? code;

  PromoCodeValidationResult({
    required this.valid,
    required this.message,
    required this.discountAmount,
    required this.finalAmount,
    this.code,
  });

  factory PromoCodeValidationResult.fromJson(Map<String, dynamic> json) {
    return PromoCodeValidationResult(
      valid: json['valid'] ?? false,
      message: json['message'] ?? '',
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      finalAmount: (json['final_amount'] ?? 0).toDouble(),
      code: json['code'],
    );
  }
}
