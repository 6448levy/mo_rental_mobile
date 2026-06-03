enum VehicleTransmission {
  manual,
  automatic,
}

enum VehicleFuelType {
  petrol,
  diesel,
  electric,
  hybrid,
}

enum VehicleStatus {
  available,
  rented,
  maintenance,
  retired,
}

class VehicleModel {
  final String id;
  final String make;
  final String model;
  final int year;
  final String category; // e.g., SUV, Sedan, Luxury
  final VehicleTransmission transmission;
  final VehicleFuelType fuelType;
  final int seats;
  final int doors;
  final double dailyRate;
  final String currency;
  final String imageUrl;
  final List<String> features;
  final bool isActive;

  VehicleModel({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.category,
    required this.transmission,
    required this.fuelType,
    required this.seats,
    required this.doors,
    required this.dailyRate,
    required this.currency,
    required this.imageUrl,
    required this.features,
    required this.isActive,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 2024,
      category: json['category'] ?? 'Standard',
      transmission: _parseTransmission(json['transmission']?.toString() ?? 'automatic'),
      fuelType: _parseFuelType(json['fuel_type']?.toString() ?? 'petrol'),
      seats: json['seats'] ?? 5,
      doors: json['doors'] ?? 4,
      dailyRate: (json['daily_rate'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      imageUrl: json['image_url'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'make': make,
        'model': model,
        'year': year,
        'category': category,
        'transmission': transmission.name,
        'fuel_type': fuelType.name,
        'seats': seats,
        'doors': doors,
        'daily_rate': dailyRate,
        'currency': currency,
        'image_url': imageUrl,
        'features': features,
        'is_active': isActive,
      };

  static VehicleTransmission _parseTransmission(String val) {
    return VehicleTransmission.values.firstWhere(
      (e) => e.name == val.toLowerCase(),
      orElse: () => VehicleTransmission.automatic,
    );
  }

  static VehicleFuelType _parseFuelType(String val) {
    return VehicleFuelType.values.firstWhere(
      (e) => e.name == val.toLowerCase(),
      orElse: () => VehicleFuelType.petrol,
    );
  }

  String get fullName => '$make $model ($year)';
}

class VehicleMetadata {
  final String? gpsDeviceId;
  final String? notes;
  final int seats;
  final int doors;
  final List<String> features;

  VehicleMetadata({
    this.gpsDeviceId,
    this.notes,
    required this.seats,
    required this.doors,
    required this.features,
  });

  factory VehicleMetadata.fromJson(Map<String, dynamic> json) {
    return VehicleMetadata(
      gpsDeviceId: json['gps_device_id'],
      notes: json['notes'],
      seats: json['seats'] ?? 0,
      doors: json['doors'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'gps_device_id': gpsDeviceId,
        'notes': notes,
        'seats': seats,
        'doors': doors,
        'features': features,
      };
}

class Vehicle {
  final String id;
  final String vin;
  final String plateNumber;
  final String modelId;
  final VehicleModel? modelDetails;
  final String currentBranchId;
  final String status;
  final VehicleStatus availabilityState;
  final int odometerKm;
  final String color;
  final List<String> photos;
  final VehicleMetadata? metadata;
  final DateTime? lastServicedAt;

  Vehicle({
    required this.id,
    required this.vin,
    required this.plateNumber,
    required this.modelId,
    this.modelDetails,
    required this.currentBranchId,
    required this.status,
    required this.availabilityState,
    required this.odometerKm,
    required this.color,
    required this.photos,
    this.metadata,
    this.lastServicedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? '',
      vin: json['vin'] ?? '',
      plateNumber: json['plate_number'] ?? '',
      modelId: json['vehicle_model_id'] is Map 
          ? json['vehicle_model_id']['_id'] 
          : (json['vehicle_model_id'] ?? ''),
      modelDetails: json['vehicle_model_id'] is Map 
          ? VehicleModel.fromJson(json['vehicle_model_id']) 
          : null,
      currentBranchId: json['branch_id'] is Map 
          ? json['branch_id']['_id'] 
          : (json['branch_id'] ?? ''),
      status: json['status'] ?? 'active',
      availabilityState: _parseStatus(json['availability_state']?.toString() ?? 'available'),
      odometerKm: json['odometer_km'] ?? 0,
      color: json['color'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      metadata: json['metadata'] != null ? VehicleMetadata.fromJson(json['metadata']) : null,
      lastServicedAt: json['last_service_at'] != null 
          ? DateTime.tryParse(json['last_service_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'vin': vin,
        'plate_number': plateNumber,
        'vehicle_model_id': modelId,
        'branch_id': currentBranchId,
        'status': status,
        'availability_state': availabilityState.name,
        'odometer_km': odometerKm,
        'color': color,
        'photos': photos,
        'metadata': metadata?.toJson(),
        'last_service_at': lastServicedAt?.toIso8601String(),
      };

  static VehicleStatus _parseStatus(String val) {
    return VehicleStatus.values.firstWhere(
      (e) => e.name == val.toLowerCase(),
      orElse: () => VehicleStatus.available,
    );
  }
}
