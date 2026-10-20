import 'package:flutter/material.dart';

import '../../data/models/class/class_model.dart';

class ClassDetailScreen extends StatelessWidget {
  final ClassModel classModel;

  const ClassDetailScreen({
    super.key,
    required this.classModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết Class'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            _InfoItem(
              title: 'ID',
              value: classModel.id.toString(),
            ),

            _InfoItem(
              title: 'Tên Class',
              value: classModel.name,
            ),

            _InfoItem(
              title: 'Grade ID',
              value:
              classModel.gradeId?.toString() ??
                  'Không có',
            ),

            _InfoItem(
              title: 'Grade',
              value:
              classModel.gradeName ??
                  'Không có',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}