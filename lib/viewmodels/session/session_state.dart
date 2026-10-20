import '../../data/models/session/session_model.dart';

abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionLoaded extends SessionState {
  final List<SessionModel> sessions;

  SessionLoaded(this.sessions);
}

class SessionDetailLoaded extends SessionState {
  final SessionModel session;

  SessionDetailLoaded(this.session);
}

class SessionSuccess extends SessionState {
  final String message;

  SessionSuccess(this.message);
}

class SessionError extends SessionState {
  final String message;

  SessionError(this.message);
}