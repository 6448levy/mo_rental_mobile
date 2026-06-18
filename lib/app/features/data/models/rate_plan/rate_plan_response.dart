class RatePlanResponse {
  final List<RatePlan> plans;
  final PaginationInfo pagination;

  RatePlanResponse({
    required this.plans,
    required this.pagination,
  });

  /// The backend returns the rate-plan `data` as a bare JSON array. Older/paged
  /// shapes wrapped it in `{plans, pagination}` — accept both.
  factory RatePlanResponse.fromJson(dynamic json) {
    final List rawList = json is List
        ? json
        : (json is Map ? (json['plans'] ?? json['data'] ?? []) : []);
    final plans = rawList
        .whereType<Map>()
        .map((x) => RatePlan.fromJson(Map<String, dynamic>.from(x)))
        .toList();
    final pagination = (json is Map && json['pagination'] is Map)
        ? PaginationInfo.fromJson(Map<String, dynamic>.from(json['pagination']))
        : PaginationInfo(page: 1, limit: plans.length, total: plans.length, totalPages: 1);
    return RatePlanResponse(plans: plans, pagination: pagination);
  }
}

// ── Parsing helpers for the backend's Mongo-shaped payload ────────────────────

/// Parses numbers that may arrive as `{"$numberDecimal":"90.00"}`, a num, or a
/// numeric string.
double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  if (v is Map && v[r'$numberDecimal'] != null) {
    return double.tryParse(v[r'$numberDecimal'].toString()) ?? 0.0;
  }
  return 0.0;
}

/// A field that may be a plain id string, a populated `{_id, name, ...}` object,
/// or null. Returns the id string.
String _idOf(dynamic v) {
  if (v == null) return '';
  if (v is String) return v;
  if (v is Map) return (v['_id'] ?? '').toString();
  return '';
}

/// A populated reference's display name, when available.
String _nameOf(dynamic v) {
  if (v is Map) return (v['name'] ?? '').toString();
  return '';
}

DateTime _toDate(dynamic v) {
  if (v is String && v.isNotEmpty) {
    return DateTime.tryParse(v) ?? DateTime.now();
  }
  return DateTime.now();
}

class RatePlan {
  final String id;
  final String name;
  final String description;
  final String branchId;
  final String vehicleClass;
  final String? vehicleModelId;
  final String? vehicleId;
  final double dailyRate;
  final double weeklyRate;
  final double monthlyRate;
  final String currency;
  final int minRentalDays;
  final int maxRentalDays;
  final bool isActive;
  final DateTime validFrom;
  final DateTime validTo;
  final DateTime createdAt;
  final DateTime updatedAt;

  RatePlan({
    required this.id,
    required this.name,
    required this.description,
    required this.branchId,
    required this.vehicleClass,
    this.vehicleModelId,
    this.vehicleId,
    required this.dailyRate,
    required this.weeklyRate,
    required this.monthlyRate,
    required this.currency,
    required this.minRentalDays,
    required this.maxRentalDays,
    required this.isActive,
    required this.validFrom,
    required this.validTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RatePlan.fromJson(Map<String, dynamic> json) {
    // branch_id may be a populated object — prefer its name for display.
    final branchName = _nameOf(json['branch_id']);
    return RatePlan(
      id: _idOf(json['_id']).isNotEmpty ? _idOf(json['_id']) : (json['_id'] ?? '').toString(),
      name: json['name'] ?? '',
      description: json['notes'] ?? json['description'] ?? '',
      branchId: branchName.isNotEmpty ? branchName : _idOf(json['branch_id']),
      vehicleClass: json['vehicle_class'] ?? '',
      vehicleModelId: json['vehicle_model_id'] == null ? null : _idOf(json['vehicle_model_id']),
      vehicleId: json['vehicle_id'] == null ? null : _idOf(json['vehicle_id']),
      dailyRate: _toDouble(json['daily_rate']),
      weeklyRate: _toDouble(json['weekly_rate']),
      monthlyRate: _toDouble(json['monthly_rate']),
      currency: json['currency'] ?? 'USD',
      minRentalDays: json['min_rental_days'] ?? 1,
      maxRentalDays: json['max_rental_days'] ?? 30,
      isActive: json['active'] ?? json['is_active'] ?? false,
      validFrom: _toDate(json['valid_from']),
      validTo: _toDate(json['valid_to']),
      createdAt: _toDate(json['createdAt'] ?? json['created_at']),
      updatedAt: _toDate(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'description': description,
    'branch_id': branchId,
    'vehicle_class': vehicleClass,
    'vehicle_model_id': vehicleModelId,
    'vehicle_id': vehicleId,
    'daily_rate': dailyRate,
    'weekly_rate': weeklyRate,
    'monthly_rate': monthlyRate,
    'currency': currency,
    'min_rental_days': minRentalDays,
    'max_rental_days': maxRentalDays,
    'is_active': isActive,
    'valid_from': validFrom.toIso8601String(),
    'valid_to': validTo.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  // Helper methods
  String get formattedDailyRate => '$currency $dailyRate/day';
  String get formattedWeeklyRate => '$currency $weeklyRate/week';
  String get formattedMonthlyRate => '$currency $monthlyRate/month';
  
  String get validityPeriod => 
      '${validFrom.day}/${validFrom.month}/${validFrom.year} - ${validTo.day}/${validTo.month}/${validTo.year}';
}

class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
    );
  }

  bool get hasNextPage => page < totalPages;
  bool get hasPrevPage => page > 1;
}