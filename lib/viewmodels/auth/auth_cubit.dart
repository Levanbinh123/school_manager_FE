import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  final AuthRepository authRepository;

  AuthCubit({
    required this.authRepository,
  }) : super(AuthInitial());


  // =========================
  // LOGIN
  // =========================

  Future<void> login({
    required String email,
    required String password,
  }) async {

    emit(AuthLoading());

    try {

      final result =
      await authRepository.login(
        email: email,
        password: password,
      );

      emit(
        AuthLoginSuccess(
          token: result.token,
          userId: result.userId,
          email: result.email,
          fullName: result.fullName,
          roles: result.roles,
        ),
      );

    } catch (e) {

      emit(
        AuthFailure(
          e.toString(),
        ),
      );
    }
  }


  // =========================
  // REGISTER
  // =========================

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {

    emit(AuthLoading());

    try {

      await authRepository.logout();

      emit(
        AuthLogoutSuccess(),
      );

    } catch (e) {

      emit(
        AuthFailure(
          e.toString(),
        ),
      );
    }
  }
}