
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:school_ma/data/repositories/tuition_rate_repository.dart';
import 'package:school_ma/viewmodels/session/tuition_rate_state.dart';

class TuitionRateCubit extends Cubit<TuitionRateState> {
  final TuitionRateRepository _repository;

  TuitionRateCubit(this._repository)
      : super(TuitionRateInitial());

  Future<void> loadRates() async {
    emit(TuitionRateLoading());

    try {
      final rates = await _repository.getAll();
      emit(TuitionRateLoaded(rates));
    } catch (e) {
      emit(TuitionRateError(e.toString()));
    }
  }

  Future<void> createRate({
    required int sessionId,
    required double pricePerCredit,
  }) async {
    emit(TuitionRateLoading());

    try {
      await _repository.create(
        sessionId: sessionId,
        pricePerCredit: pricePerCredit,
      );

      final rates = await _repository.getAll();
      emit(TuitionRateLoaded(rates));
    } catch (e) {
      emit(TuitionRateError(e.toString()));
    }
  }

  Future<void> updateRate({
    required int id,
    required double pricePerCredit,
  }) async {
    emit(TuitionRateLoading());

    try {
      await _repository.update(
        id: id,
        pricePerCredit: pricePerCredit,
      );

      final rates = await _repository.getAll();
      emit(TuitionRateLoaded(rates));
    } catch (e) {
      emit(TuitionRateError(e.toString()));
    }
  }

  Future<void> deleteRate(int id) async {
    emit(TuitionRateLoading());

    try {
      await _repository.delete(id);

      final rates = await _repository.getAll();
      emit(TuitionRateLoaded(rates));
    } catch (e) {
      emit(TuitionRateError(e.toString()));
    }
  }
}
