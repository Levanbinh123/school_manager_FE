class StudentModel {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dob;
  final DateTime dateOfJoin;
  final bool selected;
  final String keyId;
  final bool selectAll;

  StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.dateOfJoin,
    required this.selected,
    required this.keyId,
    required this.selectAll,
  });

  String get fullName => '$firstName $lastName';

  factory StudentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return StudentModel(
      id: json['id'] ?? 0,

      firstName:
      json['firstName'] ?? '',

      lastName:
      json['lastName'] ?? '',

      dob: DateTime.parse(
        json['dob'],
      ),

      dateOfJoin: DateTime.parse(
        json['dateOfJoin'],
      ),

      selected:
      json['selected'] ?? false,

      keyId:
      json['keyId'] ?? '',

      selectAll:
      json['selectAll'] ?? false,
    );
  }
}