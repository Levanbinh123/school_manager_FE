
import 'package:school_ma/data/models/session/tuition_rate_model.dart';
import 'package:school_ma/data/services/tuition_rate_api_service.dart';

class TuitionRateRepository {
  final TuitionRateApiService _apiService;

  TuitionRateRepository(this._apiService);

  Future<List<TuitionRateModel>> getAll() {
    return _apiService.getAll();
  }

  Future<TuitionRateModel> getBySession(int sessionId) {
    return _apiService.getBySession(sessionId);
  }

  Future<TuitionRateModel> create({
    required int sessionId,
    required double pricePerCredit,
  }) {
    return _apiService.create(
      sessionId: sessionId,
      pricePerCredit: pricePerCredit,
    );
  }

  Future<void> update({
    required int id,
    required double pricePerCredit,
  }) {
    return _apiService.update(
      id: id,
      pricePerCredit: pricePerCredit,
    );
  }

  Future<void> delete(int id) {
    return _apiService.delete(id);
  }
}
