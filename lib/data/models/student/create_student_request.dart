class CreateStudentRequest {
  final String firstName;
  final String lastName;
  final DateTime dob;
  final DateTime dateOfJoin;
  final String userName;
  final String email;
  final String password;

  CreateStudentRequest({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.dateOfJoin,
    required this.userName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob.toIso8601String(),
      'dateOfJoin':
      dateOfJoin.toIso8601String(),
      'userName': userName,
      'email': email,
      'password': password,
    };
  }
}