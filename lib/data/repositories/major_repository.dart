import '../models/major/major_model.dart';
import '../services/major_service.dart';

class MajorRepository {
  final MajorService service;

  MajorRepository({
    required this.service,
  });

  Future<List<MajorModel>> getAllMajors() {
    return service.getAllMajors();
  }

  Future<MajorModel> getMajorById(int id) {
    return service.getMajorById(id);
  }

  Future<void> addMajor({
    required String name,
    required int requiredCredits,
  }) {
    return service.addMajor(
      name: name,
      requiredCredits: requiredCredits,
    );
  }

  Future<void> updateMajor({
    required int id,
    required String name,
    required int requiredCredits,
  }) {
    return service.updateMajor(
      id: id,
      name: name,
      requiredCredits: requiredCredits,
    );
  }

  Future<void> deleteMajor(int id) {
    return service.deleteMajor(id);
  }
}