// lib/app/features/data/models/rate_plan/rate_plan_response.dart

class RatePlanResponse {
  final List<RatePlan> plans;
  final PaginationInfo pagination;

  RatePlanResponse({
    required this.plans,
    required this.pagination,
  });

  factory RatePlanResponse.fromJson(dynamic json) {
    if (json is List) {
      return RatePlanResponse(
        plans: json.map((x) => RatePlan.fromJson(x as Map<String, dynamic>)).toList(),
        pagination: PaginationInfo(page: 1, limit: json.length, total: json.length, totalPages: 1),
      );
    }

    final mapJson = json as Map<String, dynamic>;
    return RatePlanResponse(
      plans: List<RatePlan>.from((mapJson['plans'] ?? []).map((x) => RatePlan.fromJson(x))),
      pagination: PaginationInfo.fromJson(mapJson['pagination'] ?? {}),
    );
  }
}

class Tax {
  final String code;
  final double rate;

  Tax({required this.code, required this.rate});

  factory Tax.fromJson(Map<String, dynamic> json) {
    return Tax(
      code: json['code'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }
}

class Fee {
  final String code;
  final double amount;

  Fee({required this.code, required this.amount});

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      code: json['code'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0,
    );
  }
}

class Season {
  final String name;
  final DateTime start;
  final DateTime end;

  Season({required this.name, required this.start, required this.end});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      name: json['name'] ?? '',
      start: DateTime.parse(json['start'] ?? DateTime.now().toIso8601String()),
      end: DateTime.parse(json['end'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class SeasonalOverride {
  final Season season;
  final double? dailyRate;
  final double? weeklyRate;
  final double? monthlyRate;
  final double? weekendRate;

  SeasonalOverride({
    required this.season,
    this.dailyRate,
    this.weeklyRate,
    this.monthlyRate,
    this.weekendRate,
  });

  factory SeasonalOverride.fromJson(Map<String, dynamic> json) {
    return SeasonalOverride(
      season: Season.fromJson(json['season'] ?? {}),
      dailyRate: double.tryParse(json['daily_rate']?.toString() ?? ''),
      weeklyRate: double.tryParse(json['weekly_rate']?.toString() ?? ''),
      monthlyRate: double.tryParse(json['monthly_rate']?.toString() ?? ''),
      weekendRate: double.tryParse(json['weekend_rate']?.toString() ?? ''),
    );
  }
}

class RatePlan {
  final String id;
  final String name;
  final String branchId;
  final String vehicleClass;
  final String? vehicleModelId;
  final String? vehicleId;
  final double dailyRate;
  final double? weeklyRate;
  final double? monthlyRate;
  final double? weekendRate;
  final String currency;
  final List<SeasonalOverride> seasonalOverrides;
  final List<Tax> taxes;
  final List<Fee> fees;
  final bool active;
  final DateTime validFrom;
  final DateTime validTo;
  final String? notes;
  final String description;
  final int minRentalDays;
  final int maxRentalDays;

  RatePlan({
    required this.id,
    required this.name,
    required this.branchId,
    required this.vehicleClass,
    this.vehicleModelId,
    this.vehicleId,
    required this.dailyRate,
    this.weeklyRate,
    this.monthlyRate,
    this.weekendRate,
    required this.currency,
    required this.seasonalOverrides,
    required this.taxes,
    required this.fees,
    required this.active,
    required this.validFrom,
    required this.validTo,
    this.notes,
    this.description = '',
    this.minRentalDays = 1,
    this.maxRentalDays = 30,
  });

  bool get isActive => active;

  String get formattedDailyRate => '${currency} ${dailyRate.toStringAsFixed(2)}';
  String get formattedWeeklyRate => weeklyRate != null ? '${currency} ${weeklyRate!.toStringAsFixed(2)}' : 'N/A';
  String get formattedMonthlyRate => monthlyRate != null ? '${currency} ${monthlyRate!.toStringAsFixed(2)}' : 'N/A';

  String get validityPeriod {
    final from = '${validFrom.day}/${validFrom.month}/${validFrom.year}';
    final to = '${validTo.day}/${validTo.month}/${validTo.year}';
    return '$from - $to';
  }

  factory RatePlan.fromJson(Map<String, dynamic> json) {
    return RatePlan(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      branchId: json['branch_id']?.toString() ?? '',
      vehicleClass: json['vehicle_class'] ?? '',
      vehicleModelId: json['vehicle_model_id']?.toString(),
      vehicleId: json['vehicle_id']?.toString(),
      dailyRate: double.tryParse(json['daily_rate']?.toString() ?? '0') ?? 0,
      weeklyRate: double.tryParse(json['weekly_rate']?.toString() ?? ''),
      monthlyRate: double.tryParse(json['monthly_rate']?.toString() ?? ''),
      weekendRate: double.tryParse(json['weekend_rate']?.toString() ?? ''),
      currency: json['currency'] ?? 'USD',
      seasonalOverrides: (json['seasonal_overrides'] as List?)?.map((e) => SeasonalOverride.fromJson(e)).toList() ?? [],
      taxes: (json['taxes'] as List?)?.map((e) => Tax.fromJson(e)).toList() ?? [],
      fees: (json['fees'] as List?)?.map((e) => Fee.fromJson(e)).toList() ?? [],
      active: json['active'] ?? json['is_active'] ?? false,
      validFrom: DateTime.parse(json['valid_from'] ?? DateTime.now().toIso8601String()),
      validTo: DateTime.parse(json['valid_to'] ?? DateTime.now().toIso8601String()),
      notes: json['notes'],
      description: json['description'] ?? json['notes'] ?? '',
      minRentalDays: json['min_rental_days'] ?? 1,
      maxRentalDays: json['max_rental_days'] ?? 30,
    );
  }

  double calculateTotal(int days) {
    double base = dailyRate * days;
    // Simple logic for now, can be extended for weekly/monthly
    double taxAmount = 0;
    for (var tax in taxes) {
      taxAmount += base * tax.rate;
    }
    double feeAmount = 0;
    for (var fee in fees) {
      feeAmount += fee.amount;
    }
    return base + taxAmount + feeAmount;
  }
}

class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginationInfo({required this.page, required this.limit, required this.total, required this.totalPages});

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}
