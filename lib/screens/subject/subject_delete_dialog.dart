
import 'package:flutter/material.dart';
import 'package:school_ma/data/models/subject/subject.dart';

class SubjectDeleteDialog extends StatelessWidget {
  final Subject subject;

  const SubjectDeleteDialog({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận xóa'),
      content: Text(
        'Bạn có chắc muốn xóa môn học "${subject.name}" không?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Xóa'),
        ),
      ],
    );
  }
}
