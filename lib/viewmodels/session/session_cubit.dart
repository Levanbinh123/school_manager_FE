import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/session/create_session_request.dart';
import '../../data/repositories/session_repository.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final SessionRepository repository;

  SessionCubit({
    required this.repository,
  }) : super(SessionInitial());

  Future<void> getAllSessions() async {
    try {
      emit(SessionLoading());

      final sessions =
      await repository.getAllSessions();

      emit(SessionLoaded(sessions));
    } catch (e) {
      emit(
        SessionError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  Future<void> getSessionById(int id) async {
    try {
      emit(SessionLoading());

      final session =
      await repository.getSessionById(id);

      emit(SessionDetailLoaded(session));
    } catch (e) {
      emit(
        SessionError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  Future<void> addSession(
      CreateSessionRequest request,
      ) async {
    try {
      emit(SessionLoading());

      await repository.addSession(request);

      emit(
        SessionSuccess(
          'Thêm Session thành công',
        ),
      );

      await getAllSessions();
    } catch (e) {
      emit(
        SessionError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
}