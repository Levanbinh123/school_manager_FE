class CreateGradeRequest {
  final String name;

  const CreateGradeRequest({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}