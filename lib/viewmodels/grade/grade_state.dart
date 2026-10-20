import '../../data/models/grade/grade_model.dart';

abstract class GradeState {
  const GradeState();
}

// =========================
// INITIAL
// =========================

class GradeInitial extends GradeState {
  const GradeInitial();
}

// =========================
// LOADING
// =========================

class GradeLoading extends GradeState {
  const GradeLoading();
}

// =========================
// LOADED
// =========================

class GradeLoaded extends GradeState {
  final List<GradeModel> grades;

  const GradeLoaded({
    required this.grades,
  });
}

// =========================
// DETAIL
// =========================

class GradeDetailLoaded extends GradeState {
  final GradeModel grade;

  const GradeDetailLoaded({
    required this.grade,
  });
}

// =========================
// SUCCESS
// =========================

class GradeSuccess extends GradeState {
  final String message;

  const GradeSuccess({
    required this.message,
  });
}

// =========================
// ERROR
// =========================

class GradeError extends GradeState {
  final String message;

  const GradeError({
    required this.message,
  });
}