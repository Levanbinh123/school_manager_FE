  import '../../data/models/class/class_model.dart';

  abstract class ClassState {}

  class ClassInitial extends ClassState {}

  class ClassLoading extends ClassState {}

  class ClassLoaded extends ClassState {
    final List<ClassModel> classes;

    ClassLoaded(this.classes);
  }

  class ClassDetailLoaded extends ClassState {
    final ClassModel classModel;

    ClassDetailLoaded(this.classModel);
  }

  class ClassSuccess extends ClassState {
    final String message;

    ClassSuccess(this.message);
  }

  class ClassError extends ClassState {
    final String message;

    ClassError(this.message);
  }