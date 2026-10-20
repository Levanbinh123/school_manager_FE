class ApiConstants {
  static const String baseUrl =
      'https://localhost:7265/api';

  static const String login =

      '$baseUrl/auth/login';


  static const String logout =
      '$baseUrl/auth/logout';


  static const String students =
      '$baseUrl/Students';

  static const String studentCount =
      '$baseUrl/Students/count';

  static const String enrollStudents =
      '$baseUrl/Students/enroll-students';
  //grade
  static const String grades =
      '$baseUrl/Grades';
  //class
  static const String classes = '$baseUrl/admin/Class';
  //session
//class
  static const String sessions = '$baseUrl/admin/SessionApi';
  // Endpoint học phí.
  static const String tuitionRates =
      '$baseUrl/admin/tuition-rates';
  static const String majors = '$baseUrl/admin/majors';

  // Quản lý môn học
  static const String subjects = '$baseUrl/admin/Subjects';

  // Gán môn học vào ngành
  static const String majorSubjects = '$baseUrl/admin/major-subjects';
}