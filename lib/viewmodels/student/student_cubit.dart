import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/student/create_student_request.dart';
import '../../data/models/student/enroll_students_request.dart';
import '../../data/repositories/student_repository.dart';
import 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {

  final StudentRepository repository;

  StudentCubit({
    required this.repository,
  }) : super(
    const StudentInitial(),
  );


  // =========================
  // GET ALL STUDENTS
  // =========================

  Future<void> getStudents({
    int pageNumber = 1,
    int pageSize = 10,
    String? search,
  }) async {

    emit(
      const StudentLoading(),
    );

    try {

      final students =
      await repository.getStudents(
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
      );
      print('========== STUDENT ==========');
      print('Students: ${students.length}');
      print('Data: $students');

      final totalStudents =
      await repository.getStudentCount();
      print('Total students: $totalStudents');

      emit(
        StudentLoaded(
          students: students,
          totalStudents: totalStudents,
        ),
      );

    } catch (e) {

      emit(
        StudentError(
          message: e.toString(),
        ),
      );
    }
  }


  // =========================
  // GET STUDENT BY ID
  // =========================

  Future<void> getStudentById(
      int id,
      ) async {

    emit(
      const StudentLoading(),
    );

    try {

      final student =
      await repository.getStudentById(id);

      emit(
        StudentDetailLoaded(
          student: student,
        ),
      );

    } catch (e) {

      emit(
        StudentError(
          message: e.toString(),
        ),
      );
    }
  }


  // =========================
  // ADD STUDENT
  // =========================

  Future<void> addStudent(
      CreateStudentRequest request,
      ) async {

    emit(
      const StudentLoading(),
    );

    try {

      await repository.addStudent(
        request,
      );

      emit(
        const StudentSuccess(
          message:
          'Thêm học sinh thành công',
        ),
      );

    } catch (e) {

      emit(
        StudentError(
          message: e.toString(),
        ),
      );
    }
  }


  // =========================
  // UPDATE STUDENT
  // =========================

  Future<void> updateStudent(
      int id,
      CreateStudentRequest request,
      ) async {

    emit(
      const StudentLoading(),
    );

    try {

      await repository.updateStudent(
        id,
        request,
      );

      emit(
        const StudentSuccess(
          message:
          'Cập nhật học sinh thành công',
        ),
      );

    } catch (e) {

      emit(
        StudentError(
          message: e.toString(),
        ),
      );
    }
  }


  // =========================
  // DELETE STUDENT
  // =========================

  Future<void> deleteStudent(
      int id,
      ) async {

    emit(
      const StudentLoading(),
    );

    try {

      await repository.deleteStudent(
        id,
      );

      emit(
        const StudentSuccess(
          message:
          'Xóa học sinh thành công',
        ),
      );

    } catch (e) {

      emit(
        StudentError(
          message: e.toString(),
        ),
      );
    }
  }


  // =========================
  // ENROLL STUDENTS
  // =========================

  Future<void> enrollStudents(
      EnrollStudentsRequest request,
      ) async {

    emit(
      const StudentLoading(),
    );

    try {

      final totalAdded =
      await repository.enrollStudents(
        request,
      );

      emit(
        StudentSuccess(
          message:
          'Đã thêm $totalAdded học sinh vào lớp',
        ),
      );

    } catch (e) {

      emit(
        StudentError(
          message: e.toString(),
        ),
      );
    }
  }
}