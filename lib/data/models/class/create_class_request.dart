class CreateClassRequest {
  final String name;
  final int gradeId;

  const CreateClassRequest({
    required this.name,
    required this.gradeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gradeId': gradeId,
    };
  }
}