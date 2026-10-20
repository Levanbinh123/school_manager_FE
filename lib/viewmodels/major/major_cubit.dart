import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/major_repository.dart';
import '../../data/models/major/major_model.dart';
import 'major_state.dart';

class MajorCubit extends Cubit<MajorState> {
  final MajorRepository repository;

  MajorCubit({
    required this.repository,
  }) : super(const MajorInitial());

  List<MajorModel> _majors = [];

  // =========================
  // GET ALL MAJORS
  // =========================
  Future<void> getAllMajors() async {
    emit(const MajorLoading());

    try {
      _majors = await repository.getAllMajors();

      emit(MajorLoaded(majors: _majors));
    } catch (e) {
      emit(MajorError(message: e.toString()));
    }
  }

  // =========================
  // ADD MAJOR
  // =========================
  Future<void> addMajor({
    required String name,
    required int requiredCredits,
  }) async {
    emit(const MajorLoading());

    try {
      await repository.addMajor(
        name: name,
        requiredCredits: requiredCredits,
      );

      _majors = await repository.getAllMajors();

      emit(const MajorSuccess(
        message: 'Thêm ngành học thành công',
      ));

      emit(MajorLoaded(majors: _majors));
    } catch (e) {
      emit(MajorError(message: e.toString()));
    }
  }

  // =========================
  // UPDATE MAJOR
  // =========================
  Future<void> updateMajor({
    required int id,
    required String name,
    required int requiredCredits,
  }) async {
    emit(const MajorLoading());

    try {
      await repository.updateMajor(
        id: id,
        name: name,
        requiredCredits: requiredCredits,
      );

      _majors = await repository.getAllMajors();

      emit(const MajorSuccess(
        message: 'Cập nhật ngành học thành công',
      ));

      emit(MajorLoaded(majors: _majors));
    } catch (e) {
      emit(MajorError(message: e.toString()));
    }
  }

  // =========================
  // DELETE MAJOR
  // =========================
  Future<void> deleteMajor(int id) async {
    emit(const MajorLoading());

    try {
      await repository.deleteMajor(id);

      _majors = await repository.getAllMajors();

      emit(const MajorSuccess(
        message: 'Xóa ngành học thành công',
      ));

      emit(MajorLoaded(majors: _majors));
    } catch (e) {
      emit(MajorError(message: e.toString()));
    }
  }
}