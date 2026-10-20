import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/auth/login_response.dart';


class AuthApiService {

  // =========================
  // LOGIN
  // =========================

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {

    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return LoginResponse.fromJson(data);
    }

    if (response.statusCode == 401) {
      throw Exception(
        'Email hoặc password không chính xác',
      );
    }

    throw Exception(
      'Login failed: ${response.body}',
    );
  }


  // =========================
  // REGISTER
  // =========================


  // =========================
  // LOGOUT
  // =========================

  Future<void> logout({
    required String token,
  }) async {

    final response = await http.post(
      Uri.parse(ApiConstants.logout),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return;
    }

    throw Exception(
      'Logout failed: ${response.body}',
    );
  }
}