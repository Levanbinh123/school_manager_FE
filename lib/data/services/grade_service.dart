import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/grade/create_grade_request.dart';
import '../models/grade/grade_model.dart';

class GradeService {

  // =========================
  // GET PAGINATION
  // =========================

  Future<List<GradeModel>> getGrades({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final uri = Uri.parse(
      ApiConstants.grades,
    ).replace(
      queryParameters: {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Get grades failed: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    final List<dynamic> list =
    data is List
        ? data
        : data['data'] ?? [];

    return list
        .map(
          (json) => GradeModel.fromJson(json),
    )
        .toList();
  }

  // =========================
  // GET ALL
  // =========================

  Future<List<GradeModel>> getAllGrades() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.grades}/all'),
    );

    print('========== GRADE API ==========');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');
    print('================================');

    if (response.statusCode != 200) {
      throw Exception(
        'Không thể lấy danh sách Grade',
      );
    }

    final decoded = jsonDecode(response.body);

    print('DECODED: $decoded');

    final List<dynamic> data = decoded;

    final grades = data
        .map(
          (json) => GradeModel.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();

    print('PARSED GRADES: $grades');

    return grades;
  }
  // =========================
  // GET BY ID
  // =========================

  Future<GradeModel> getGradeById(
      int id,
      ) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.grades}/$id',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 404) {
      throw Exception(
        'Không tìm thấy Grade',
      );
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Get grade failed: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    return GradeModel.fromJson(data);
  }

  // =========================
  // POST
  // =========================

  Future<void> addGrade(
      CreateGradeRequest request,
      ) async {
    final response = await http.post(
      Uri.parse(
        ApiConstants.grades,
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        request.toJson(),
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return;
    }

    throw Exception(
      'Add grade failed: ${response.body}',
    );
  }
}