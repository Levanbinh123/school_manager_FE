import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/grade/create_grade_request.dart';
import '../../data/repositories/grade_repository.dart';
import 'grade_state.dart';

class GradeCubit extends Cubit<GradeState> {
  final GradeRepository repository;

  GradeCubit({
    required this.repository,
  }) : super(
    const GradeInitial(),
  );

  // =========================
  // GET GRADES
  // =========================

  Future<void> getGrades({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    emit(
      const GradeLoading(),
    );

    try {
      final grades =
      await repository.getGrades(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      emit(
        GradeLoaded(
          grades: grades,
        ),
      );
    } catch (e) {
      emit(
        GradeError(
          message: e.toString(),
        ),
      );
    }
  }

  // =========================
  // GET ALL
  // =========================

  Future<void> getAllGrades() async {
    emit(
      const GradeLoading(),
    );

    try {
      final grades =
      await repository.getAllGrades();

      emit(
        GradeLoaded(
          grades: grades,
        ),
      );
    } catch (e) {
      emit(
        GradeError(
          message: e.toString(),
        ),
      );
    }
  }

  // =========================
  // GET BY ID
  // =========================

  Future<void> getGradeById(
      int id,
      ) async {
    emit(
      const GradeLoading(),
    );

    try {
      final grade =
      await repository.getGradeById(id);

      emit(
        GradeDetailLoaded(
          grade: grade,
        ),
      );
    } catch (e) {
      emit(
        GradeError(
          message: e.toString(),
        ),
      );
    }
  }

  // =========================
  // ADD
  // =========================

  Future<void> addGrade(
      CreateGradeRequest request,
      ) async {
    emit(
      const GradeLoading(),
    );

    try {
      await repository.addGrade(
        request,
      );

      emit(
        const GradeSuccess(
          message: 'Thêm khối thành công',
        ),
      );
    } catch (e) {
      emit(
        GradeError(
          message: e.toString(),
        ),
      );
    }
  }
}