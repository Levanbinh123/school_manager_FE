import 'package:flutter/material.dart';

import '../../data/models/grade/grade_model.dart';

class GradeDetailScreen
    extends StatelessWidget {

  final GradeModel grade;

  const GradeDetailScreen({
    super.key,
    required this.grade,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết khối',
        ),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              'Thông tin khối',
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            Card(
              child: Padding(
                padding:
                const EdgeInsets.all(
                  16,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      'ID: ${grade.id}',
                      style:
                      const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Text(
                      'Tên khối: ${grade.name}',
                      style:
                      const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}