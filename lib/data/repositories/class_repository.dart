import '../models/class/class_model.dart';
import '../models/class/create_class_request.dart';
import '../services/class_service.dart';

class ClassRepository {
  final ClassService service;

  ClassRepository({
    required this.service,
  });

  Future<List<ClassModel>> getAllClasses() {
    return service.getAllClasses();
  }

  Future<ClassModel> getClassById(int id) {
    return service.getClassById(id);
  }

  Future<void> addClass(
      CreateClassRequest request,
      ) {
    return service.addClass(request);
  }

  Future<void> updateClass(
      int id,
      CreateClassRequest request,
      ) {
    return service.updateClass(
      id,
      request,
    );
  }

  Future<void> deleteClass(int id) {
    return service.deleteClass(id);
  }
}