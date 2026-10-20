import 'package:school_ma/data/models/subject/subject.dart';


abstract class SubjectState {}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<Subject> subjects;

  SubjectLoaded(this.subjects);
}

class SubjectError extends SubjectState {
  final String message;

  SubjectError(this.message);
}

class SubjectSuccess extends SubjectState {
  final String message;
  final List<Subject> subjects;

  SubjectSuccess(this.message, this.subjects);
}