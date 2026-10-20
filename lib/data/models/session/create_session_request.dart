
class CreateSessionRequest {
  final DateTime start;
  final DateTime end;
  final int maxCredits;
  final String name;

  const CreateSessionRequest({
    required this.start,
    required this.end,
    required this.maxCredits,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'maxCredits': maxCredits,
      'name': name,
    };
  }
}
