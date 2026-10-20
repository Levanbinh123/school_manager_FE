import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/class/class_model.dart';
import '../models/class/create_class_request.dart';

class ClassService {
  // =========================
  // GET ALL
  // =========================
  Future<List<ClassModel>> getAllClasses() async {
    final response = await http.get(
      Uri.parse(ApiConstants.classes),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Không thể lấy danh sách Class',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map(
          (json) => ClassModel.fromJson(json),
    )
        .toList();
  }

  // =========================
  // GET BY ID
  // =========================
  Future<ClassModel> getClassById(int id) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.classes}/$id',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Không tìm thấy Class',
      );
    }

    final data = jsonDecode(response.body);

    return ClassModel.fromJson(data);
  }

  // =========================
  // ADD
  // =========================
  Future<void> addClass(
      CreateClassRequest request,
      ) async {
    print('========== ADD CLASS ==========');
    print('NAME: ${request.name}');
    print('GRADE ID: ${request.gradeId}');
    print('BODY: ${jsonEncode(request.toJson())}');
    final response = await http.post(
      Uri.parse(ApiConstants.classes),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        request.toJson(),
      ),
    );
    print('STATUS: ${response.statusCode}');
    print('RESPONSE: ${response.body}');
    print('================================');
    if (response.statusCode != 200) {
      String message = 'Không thể thêm Class';

      try {
        final data = jsonDecode(response.body);

        if (data['message'] != null) {
          message = data['message'];
        }
      } catch (_) {}

      throw Exception(message);
    }
  }

  // =========================
  // UPDATE
  // =========================
  Future<void> updateClass(
      int id,
      CreateClassRequest request,
      ) async {
    final response = await http.put(
      Uri.parse(
        '${ApiConstants.classes}/$id',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        request.toJson(),
      ),
    );

    if (response.statusCode != 200) {
      String message = 'Không thể cập nhật Class';

      try {
        final data = jsonDecode(response.body);

        if (data['message'] != null) {
          message = data['message'];
        }
      } catch (_) {}

      throw Exception(message);
    }
  }

  // =========================
  // DELETE
  // =========================
  Future<void> deleteClass(int id) async {
    final response = await http.delete(
      Uri.parse(
        '${ApiConstants.classes}/$id',
      ),
    );

    if (response.statusCode != 200) {
      String message = 'Không thể xóa Class';

      try {
        final data = jsonDecode(response.body);

        if (data['message'] != null) {
          message = data['message'];
        }
      } catch (_) {}

      throw Exception(message);
    }
  }
}