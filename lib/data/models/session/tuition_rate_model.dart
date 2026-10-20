
class TuitionRateModel {
  final int id;
  final int sessionId;
  final double pricePerCredit;
  final Map<String, dynamic>? session;

  const TuitionRateModel({
    required this.id,
    required this.sessionId,
    required this.pricePerCredit,
    this.session,
  });

  factory TuitionRateModel.fromJson(Map<String, dynamic> json) {
    return TuitionRateModel(
      id: (json['id'] as num).toInt(),
      sessionId: (json['sessionId'] as num).toInt(),
      pricePerCredit:
      (json['pricePerCredit'] as num).toDouble(),
      session: json['session'] is Map
          ? Map<String, dynamic>.from(json['session'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'pricePerCredit': pricePerCredit,
    };
  }
}
