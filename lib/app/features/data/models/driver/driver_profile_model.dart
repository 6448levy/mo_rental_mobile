class DriverUserId {
  final String id;
  final String fullName;

  DriverUserId({required this.id, required this.fullName});

  factory DriverUserId.fromJson(Map<String, dynamic> json) {
    return DriverUserId(
      id: json['_id'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }
}

class DriverProfileModel {
  final String id;
  final DriverUserId userId;
  final String displayName;
  final String baseCity;
  final String baseCountry;
  final double hourlyRate;
  final int yearsExperience;
  final double ratingAverage;
  final int ratingCount;
  final String? profileImage;
  final String status;
  final bool isAvailable;
  final List<String> languages;
  final dynamic driverLicense; // Added to satisfy controller checks
  final dynamic identityDocument; // Added to satisfy controller checks

  DriverProfileModel({
    required this.id,
    required this.userId,
    required this.displayName,
    this.baseCity = '',
    this.baseCountry = '',
    this.hourlyRate = 0.0,
    this.yearsExperience = 0,
    this.ratingAverage = 0.0,
    this.ratingCount = 0,
    this.profileImage,
    required this.status,
    this.isAvailable = false,
    this.languages = const [],
    this.driverLicense,
    this.identityDocument,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      id: json['_id'] ?? '',
      userId: json['user_id'] is Map<String, dynamic>
          ? DriverUserId.fromJson(json['user_id'])
          : DriverUserId(id: json['user_id']?.toString() ?? '', fullName: ''),
      displayName: json['display_name'] ?? '',
      baseCity: json['base_city'] ?? '',
      baseCountry: json['base_country'] ?? '',
      hourlyRate: (json['hourly_rate'] ?? 0).toDouble(),
      yearsExperience: json['years_experience'] ?? 0,
      ratingAverage: (json['rating_average'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      profileImage: json['profile_image'],
      status: json['status'] ?? 'pending',
      isAvailable: json['is_available'] ?? false,
      languages: List<String>.from(json['languages'] ?? []),
    );
  }

  // Helper used by DriverController
  bool get isApproved => status == 'approved';
  
  // Helper for safety
  String get bio => ""; 
  String get licenseExpiryFormatted => "N/A";
}