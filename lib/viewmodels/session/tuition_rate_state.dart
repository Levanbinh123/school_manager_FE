


import 'package:school_ma/data/models/session/tuition_rate_model.dart';

abstract class TuitionRateState {}

class TuitionRateInitial extends TuitionRateState {}

class TuitionRateLoading extends TuitionRateState {}

class TuitionRateLoaded extends TuitionRateState {
  final List<TuitionRateModel> rates;

  TuitionRateLoaded(this.rates);
}

class TuitionRateSuccess extends TuitionRateState {
  final String message;

  TuitionRateSuccess(this.message);
}

class TuitionRateError extends TuitionRateState {
  final String message;

  TuitionRateError(this.message);
}
