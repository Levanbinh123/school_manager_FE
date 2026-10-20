import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_ma/core/constants/api_constants.dart';
import 'package:school_ma/core/storage/token_storage.dart';
import 'package:school_ma/data/models/subject/subject.dart';



class SubjectService {
  Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Bạn chưa đăng nhập hoặc token đã mất.');
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  dynamic _parseResponse(http.Response response) {
    final body = utf8.decode(response.bodyBytes);

    if (body.isEmpty) return null;

    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  void _checkResponse(http.Response response, dynamic data) {
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return;
    }

    if (response.statusCode == 401) {
      throw Exception('401: Token không hợp lệ hoặc đã hết hạn.');
    }

    if (response.statusCode == 403) {
      throw Exception('403: Tài khoản không có quyền Admin.');
    }

    final message = data is Map
        ? data['message']?.toString() ??
        data['title']?.toString() ??
        'Lỗi HTTP ${response.statusCode}'
        : 'Lỗi HTTP ${response.statusCode}: ${data ?? ''}';

    throw Exception(message);
  }

  // GET: api/admin/Subjects
  Future<List<Subject>> getAll() async {
    final response = await http.get(
      Uri.parse(ApiConstants.subjects),
      headers: await _headers(),
    );

    final data = _parseResponse(response);
    _checkResponse(response, data);

    if (data is! List) {
      throw Exception('Dữ liệu danh sách môn học không hợp lệ.');
    }

    return data
        .map((item) => Subject.fromJson(
      Map<String, dynamic>.from(item as Map),
    ))
        .toList();
  }

  // GET: api/admin/Subjects/{id}
  Future<Subject> getById(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.subjects}/$id'),
      headers: await _headers(),
    );

    final data = _parseResponse(response);
    _checkResponse(response, data);

    if (data is! Map) {
      throw Exception('Dữ liệu môn học không hợp lệ.');
    }

    return Subject.fromJson(Map<String, dynamic>.from(data));
  }

  // POST: api/admin/Subjects
  Future<void> add({
    required String name,
    required int credits,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.subjects),
      headers: await _headers(),
      body: jsonEncode({
        'name': name.trim(),
        'credits': credits,
      }),
    );

    final data = _parseResponse(response);
    _checkResponse(response, data);
  }

  // PUT: api/admin/Subjects/{id}
  Future<void> update({
    required int id,
    required String name,
    required int credits,
  }) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.subjects}/$id'),
      headers: await _headers(),
      body: jsonEncode({
        'name': name.trim(),
        'credits': credits,
      }),
    );

    final data = _parseResponse(response);
    _checkResponse(response, data);
  }

  // DELETE: api/admin/Subjects/{id}
  Future<void> delete(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.subjects}/$id'),
      headers: await _headers(),
    );

    final data = _parseResponse(response);
    _checkResponse(response, data);
  }
}