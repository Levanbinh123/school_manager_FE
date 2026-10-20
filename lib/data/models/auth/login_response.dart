class LoginResponse {
  final String token;
  final String userId;
  final String email;
  final String fullName;
  final List<String> roles;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.email,
    required this.fullName,
    required this.roles,
  });

  factory LoginResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return LoginResponse(
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      roles: List<String>.from(
        json['roles'] ?? [],
      ),
    );
  }
}