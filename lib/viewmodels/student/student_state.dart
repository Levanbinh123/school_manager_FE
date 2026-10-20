import '../../data/models/student/student_model.dart';

abstract class StudentState {
  const StudentState();
}

// =========================
// INITIAL
// =========================

class StudentInitial extends StudentState {
  const StudentInitial();
}


// =========================
// LOADING
// =========================

class StudentLoading extends StudentState {
  const StudentLoading();
}


// =========================
// LOADED
// =========================

class StudentLoaded extends StudentState {
  final List<StudentModel> students;
  final int totalStudents;

  const StudentLoaded({
    required this.students,
    required this.totalStudents,
  });
}


// =========================
// DETAIL
// =========================

class StudentDetailLoaded extends StudentState {
  final StudentModel student;

  const StudentDetailLoaded({
    required this.student,
  });
}


// =========================
// SUCCESS
// =========================

class StudentSuccess extends StudentState {
  final String message;

  const StudentSuccess({
    required this.message,
  });
}


// =========================
// ERROR
// =========================

class StudentError extends StudentState {
  final String message;

  const StudentError({
    required this.message,
  });
}