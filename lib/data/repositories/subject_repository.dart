
import 'package:school_ma/data/models/subject/subject.dart';

import '../services/subject_service.dart';

class SubjectRepository {
  final SubjectService service;

  SubjectRepository(this.service);

  Future<List<Subject>> getAll() {
    return service.getAll();
  }

  Future<Subject> getById(int id) {
    return service.getById(id);
  }

  Future<void> add({
    required String name,
    required int credits,
  }) {
    return service.add(
      name: name,
      credits: credits,
    );
  }

  Future<void> update({
    required int id,
    required String name,
    required int credits,
  }) {
    return service.update(
      id: id,
      name: name,
      credits: credits,
    );
  }

  Future<void> delete(int id) {
    return service.delete(id);
  }
}