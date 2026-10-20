
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/storage/token_storage.dart';
import '../models/session/session_model.dart';
import '../models/session/create_session_request.dart';

class SessionService {
  // Lấy header có JWT token
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

  // Lấy danh sách Session
  Future<List<SessionModel>> getAllSessions() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.sessions}/all'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Không thể lấy danh sách Session '
            '(${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw const FormatException(
        'API danh sách Session không trả về JSON dạng List.',
      );
    }

    return decoded
        .map(
          (json) => SessionModel.fromJson(
        Map<String, dynamic>.from(json),
      ),
    )
        .toList();
  }

  // Lấy Session theo ID
  Future<SessionModel> getSessionById(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.sessions}/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Không tìm thấy Session '
            '(HTTP ${response.statusCode}): ${response.body}',
      );
    }

    return SessionModel.fromJson(
      Map<String, dynamic>.from(
        jsonDecode(response.body),
      ),
    );
  }

  // Thêm Session
  Future<void> addSession(
      CreateSessionRequest request,
      ) async {
    final response = await http.post(
      Uri.parse(ApiConstants.sessions),
      headers: await _getHeaders(),
      body: jsonEncode(request.toJson()),
    );

    // ASP.NET Core có thể trả 200 hoặc 201 khi tạo thành công.
    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 204) {
      throw Exception(
        'Không thể thêm Session '
            '(HTTP ${response.statusCode}): ${response.body}',
      );
    }
  }
}
