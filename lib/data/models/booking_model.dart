// lib/data/models/booking_model.dart

class BookingModel {
  final String id;
  final String driverName;
  final String carModel;
  final String pickupLocation;
  final String destination;
  final double price;
  final String status;
  final String createdAt;

  BookingModel({
    required this.id,
    required this.driverName,
    required this.carModel,
    required this.pickupLocation,
    required this.destination,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString() ?? '',
      driverName: json['driver_name'] ?? 'Unknown Driver',
      carModel: json['car_model'] ?? 'Standard Car',
      pickupLocation: json['pickup_location'] ?? '',
      destination: json['destination'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'driver_name': driverName,
    'car_model': carModel,
    'pickup_location': pickupLocation,
    'destination': destination,
    'price': price,
    'status': status,
    'created_at': createdAt,
  };

  /// Helper for UI styling
  bool get isActive => status.toLowerCase() == 'active';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  
  String get statusDisplay => status[0].toUpperCase() + status.substring(1);
}
