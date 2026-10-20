abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final String token;
  final String userId;
  final String email;
  final String fullName;
  final List<String> roles;

  AuthLoginSuccess({
    required this.token,
    required this.userId,
    required this.email,
    required this.fullName,
    required this.roles,
  });
}

class AuthRegisterSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

class AuthLogoutSuccess extends AuthState {}