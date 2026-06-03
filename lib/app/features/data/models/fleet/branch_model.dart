class BranchModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final String email;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final Map<String, dynamic>? openingHours;

  BranchModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    required this.email,
    this.latitude,
    this.longitude,
    required this.isActive,
    this.openingHours,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isActive: json['is_active'] ?? true,
      openingHours: json['opening_hours'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'address': address,
        'city': city,
        'phone': phone,
        'email': email,
        'latitude': latitude,
        'longitude': longitude,
        'is_active': isActive,
        'opening_hours': openingHours,
      };

  String get fullAddress => '$address, $city';
}
