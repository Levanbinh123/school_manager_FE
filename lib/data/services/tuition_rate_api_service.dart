
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_ma/core/constants/api_constants.dart';
import 'package:school_ma/core/storage/token_storage.dart';
import 'package:school_ma/data/models/session/tuition_rate_model.dart';

class TuitionRateApiService {
  // Dùng URL endpoint học phí được khai báo trong ApiConstants.
  Uri _uri(String path) {
    return Uri.parse('${ApiConstants.tuitionRates}$path');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Không tìm thấy token. Vui lòng đăng nhập lại.',
      );
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  dynamic _decode(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return;
    }

    var message = 'Lỗi API: HTTP ${response.statusCode}';

    try {
      final data = _decode(response);
      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      }
    } catch (_) {
      // Giữ thông báo lỗi mặc định nếu body không phải JSON.
    }

    if (response.statusCode == 401) {
      message = 'Phiên đăng nhập hết hạn hoặc JWT không hợp lệ.';
    } else if (response.statusCode == 403) {
      message = 'Tài khoản không có quyền Admin.';
    }

    throw Exception(message);
  }

  // GET: api/admin/tuition-rates
  Future<List<TuitionRateModel>> getAll() async {
    final response = await http.get(
      _uri(''),
      headers: await _getHeaders(),
    );

    _checkResponse(response);

    final data = _decode(response);

    if (data is! List) {
      throw Exception('Dữ liệu mức học phí không hợp lệ.');
    }

    return data.map((item) {
      return TuitionRateModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // GET: api/admin/tuition-rates/session/{sessionId}
  Future<TuitionRateModel> getBySession(int sessionId) async {
    final response = await http.get(
      _uri('/session/$sessionId'),
      headers: await _getHeaders(),
    );

    _checkResponse(response);

    final data = _decode(response);

    if (data is! Map) {
      throw Exception('Dữ liệu học phí của Session không hợp lệ.');
    }

    return TuitionRateModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // POST: api/admin/tuition-rates
  Future<TuitionRateModel> create({
    required int sessionId,
    required double pricePerCredit,
  }) async {
    final response = await http.post(
      _uri(''),
      headers: await _getHeaders(),
      body: jsonEncode({
        'sessionId': sessionId,
        'pricePerCredit': pricePerCredit,
      }),
    );

    _checkResponse(response);

    final data = _decode(response);

    if (data is! Map) {
      throw Exception('API không trả về mức học phí vừa tạo.');
    }

    return TuitionRateModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // PUT: api/admin/tuition-rates/{id}
  Future<void> update({
    required int id,
    required double pricePerCredit,
  }) async {
    final response = await http.put(
      _uri('/$id'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'pricePerCredit': pricePerCredit,
      }),
    );

    _checkResponse(response);
  }

  // DELETE: api/admin/tuition-rates/{id}
  Future<void> delete(int id) async {
    final response = await http.delete(
      _uri('/$id'),
      headers: await _getHeaders(),
    );

    _checkResponse(response);
  }
}
