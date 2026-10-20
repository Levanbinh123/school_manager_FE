import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_ma/screens/student/student_detail_screen.dart';
import 'package:school_ma/viewmodels/student/student_cubit.dart';
import 'package:school_ma/viewmodels/student/student_state.dart';

import '../../data/models/student/create_student_request.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({
    super.key,
  });

  @override
  State<StudentScreen> createState() =>
      _StudentScreenState();
}

class _StudentScreenState
    extends State<StudentScreen> {

  final TextEditingController searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<StudentCubit>().getStudents();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // =========================
  // SEARCH
  // =========================

  void searchStudent() {
    final search =
    searchController.text.trim();

    context.read<StudentCubit>().getStudents(
      search: search.isEmpty
          ? null
          : search,
    );
  }

  // =========================
  // DELETE
  // =========================

  void showDeleteDialog(
      BuildContext context,
      int studentId,
      String studentName,
      ) {

    showDialog(
      context: context,
      builder: (dialogContext) {

        return AlertDialog(
          title: const Text(
            'Xóa học sinh',
          ),

          content: Text(
            'Bạn có chắc muốn xóa $studentName?',
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Hủy',
              ),
            ),

            ElevatedButton(
              onPressed: () {

                Navigator.pop(dialogContext);

                context
                    .read<StudentCubit>()
                    .deleteStudent(studentId);
              },

              child: const Text(
                'Xóa',
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // ADD STUDENT
  // =========================

  void showAddStudentDialog() {

    final firstNameController =
    TextEditingController();

    final lastNameController =
    TextEditingController();
    final dobController = TextEditingController();
    final dateOfJoinController = TextEditingController();
    final usernameController =
    TextEditingController();

    final emailController =
    TextEditingController();

    final passwordController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {

        return AlertDialog(
          title: const Text(
            'Thêm học sinh',
          ),

          content: SizedBox(
            width: 450,

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  TextField(
                    controller:
                    firstNameController,

                    decoration:
                    const InputDecoration(
                      labelText: 'Tên',
                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller:
                    lastNameController,

                    decoration:
                    const InputDecoration(
                      labelText: 'Họ',
                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextField(
                    controller: dobController,
                    decoration: const InputDecoration(
                      labelText: 'Ngày sinh',
                      hintText: 'dd/MM/yyyy',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: dateOfJoinController,
                    decoration: const InputDecoration(
                      labelText: 'Ngày vào học',
                      hintText: 'dd/MM/yyyy',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  TextField(
                    controller:
                    usernameController,

                    decoration:
                    const InputDecoration(
                      labelText: 'Username',
                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller:
                    emailController,

                    decoration:
                    const InputDecoration(
                      labelText: 'Email',
                      border:
                      OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller:
                    passwordController,

                    obscureText: true,

                    decoration:
                    const InputDecoration(
                      labelText: 'Password',
                      border:
                      OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Hủy',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final dob = _parseDate(
                  dobController.text.trim(),
                );

                final dateOfJoin = _parseDate(
                  dateOfJoinController.text.trim(),
                );

                if (dob == null || dateOfJoin == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Ngày sinh hoặc ngày vào học không hợp lệ',
                      ),
                    ),
                  );

                  return;
                }

                final request = CreateStudentRequest(
                  firstName: firstNameController.text.trim(),
                  lastName: lastNameController.text.trim(),
                  dob: dob,
                  dateOfJoin: dateOfJoin,
                  userName: usernameController.text.trim(),
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );

                context.read<StudentCubit>().addStudent(
                  request,
                );

                Navigator.pop(dialogContext);
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF5F7FA),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // =========================
            // HEADER
            // =========================

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                const Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      'Quản lý học sinh',

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      'Quản lý thông tin học sinh',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                ElevatedButton.icon(
                  onPressed:
                  showAddStudentDialog,

                  icon: const Icon(
                    Icons.add,
                  ),

                  label: const Text(
                    'Thêm học sinh',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // =========================
            // CONTENT
            // =========================

            Expanded(

              child: BlocConsumer<
                  StudentCubit,
                  StudentState>(
                listener:
                    (context, state) {

                  if (state
                  is StudentSuccess) {

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                        ),
                      ),
                    );

                    context
                        .read<StudentCubit>()
                        .getStudents();
                  }
                  if(state is StudentDetailLoaded){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_)=>StudentDetailScreen(student: state.student)));
                  }

                  if (state
                  is StudentError) {

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                        ),
                      ),
                    );
                  }
                },

                builder:
                    (context, state) {

                  if (state
                  is StudentLoading) {

                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  if (state
                  is StudentError) {

                    return Center(
                      child: Column(
                        mainAxisSize:
                        MainAxisSize.min,

                        children: [

                          const Icon(
                            Icons.error_outline,
                            size: 50,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Text(
                            state.message,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          ElevatedButton(
                            onPressed: () {

                              context
                                  .read<
                                  StudentCubit>()
                                  .getStudents();
                            },

                            child:
                            const Text(
                              'Thử lại',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state
                  is StudentLoaded) {

                    return _buildStudentContent(
                      context,
                      state,
                    );
                  }

                  return const Center(
                    child: Text(
                      'Chưa có dữ liệu',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // STUDENT CONTENT
  // =========================

  Widget _buildStudentContent(
      BuildContext context,
      StudentLoaded state,
      ) {

    return Column(
      children: [

        // =========================
        // SEARCH + TOTAL
        // =========================

        Row(
          children: [

            Expanded(
              child: TextField(

                controller:
                searchController,

                onSubmitted: (_) {
                  searchStudent();
                },

                decoration:
                InputDecoration(

                  hintText:
                  'Tìm kiếm học sinh...',

                  prefixIcon:
                  const Icon(
                    Icons.search,
                  ),

                  suffixIcon:
                  IconButton(
                    onPressed:
                    searchStudent,

                    icon:
                    const Icon(
                      Icons.arrow_forward,
                    ),
                  ),

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 20,
            ),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                BorderRadius.circular(
                  10,
                ),
              ),

              child: Row(
                children: [

                  const Icon(
                    Icons.people,
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Text(
                    'Tổng: ${state.totalStudents}',
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 20,
        ),

        // =========================
        // TABLE
        // =========================

        Expanded(

          child: state.students.isEmpty

              ? const Center(
            child: Text(
              'Không có học sinh',
            ),
          )

              : Container(

            width: double.infinity,

            decoration:
            BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),

            child:
            SingleChildScrollView(

              child: DataTable(

                headingRowColor:
                WidgetStateProperty.all(
                  const Color(
                    0xffF0F2F5,
                  ),
                ),

                columns: const [

                  DataColumn(
                    label: Text(
                      'ID',
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      'Họ và tên',
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      'Ngày sinh',
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      'Ngày vào học',
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      'Key ID',
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      'Thao tác',
                    ),
                  ),
                ],

                rows: state.students
                    .map(
                      (student) {

                    return DataRow(

                      cells: [

                        DataCell(
                          Text(
                            student.id
                                .toString(),
                          ),
                        ),

                        DataCell(
                          Text(
                            student.fullName,
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),

                        DataCell(
                          Text(
                            _formatDate(
                              student.dob,
                            ),
                          ),
                        ),

                        DataCell(
                          Text(
                            _formatDate(
                              student.dateOfJoin,
                            ),
                          ),
                        ),

                        DataCell(
                          Text(
                            student.keyId,
                          ),
                        ),

                        DataCell(

                          Row(
                            children: [

                              IconButton(
                                tooltip:
                                'Xem',

                                onPressed: () async{

                               Navigator.push(context, MaterialPageRoute(builder: (_)=>StudentDetailScreen(student: student))).then((_){
                                 context.read<StudentCubit>().getStudents();
                               });
                                },

                                icon:
                                const Icon(
                                  Icons
                                      .visibility_outlined,
                                ),
                              ),

                              IconButton(
                                tooltip:
                                'Xóa',

                                onPressed: () {

                                  showDeleteDialog(
                                    context,
                                    student.id,
                                    student.fullName,
                                  );
                                },

                                icon:
                                const Icon(
                                  Icons
                                      .delete_outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // DATE
  // =========================

  String _formatDate(
      DateTime date,
      ) {

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
  DateTime? _parseDate(String value) {
    final parts = value.split('/');

    if (parts.length != 3) {
      return null;
    }

    try {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }
}