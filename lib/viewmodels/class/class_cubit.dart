import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/class/create_class_request.dart';
import '../../data/repositories/class_repository.dart';
import 'class_state.dart';

class ClassCubit extends Cubit<ClassState> {
  final ClassRepository repository;

  ClassCubit({
    required this.repository,
  }) : super(ClassInitial());

  // =========================
  // GET ALL
  // =========================

  Future<void> getAllClasses() async {
    try {
      emit(ClassLoading());

      final classes =
      await repository.getAllClasses();

      emit(
        ClassLoaded(classes),
      );
    } catch (e) {
      emit(
        ClassError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  // =========================
  // GET BY ID
  // =========================

  Future<void> getClassById(int id) async {
    try {
      emit(ClassLoading());

      final classModel =
      await repository.getClassById(id);

      emit(
        ClassDetailLoaded(classModel),
      );
    } catch (e) {
      emit(
        ClassError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  // =========================
  // ADD
  // =========================

  Future<void> addClass(
      CreateClassRequest request,
      ) async {
    try {
      emit(ClassLoading());

      await repository.addClass(request);

      emit(
        ClassSuccess(
          'Thêm Class thành công',
        ),
      );

      await getAllClasses();
    } catch (e) {
      emit(
        ClassError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  // =========================
  // UPDATE
  // =========================

  Future<void> updateClass(
      int id,
      CreateClassRequest request,
      ) async {
    try {
      emit(ClassLoading());

      await repository.updateClass(
        id,
        request,
      );

      emit(
        ClassSuccess(
          'Cập nhật Class thành công',
        ),
      );

      await getAllClasses();
    } catch (e) {
      emit(
        ClassError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  // =========================
  // DELETE
  // =========================

  Future<void> deleteClass(int id) async {
    try {
      emit(ClassLoading());

      await repository.deleteClass(id);

      emit(
        ClassSuccess(
          'Xóa Class thành công',
        ),
      );

      await getAllClasses();
    } catch (e) {
      emit(
        ClassError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  String _getErrorMessage(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '');
  }
}