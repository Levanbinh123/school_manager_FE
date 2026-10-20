class SubjectViewModel {
  final String name;
  final int credits;

  const SubjectViewModel({
    required this.name,
    required this.credits,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.trim(),
      'credits': credits,
    };
  }
  bool get isValid =>
      name.trim().isNotEmpty &&
          credits >= 1 &&
          credits <= 10;
}