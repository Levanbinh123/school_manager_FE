import '../models/session/session_model.dart';
import '../models/session/create_session_request.dart';
import '../services/session_service.dart';

class SessionRepository {
  final SessionService service;

  SessionRepository({
    required this.service,
  });

  Future<List<SessionModel>> getAllSessions() {
    return service.getAllSessions();
  }

  Future<SessionModel> getSessionById(int id) {
    return service.getSessionById(id);
  }

  Future<void> addSession(
      CreateSessionRequest request,
      ) {
    return service.addSession(request);
  }
}