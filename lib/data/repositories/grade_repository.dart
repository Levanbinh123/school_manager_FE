import '../models/grade/create_grade_request.dart';
import '../models/grade/grade_model.dart';
import '../services/grade_service.dart';

class GradeRepository {
  final GradeService service;

  GradeRepository({
    required this.service,
  });

  // =========================
  // GET PAGINATION
  // =========================

  Future<List<GradeModel>> getGrades({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    return await service.getGrades(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  // =========================
  // GET ALL
  // =========================

  Future<List<GradeModel>> getAllGrades() async {
    return await service.getAllGrades();
  }

  // =========================
  // GET BY ID
  // =========================

  Future<GradeModel> getGradeById(
      int id,
      ) async {
    return await service.getGradeById(id);
  }

  // =========================
  // ADD
  // =========================

  Future<void> addGrade(
      CreateGradeRequest request,
      ) async {
    await service.addGrade(request);
  }
}