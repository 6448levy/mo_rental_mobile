import '../user_model.dart';

class LoginResponse {
  final UserModel user;
  final String token;

  LoginResponse({
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }

  // Add toJson() method for LoginResponse
  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'token': token,
      };
}

