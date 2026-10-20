class Subject {
  final int id;
  final String name;
  final int credits;

  const Subject({
    required this.id,
    required this.name,
    required this.credits,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      credits: (json['credits'] as num?)?.toInt() ?? 0,
    );
  }
}