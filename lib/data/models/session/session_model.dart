
class SessionModel {
  final int id;
  final DateTime start;
  final DateTime end;
  final int maxCredits;
  final String name;

  const SessionModel({
    required this.id,
    required this.start,
    required this.end,
    required this.maxCredits,
    required this.name,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    final startValue = json['start'] ?? json['Start'];
    final endValue = json['end'] ?? json['End'];

    if (startValue == null || endValue == null) {
      throw const FormatException(
        'Session thiếu ngày bắt đầu hoặc ngày kết thúc.',
      );
    }

    return SessionModel(
      id: json['id'] ?? json['Id'] ?? 0,
      start: DateTime.parse(startValue.toString()),
      end: DateTime.parse(endValue.toString()),
      maxCredits: json['maxCredits'] ?? json['MaxCredits'] ?? 30,
      name: json['name'] ?? json['Name'] ?? '',
    );
  }
}
