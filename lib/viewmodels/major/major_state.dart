import '../../data/models/major/major_model.dart';

abstract class MajorState {
  const MajorState();
}

class MajorInitial extends MajorState {
  const MajorInitial();
}

class MajorLoading extends MajorState {
  const MajorLoading();
}

class MajorLoaded extends MajorState {
  final List<MajorModel> majors;

  const MajorLoaded({
    required this.majors,
  });
}

class MajorSuccess extends MajorState {
  final String message;

  const MajorSuccess({
    required this.message,
  });
}

class MajorError extends MajorState {
  final String message;

  const MajorError({
    required this.message,
  });
}