import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_ma/data/models/subject/subject_viewmodel.dart';
import 'package:school_ma/data/repositories/subject_repository.dart';

import 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  final SubjectRepository repository;

  SubjectCubit(this.repository) : super(SubjectInitial());

  Future<void> loadSubjects() async {
    emit(SubjectLoading());

    try {
      final subjects = await repository.getAll();
      emit(SubjectLoaded(subjects));
    } catch (e) {
      emit(SubjectError(_message(e)));
    }
  }

  Future<bool> addSubject(SubjectViewModel vm) async {
    if (!vm.isValid) {
      emit(SubjectError('Tên môn không được trống; tín chỉ từ 1 đến 10.'));
      return false;
    }

    try {
      await repository.add(
        name: vm.name,
        credits: vm.credits,
      );

      final subjects = await repository.getAll();
      emit(SubjectSuccess('Thêm môn học thành công.', subjects));
      return true;
    } catch (e) {
      emit(SubjectError(_message(e)));
      return false;
    }
  }

  Future<bool> updateSubject(int id, SubjectViewModel vm) async {
    if (!vm.isValid) {
      emit(SubjectError('Tên môn không được trống; tín chỉ từ 1 đến 10.'));
      return false;
    }

    try {
      await repository.update(
        id: id,
        name: vm.name,
        credits: vm.credits,
      );

      final subjects = await repository.getAll();
      emit(SubjectSuccess('Cập nhật môn học thành công.', subjects));
      return true;
    } catch (e) {
      emit(SubjectError(_message(e)));
      return false;
    }
  }

  Future<bool> deleteSubject(int id) async {
    try {
      await repository.delete(id);

      final subjects = await repository.getAll();
      emit(SubjectSuccess('Xóa môn học thành công.', subjects));
      return true;
    } catch (e) {
      emit(SubjectError(_message(e)));
      return false;
    }
  }

  String _message(Object error) =>
      error.toString().replaceFirst('Exception: ', '');
}