// lib/app/features/data/models/booking/booking_model.dart

class BookingModel {
  final String id;
  final String driverId;
  final String pickupLocation;
  final String destination;
  final double price;
  final String status;
  final String createdAt;
  final String? paymentMethod;
  final String? driverName;
  final String? carModel;
  final String? driverImage;

  const BookingModel({
    required this.id,
    required this.driverId,
    required this.pickupLocation,
    required this.destination,
    required this.price,
    required this.status,
    required this.createdAt,
    this.paymentMethod,
    this.driverName,
    this.carModel,
    this.driverImage,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Support both nested driver object and flat driver_id field
    String driverName = '';
    String carModel = '';
    String? driverImage;

    final driverField = json['driver_id'];
    if (driverField is Map<String, dynamic>) {
      driverName = driverField['display_name'] ?? driverField['full_name'] ?? '';
      carModel = driverField['car_model'] ?? '';
      driverImage = driverField['profile_image'];
    }

    return BookingModel(
      id: json['_id'] ?? json['id'] ?? '',
      driverId: driverField is Map ? (driverField['_id'] ?? '') : (json['driver_id']?.toString() ?? ''),
      pickupLocation: json['pickup_location'] ?? '',
      destination: json['destination'] ?? '',
      price: (json['price'] ?? json['total_price'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
      paymentMethod: json['payment_method'],
      driverName: driverName,
      carModel: carModel,
      driverImage: driverImage,
    );
  }

  Map<String, dynamic> toJson() => {
        'driver_id': driverId,
        'pickup_location': pickupLocation,
        'destination': destination,
        'payment_method': paymentMethod ?? 'card',
      };

  /// Human-readable status label
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'active':
      case 'confirmed':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  /// Status colour for UI chips
  bool get isActive =>
      status.toLowerCase() == 'active' || status.toLowerCase() == 'confirmed';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
}
