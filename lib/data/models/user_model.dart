class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final bool emailVerified;
  final List<UserRole> roles;
  final UserStatus status;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.emailVerified,
    required this.roles,
    required this.status,
  });

  // Helpers for the AuthController logic
  bool get isAdmin => roles.any((role) => role.name == 'admin');
  bool get isManager => roles.any((role) => role.name == 'manager');

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      emailVerified: json['emailVerified'] ?? false,
      roles: (json['roles'] as List? ?? [])
          .map((r) => UserRole(name: r['name']))
          .toList(),
      status: UserStatus(name: json['status'] ?? 'active'),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'emailVerified': emailVerified,
  };
}

class UserRole {
  final String name;
  UserRole({required this.name});
}

class UserStatus {
  final String name;
  UserStatus({required this.name});
}