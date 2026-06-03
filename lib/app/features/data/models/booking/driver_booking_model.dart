class Location {
  final String label;
  final String address;
  final double lat;
  final double lng;

  Location({
    this.label = '',
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      label: json['label'] ?? '',
      address: json['address'] ?? '',
      lat: (json['lat'] ?? json['latitude'] ?? 0).toDouble(),
      lng: (json['lng'] ?? json['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'address': address,
        'lat': lat,
        'lng': lng,
        'latitude': lat,
        'longitude': lng,
      };
}

class DriverPricingSnapshot {
  final double hourlyRate;
  final double totalHours;
  final double baseAmount;
  final double platformFee;
  final double totalAmount;
  final String currency;

  DriverPricingSnapshot({
    required this.hourlyRate,
    required this.totalHours,
    required this.baseAmount,
    required this.platformFee,
    required this.totalAmount,
    required this.currency,
  });

  factory DriverPricingSnapshot.fromJson(Map<String, dynamic> json) {
    return DriverPricingSnapshot(
      hourlyRate: (json['hourly_rate'] ?? 0).toDouble(),
      totalHours: (json['total_hours'] ?? json['hours_requested'] ?? 0).toDouble(),
      baseAmount: (json['base_amount'] ?? 0).toDouble(),
      platformFee: (json['platform_fee'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() => {
        'hourly_rate': hourlyRate,
        'total_hours': totalHours,
        'hours_requested': totalHours,
        'base_amount': baseAmount,
        'platform_fee': platformFee,
        'total_amount': totalAmount,
        'currency': currency,
      };
}

class DriverBookingModel {
  final String id;
  final String code;
  final String customerId;
  final String driverProfileId;
  final String driverUserId;
  final DateTime startAt;
  final DateTime endAt;
  final Location pickupLocation;
  final Location dropoffLocation;
  final String? notes;
  final DriverPricingSnapshot pricing;
  final String status;
  final DateTime requestedAt;
  final DateTime? driverRespondedAt;
  final DateTime? paidAt;
  final DateTime? completedAt;
  final String? paymentId;
  final String paymentStatusSnapshot;
  final double? customerRatingOfDriver;
  final String? customerReviewText;

  DriverBookingModel({
    required this.id,
    required this.code,
    required this.customerId,
    required this.driverProfileId,
    required this.driverUserId,
    required this.startAt,
    required this.endAt,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.notes,
    required this.pricing,
    required this.status,
    required this.requestedAt,
    this.driverRespondedAt,
    this.paidAt,
    this.completedAt,
    this.paymentId,
    required this.paymentStatusSnapshot,
    this.customerRatingOfDriver,
    this.customerReviewText,
  });

  factory DriverBookingModel.fromJson(Map<String, dynamic> json) {
    return DriverBookingModel(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      customerId: json['customer_id'] ?? '',
      driverProfileId: json['driver_profile_id'] ?? '',
      driverUserId: json['driver_user_id'] ?? '',
      startAt: DateTime.parse(json['start_at']),
      endAt: DateTime.parse(json['end_at']),
      pickupLocation: Location.fromJson(json['pickup_location'] ?? {}),
      dropoffLocation: Location.fromJson(json['dropoff_location'] ?? {}),
      notes: json['notes'],
      pricing: DriverPricingSnapshot.fromJson(json['pricing'] ?? {}),
      status: json['status'] ?? 'requested',
      requestedAt: DateTime.parse(json['requested_at']),
      driverRespondedAt: json['driver_responded_at'] != null ? DateTime.tryParse(json['driver_responded_at']) : null,
      paidAt: json['paid_at'] != null ? DateTime.tryParse(json['paid_at']) : null,
      completedAt: json['completed_at'] != null ? DateTime.tryParse(json['completed_at']) : null,
      paymentId: json['payment_id'],
      paymentStatusSnapshot: json['payment_status_snapshot'] ?? 'unpaid',
      customerRatingOfDriver: (json['customer_rating_of_driver'] as num?)?.toDouble(),
      customerReviewText: json['customer_review_text'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'code': code,
        'customer_id': customerId,
        'driver_profile_id': driverProfileId,
        'driver_user_id': driverUserId,
        'start_at': startAt.toIso8601String(),
        'end_at': endAt.toIso8601String(),
        'pickup_location': pickupLocation.toJson(),
        'dropoff_location': dropoffLocation.toJson(),
        'notes': notes,
        'pricing': pricing.toJson(),
        'status': status,
        'requested_at': requestedAt.toIso8601String(),
        'driver_responded_at': driverRespondedAt?.toIso8601String(),
        'paid_at': paidAt?.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'payment_id': paymentId,
        'payment_status_snapshot': paymentStatusSnapshot,
        'customer_rating_of_driver': customerRatingOfDriver,
        'customer_review_text': customerReviewText,
      };
}
