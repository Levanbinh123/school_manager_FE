class EnrollStudentsRequest {
  final int classSessionId;
  final List<int> studentIds;

  EnrollStudentsRequest({
    required this.classSessionId,
    required this.studentIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'classSessionId': classSessionId,
      'studentIds': studentIds,
    };
  }
}