class GradeModel {
  final int id;
  final String name;

  const GradeModel({
    required this.id,
    required this.name,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    print('========== GRADE JSON ==========');
    print(json);
    print('id = ${json['id']}');
    print('Id = ${json['Id']}');
    print('gradeId = ${json['gradeId']}');
    print('GradeId = ${json['GradeId']}');
    print('================================');

    return GradeModel(
      id: _parseInt(
        json['id'] ??
            json['Id'] ??
            json['gradeId'] ??
            json['GradeId'],
      ) ?? 0,

      name: json['name']?.toString() ??
          json['Name']?.toString() ??
          '',
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  @override
  String toString() {
    return 'GradeModel(id: $id, name: $name)';
  }
}