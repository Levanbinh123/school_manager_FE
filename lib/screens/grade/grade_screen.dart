import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_ma/viewmodels/grade/grade_cubit.dart';
import 'package:school_ma/viewmodels/grade/grade_state.dart';
import '../../data/models/grade/create_grade_request.dart';
import 'grade_detail_screen.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({
    super.key,
  });

  @override
  State<GradeScreen> createState() =>
      _GradeScreenState();
}

class _GradeScreenState
    extends State<GradeScreen> {

  @override
  void initState() {
    super.initState();

    context.read<GradeCubit>().getGrades();
  }

  // =========================
  // ADD DIALOG
  // =========================

  void _showAddGradeDialog() {
    final controller =
    TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Thêm khối',
          ),

          content: TextField(
            controller: controller,
            decoration:
            const InputDecoration(
              labelText: 'Tên khối',
              hintText: 'Ví dụ: Khối 10',
              border:
              OutlineInputBorder(),
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
                final name =
                controller.text.trim();

                if (name.isEmpty) {
                  return;
                }

                final request =
                CreateGradeRequest(
                  name: name,
                );

                context
                    .read<GradeCubit>()
                    .addGrade(
                  request,
                );

                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Thêm',
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý khối',
        ),
      ),

      floatingActionButton:
      FloatingActionButton(
        onPressed:
        _showAddGradeDialog,
        child: const Icon(
          Icons.add,
        ),
      ),

      body: BlocConsumer<
          GradeCubit,
          GradeState>(
        listener:
            (context, state) {

          // SUCCESS
          if (state
          is GradeSuccess) {
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
                .read<GradeCubit>()
                .getGrades();
          }

          // ERROR
          if (state
          is GradeError) {
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

          // DETAIL
          if (state
          is GradeDetailLoaded) {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    GradeDetailScreen(
                      grade: state.grade,
                    ),
              ),
            ).then((_) {
              context
                  .read<GradeCubit>()
                  .getGrades();
            });
          }
        },

        builder:
            (context, state) {

          // LOADING
          if (state
          is GradeLoading) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          // LOADED
          if (state
          is GradeLoaded) {

            if (state.grades.isEmpty) {
              return const Center(
                child: Text(
                  'Chưa có khối nào',
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<GradeCubit>()
                    .getGrades();
              },

              child: ListView.builder(
                padding:
                const EdgeInsets.all(
                  16,
                ),

                itemCount:
                state.grades.length,

                itemBuilder:
                    (context, index) {

                  final grade =
                  state.grades[index];

                  return Card(
                    margin:
                    const EdgeInsets.only(
                      bottom: 12,
                    ),

                    child: ListTile(
                      leading:
                      CircleAvatar(
                        child: Text(
                          '${grade.id}',
                        ),
                      ),

                      title: Text(
                        grade.name,
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      subtitle:
                      Text(
                        'ID: ${grade.id}',
                      ),

                      trailing:
                      IconButton(
                        icon:
                        const Icon(
                          Icons
                              .visibility_outlined,
                        ),

                        onPressed: () {
                          context
                              .read<
                              GradeCubit>()
                              .getGradeById(
                            grade.id,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }

          // ERROR
          if (state
          is GradeError) {
            return Center(
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [

                  Text(
                    state.message,
                    textAlign:
                    TextAlign.center,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<GradeCubit>()
                          .getGrades();
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

          return const Center(
            child: Text(
              'Chưa có dữ liệu',
            ),
          );
        },
      ),
    );
  }
}