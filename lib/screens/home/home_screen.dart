import 'package:flutter/material.dart';
import 'package:school_ma/screens/class/class_screen.dart';
import 'package:school_ma/screens/grade/grade_screen.dart';
import 'package:school_ma/screens/major/major_screen.dart';
import 'package:school_ma/screens/session/session_screen.dart';
import 'package:school_ma/screens/student/student_screen.dart';
import 'package:school_ma/screens/subject/subject_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildHero(context),
            _buildFeatures(),
            _buildAbout(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ==============================
  // HEADER
  // ==============================

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 20,
      ),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(
            Icons.school,
            color: Colors.blue,
            size: 32,
          ),

          const SizedBox(width: 12),

          const Text(
            'SchoolProject',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          TextButton(
            onPressed: () {},
            child: const Text('Trang chủ'),
          ),

          TextButton(
            onPressed: () {},
            child: const Text('Giới thiệu'),
          ),

          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const StudentScreen()));
            },
            child: const Text('Học sinh'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const SubjectScreen()));
            },
            child: const Text('HSubject'),
          ),
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>const MajorScreen()));
          }, child: const Text("Major")),

          TextButton(
            onPressed: () {},
            child: const Text('Giáo viên'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const GradeScreen()));
            },
            child: const Text('Khối'),
          ),

          const SizedBox(width: 20),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const ClassScreen()));
            },
            child: const Text('Lop'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>const SessionScreen()));
            },
            child: const Text('nam hoc'),
          ),

          ElevatedButton(
            onPressed: () {
              // TODO: Navigate Login
            },
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }

  // ==============================
  // HERO
  // ==============================

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 100,
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.school,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 30),

            const Text(
              'School Management System',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Hệ thống quản lý trường học',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Quản lý học sinh, giáo viên, lớp học, '
                  'điểm số và điểm danh trên một nền tảng.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 35),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Login
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 18,
                    ),
                  ),
                  child: const Text(
                    'Đăng nhập hệ thống',
                  ),
                ),

                const SizedBox(width: 15),

                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 18,
                    ),
                  ),
                  child: const Text(
                    'Tìm hiểu thêm',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==============================
  // FEATURES
  // ==============================

  Widget _buildFeatures() {
    final features = [
      (
      Icons.people_outline,
      'Quản lý học sinh',
      'Quản lý thông tin và hồ sơ học sinh.',
      ),
      (
      Icons.person_outline,
      'Quản lý giáo viên',
      'Quản lý giáo viên và phân công giảng dạy.',
      ),
      (
      Icons.class_outlined,
      'Quản lý lớp học',
      'Quản lý lớp, khối và niên khóa.',
      ),
      (
      Icons.menu_book_outlined,
      'Môn học',
      'Quản lý các môn học trong trường.',
      ),
      (
      Icons.assignment_outlined,
      'Điểm số',
      'Theo dõi và quản lý kết quả học tập.',
      ),
      (
      Icons.fact_check_outlined,
      'Điểm danh',
      'Theo dõi tình trạng tham gia học tập.',
      ),
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 70,
      ),
      child: Column(
        children: [
          const Text(
            'Tính năng hệ thống',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 40),

          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: features.map((feature) {
              return _FeatureCard(
                icon: feature.$1,
                title: feature.$2,
                description: feature.$3,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ==============================
  // ABOUT
  // ==============================

  Widget _buildAbout() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 60,
        vertical: 80,
      ),
      child: Column(
        children: [
          const Text(
            'Về hệ thống',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: Text(
              'SchoolProject là hệ thống hỗ trợ nhà trường '
                  'quản lý các hoạt động giáo dục và thông tin '
                  'học sinh một cách tập trung, thuận tiện và hiệu quả.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                height: 1.6,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================
  // FOOTER
  // ==============================

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      color: const Color(0xFF111827),
      child: const Center(
        child: Text(
          '© 2026 SchoolProject. All rights reserved.',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

// ======================================================
// FEATURE CARD
// ======================================================

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 190,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 38,
            color: Colors.blue,
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}