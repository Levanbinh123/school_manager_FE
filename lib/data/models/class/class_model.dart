class ClassModel {
  final int id;
  final String name;
  final int? gradeId;
  final String? gradeName;

  const ClassModel({
    required this.id,
    required this.name,
    this.gradeId,
    this.gradeName,
  });

  factory ClassModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ClassModel(
      id: _parseInt(
        json['id'] ??
            json['Id'],
      ) ??
          0,

      name:
      json['name']?.toString() ??
          json['Name']?.toString() ??
          '',

      gradeId: _parseInt(
        json['gradeId'] ??
            json['GradeId'],
      ),

      gradeName:
      json['gradeName']?.toString() ??
          json['GradeName']?.toString(),
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

    return int.tryParse(
      value.toString(),
    );
  }

  @override
  String toString() {
    return 'ClassModel('
        'id: $id, '
        'name: $name, '
        'gradeId: $gradeId, '
        'gradeName: $gradeName'
        ')';
  }
}