enum UserRole {
  customer,
  agent,
  manager,
  admin,
  driver,
}

enum UserStatus {
  pending,
  active,
  suspended,
  deleted,
}

class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String fullName;
  final List<UserRole> roles;
  final UserStatus status;
  final bool emailVerified;
  final List<dynamic> authProviders;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.phone,
    required this.fullName,
    required this.roles,
    required this.status,
    required this.emailVerified,
    required this.authProviders,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      fullName: json['full_name'] ?? '',
      roles: (json['roles'] as List? ?? [])
          .map((r) => _parseRole(r.toString()))
          .toList(),
      status: _parseStatus(json['status']?.toString() ?? 'pending'),
      emailVerified: json['email_verified'] ?? false,
      authProviders: json['auth_providers'] ?? [],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
        'phone': phone,
        'full_name': fullName,
        'roles': roles.map((r) => r.name).toList(),
        'status': status.name,
        'email_verified': emailVerified,
        'auth_providers': authProviders,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  static UserRole _parseRole(String role) {
    return UserRole.values.firstWhere(
      (r) => r.name == role,
      orElse: () => UserRole.customer,
    );
  }

  static UserStatus _parseStatus(String status) {
    return UserStatus.values.firstWhere(
      (s) => s.name == status,
      orElse: () => UserStatus.pending,
    );
  }

  // Helper getters
  bool get isAdmin => roles.contains(UserRole.admin);
  bool get isDriver => roles.contains(UserRole.driver);
  bool get isManager => roles.contains(UserRole.manager);
}
