class DriverLicense {
  final String number;
  final String imageUrl;
  final String country;
  final String licenseClass;
  final String expiresAt;
  final bool verified;

  DriverLicense({
    required this.number,
    required this.imageUrl,
    required this.country,
    required this.licenseClass,
    required this.expiresAt,
    required this.verified,
  });

  factory DriverLicense.fromJson(Map<String, dynamic> json) {
    return DriverLicense(
      number: json['number'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      country: json['country'] ?? '',
      licenseClass: json['class'] ?? '',
      expiresAt: json['expires_at'] ?? '',
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'imageUrl': imageUrl,
        'country': country,
        'class': licenseClass,
        'expires_at': expiresAt,
        'verified': verified,
      };
}

class IdentityDocument {
  final String type;
  final String imageUrl;

  IdentityDocument({
    required this.type,
    required this.imageUrl,
  });

  factory IdentityDocument.fromJson(Map<String, dynamic> json) {
    return IdentityDocument(
      type: json['type'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'imageUrl': imageUrl,
      };
}

class DriverUserId {
  final String id;
  final String fullName;

  DriverUserId({
    required this.id,
    required this.fullName,
  });

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
  final String baseRegion;
  final String baseCountry;
  final double hourlyRate;
  final String bio;
  final int yearsExperience;
  final List<String> languages;
  final IdentityDocument? identityDocument;
  final DriverLicense? driverLicense;
  final String status;
  final String? approvedAt;
  final bool isAvailable;
  final double ratingAverage;
  final int ratingCount;
  final String? profileImage;
  final String createdAt;
  final String updatedAt;

  DriverProfileModel({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.baseCity,
    required this.baseRegion,
    required this.baseCountry,
    required this.hourlyRate,
    required this.bio,
    required this.yearsExperience,
    required this.languages,
    this.identityDocument,
    this.driverLicense,
    required this.status,
    this.approvedAt,
    required this.isAvailable,
    required this.ratingAverage,
    required this.ratingCount,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      id: json['_id'] ?? '',
      userId: json['user_id'] is Map<String, dynamic>
          ? DriverUserId.fromJson(json['user_id'])
          : DriverUserId(id: json['user_id']?.toString() ?? '', fullName: ''),
      displayName: json['display_name'] ?? '',
      baseCity: json['base_city'] ?? '',
      baseRegion: json['base_region'] ?? '',
      baseCountry: json['base_country'] ?? '',
      hourlyRate: (json['hourly_rate'] ?? 0).toDouble(),
      bio: json['bio'] ?? '',
      yearsExperience: json['years_experience'] ?? 0,
      languages: List<String>.from(json['languages'] ?? []),
      identityDocument: json['identity_document'] != null
          ? IdentityDocument.fromJson(json['identity_document'])
          : null,
      driverLicense: json['driver_license'] != null
          ? DriverLicense.fromJson(json['driver_license'])
          : null,
      status: json['status'] ?? '',
      approvedAt: json['approved_at'],
      isAvailable: json['is_available'] ?? false,
      ratingAverage: (json['rating_average'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      profileImage: json['profile_image'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'display_name': displayName,
        'base_city': baseCity,
        'base_region': baseRegion,
        'base_country': baseCountry,
        'hourly_rate': hourlyRate,
        'bio': bio,
        'years_experience': yearsExperience,
        'languages': languages,
        'identity_document': identityDocument?.toJson(),
        'driver_license': driverLicense?.toJson(),
        'status': status,
        'approved_at': approvedAt,
        'is_available': isAvailable,
        'rating_average': ratingAverage,
        'rating_count': ratingCount,
        'profile_image': profileImage,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  /// Helper: is driver profile fully approved?
  bool get isApproved => status == 'approved';

  /// Helper: License expiry string in readable format
  String get licenseExpiryFormatted {
    if (driverLicense == null || driverLicense!.expiresAt.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(driverLicense!.expiresAt);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return driverLicense!.expiresAt;
    }
  }
}
