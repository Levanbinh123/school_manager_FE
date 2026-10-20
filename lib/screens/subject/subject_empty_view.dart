
import 'package:flutter/material.dart';

class SubjectEmptyView extends StatelessWidget {
  const SubjectEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'Chưa có môn học nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nhấn "Thêm môn học" để tạo môn học mới.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
