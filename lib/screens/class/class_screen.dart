import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/class/class_model.dart';

import '../../viewmodels/class/class_cubit.dart';
import '../../viewmodels/class/class_state.dart';
import 'class_detail_screen.dart';
import 'class_form_screen.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({
    super.key,
  });

  @override
  State<ClassScreen> createState() =>
      _ClassScreenState();
}

class _ClassScreenState
    extends State<ClassScreen> {
  @override
  void initState() {
    super.initState();

    context
        .read<ClassCubit>()
        .getAllClasses();
  }

  // =========================
  // ADD
  // =========================

  Future<void> _addClass() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const ClassFormScreen(),
      ),
    );

    if (!mounted) return;

    context
        .read<ClassCubit>()
        .getAllClasses();
  }

  // =========================
  // DETAIL
  // =========================

  void _openDetail(
      ClassModel classModel,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ClassDetailScreen(
              classModel: classModel,
            ),
      ),
    );
  }

  // =========================
  // EDIT
  // =========================

  Future<void> _editClass(
      ClassModel classModel,
      ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ClassFormScreen(
              classModel: classModel,
            ),
      ),
    );

    if (!mounted) return;

    context
        .read<ClassCubit>()
        .getAllClasses();
  }

  // =========================
  // DELETE
  // =========================

  Future<void> _deleteClass(
      ClassModel classModel,
      ) async {
    final result =
    await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Xóa Class',
          ),

          content: Text(
            'Bạn có chắc muốn xóa "${classModel.name}" không?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Hủy',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },

              child: const Text(
                'Xóa',
              ),
            ),
          ],
        );
      },
    );

    if (result != true) {
      return;
    }

    if (!mounted) return;

    context
        .read<ClassCubit>()
        .deleteClass(
      classModel.id,
    );
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Class',
        ),

        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<ClassCubit>()
                  .getAllClasses();
            },

            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: BlocListener<ClassCubit, ClassState>(
        listener: (context, state) {
          if (state is ClassError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );
          }
        },

        child: BlocBuilder<ClassCubit, ClassState>(
          builder: (context, state) {
            // =========================
            // LOADING
            // =========================

            if (state is ClassLoading) {
              return const Center(
                child:
                CircularProgressIndicator(),
              );
            }

            // =========================
            // ERROR
            // =========================

            if (state is ClassError) {
              return Center(
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,

                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      state.message,
                      textAlign:
                      TextAlign.center,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ClassCubit>()
                            .getAllClasses();
                      },

                      child: const Text(
                        'Thử lại',
                      ),
                    ),
                  ],
                ),
              );
            }

            // =========================
            // DATA
            // =========================

            if (state is ClassLoaded) {
              if (state.classes.isEmpty) {
                return const Center(
                  child: Text(
                    'Chưa có Class',
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () {
                  return context
                      .read<ClassCubit>()
                      .getAllClasses();
                },

                child: ListView.builder(
                  padding:
                  const EdgeInsets.all(16),

                  itemCount:
                  state.classes.length,

                  itemBuilder:
                      (context, index) {
                    final classModel =
                    state.classes[index];

                    return _ClassCard(
                      classModel:
                      classModel,

                      onTap: () {
                        _openDetail(
                          classModel,
                        );
                      },

                      onEdit: () {
                        _editClass(
                          classModel,
                        );
                      },

                      onDelete: () {
                        _deleteClass(
                          classModel,
                        );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: _addClass,

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          'Thêm Class',
        ),
      ),
    );
  }
}

// =====================================================
// CLASS CARD
// =====================================================

class _ClassCard extends StatelessWidget {
  final ClassModel classModel;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClassCard({
    required this.classModel,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          child: Text(
            classModel.name.isNotEmpty
                ? classModel.name[0]
                : '?',
          ),
        ),

        title: Text(
          classModel.name,

          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Text(
          classModel.gradeName ??
              'Chưa có Grade',
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            }

            if (value == 'delete') {
              onDelete();
            }
          },

          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                    ),

                    SizedBox(
                      width: 10,
                    ),

                    Text(
                      'Chỉnh sửa',
                    ),
                  ],
                ),
              ),

              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                    ),

                    SizedBox(
                      width: 10,
                    ),

                    Text(
                      'Xóa',
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}