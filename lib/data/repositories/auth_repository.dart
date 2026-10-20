import '../../core/storage/token_storage.dart';
import '../models/auth/login_response.dart';
import '../services/auth_api_service.dart';

class AuthRepository {

  final AuthApiService authApiService;

  AuthRepository({
    required this.authApiService,
  });


  // =========================
  // LOGIN
  // =========================

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {

    final result = await authApiService.login(
      email: email,
      password: password,
    );

    await TokenStorage.saveToken(
      result.token,
    );

    return result;
  }


  // =========================
  // REGISTER
  // =========================




  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {

    final token =
    await TokenStorage.getToken();

    if (token != null) {

      await authApiService.logout(
        token: token,
      );
    }

    await TokenStorage.clearToken();
  }
}