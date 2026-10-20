import 'package:flutter/material.dart';

import '../../data/models/student/student_model.dart';

class StudentDetailScreen extends StatelessWidget {
  final StudentModel student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _buildInfo(
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Thông tin học sinh',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Center(
          child: Container(
            width: 700,
            padding: const EdgeInsets.all(28),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(16),
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(
                  'Thông tin cá nhân',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                _buildInfo(
                  'ID',
                  student.id.toString(),
                ),

                _buildInfo(
                  'Họ và tên',
                  student.fullName,
                ),

                _buildInfo(
                  'Ngày sinh',
                  _formatDate(student.dob),
                ),

                _buildInfo(
                  'Ngày vào học',
                  _formatDate(
                    student.dateOfJoin,
                  ),
                ),

                _buildInfo(
                  'Key ID',
                  student.keyId,
                ),

                const SizedBox(height: 20),

                Align(
                  alignment:
                  Alignment.centerRight,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back,
                    ),

                    label: const Text(
                      'Quay lại',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}