class MajorModel {
  final int id;
  final String name;
  final int requiredCredits;

  const MajorModel({
    required this.id,
    required this.name,
    required this.requiredCredits,
  });

  factory MajorModel.fromJson(Map<String, dynamic> json) {
    return MajorModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      requiredCredits: json['requiredCredits'] ?? 120,
    );
  }
}