import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/student/student_model.dart';
import '../models/student/create_student_request.dart';
import '../models/student/enroll_students_request.dart';

class StudentApiService {

  // =========================
  // GET ALL STUDENTS
  // =========================

  Future<List<StudentModel>> getStudents({
    int pageNumber = 1,
    int pageSize = 10,
    String? search,
  }) async {

    final uri = Uri.parse(
      ApiConstants.students,
    ).replace(
      queryParameters: {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),

        if (search != null && search.isNotEmpty)
          'search': search,
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(
        response.body,
      );

      final List<dynamic> list =
      data is List
          ? data
          : data['items'] ?? [];

      return list
          .map(
            (json) =>
            StudentModel.fromJson(json),
      )
          .toList();
    }

    throw Exception(
      'Get students failed: ${response.body}',
    );
  }


  // =========================
  // GET STUDENT BY ID
  // =========================

  Future<StudentModel> getStudentById(
      int id,
      ) async {

    final response = await http.get(
      Uri.parse(
        '${ApiConstants.students}/$id',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(
        response.body,
      );

      return StudentModel.fromJson(data);
    }

    if (response.statusCode == 404) {
      throw Exception(
        'Không tìm thấy Student',
      );
    }

    throw Exception(
      'Get student failed: ${response.body}',
    );
  }


  // =========================
  // GET STUDENT COUNT
  // =========================

  Future<int> getStudentCount() async {

    final response = await http.get(
      Uri.parse(
        ApiConstants.studentCount,
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(
        response.body,
      );

      return data['totalStudents'] ?? 0;
    }

    throw Exception(
      'Get student count failed: '
          '${response.body}',
    );
  }


  // =========================
  // ADD STUDENT
  // =========================

  Future<void> addStudent(
      CreateStudentRequest request,
      ) async {

    final response = await http.post(
      Uri.parse(
        ApiConstants.students,
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
      'Add student failed: '
          '${response.body}',
    );
  }


  // =========================
  // UPDATE STUDENT
  // =========================

  Future<void> updateStudent(
      int id,
      CreateStudentRequest request,
      ) async {

    final response = await http.put(
      Uri.parse(
        '${ApiConstants.students}/$id',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        request.toJson(),
      ),
    );

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 404) {
      throw Exception(
        'Không tìm thấy Student',
      );
    }

    throw Exception(
      'Update student failed: '
          '${response.body}',
    );
  }


  // =========================
  // DELETE STUDENT
  // =========================

  Future<void> deleteStudent(
      int id,
      ) async {

    final response = await http.delete(
      Uri.parse(
        '${ApiConstants.students}/$id',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 404) {
      throw Exception(
        'Không tìm thấy Student',
      );
    }

    throw Exception(
      'Delete student failed: '
          '${response.body}',
    );
  }


  // =========================
  // ENROLL STUDENTS
  // =========================

  Future<int> enrollStudents(
      EnrollStudentsRequest request,
      ) async {

    final response = await http.post(
      Uri.parse(
        ApiConstants.enrollStudents,
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        request.toJson(),
      ),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(
        response.body,
      );

      return data['totalAdded'] ?? 0;
    }

    throw Exception(
      'Enroll students failed: '
          '${response.body}',
    );
  }
}