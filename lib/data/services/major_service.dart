import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_ma/core/constants/api_constants.dart';
import '../../core/storage/token_storage.dart';
import '../models/major/major_model.dart';

class MajorService {
  Future<Map<String, String>> _getHeaders() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Bạn chưa đăng nhập hoặc phiên đăng nhập đã hết hạn.',
      );
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  Future<List<MajorModel>> getAllMajors() async {
    final response = await http.get(
      Uri.parse(ApiConstants.majors),
      headers:await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<dynamic> list = data is List
          ? data
          : data['data'] ?? data['items'] ?? [];

      return list
          .map((json) => MajorModel.fromJson(
        Map<String, dynamic>.from(json),
      ))
          .toList();
    }

    throw Exception(
      'Get majors failed: ${response.body}',
    );
  }

  // =========================
  // GET MAJOR BY ID
  // =========================
  Future<MajorModel> getMajorById(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.majors}/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return MajorModel.fromJson(
        Map<String, dynamic>.from(
          data is Map && data['data'] is Map
              ? data['data']
              : data,
        ),
      );
    }

    throw Exception(
      'Get major failed: ${response.body}',
    );
  }

  // =========================
  // ADD MAJOR
  // =========================
  Future<void> addMajor({
    required String name,
    required int requiredCredits,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.majors),
      headers: await _getHeaders(),
      body: jsonEncode({
        'name': name,
        'requiredCredits': requiredCredits,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return;
    }

    throw Exception(
      'Add major failed: ${response.body}',
    );
  }

  // =========================
  // UPDATE MAJOR
  // =========================
  Future<void> updateMajor({
    required int id,
    required String name,
    required int requiredCredits,
  }) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.majors}/$id'),
      headers:await _getHeaders(),
      body: jsonEncode({
        'name': name,
        'requiredCredits': requiredCredits,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204) {
      return;
    }

    throw Exception(
      'Update major failed: ${response.body}',
    );
  }

  // =========================
  // DELETE MAJOR
  // =========================
  Future<void> deleteMajor(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.majors}/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204) {
      return;
    }

    throw Exception(
      'Delete major failed: ${response.body}',
    );
  }
}