
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewmodels/major/major_cubit.dart';
import '../../viewmodels/major/major_state.dart';
import '../../data/models/major/major_model.dart';
import 'major_form_dialog.dart';

class MajorScreen extends StatefulWidget {
  const MajorScreen({super.key});

  @override
  State<MajorScreen> createState() => _MajorScreenState();
}

class _MajorScreenState extends State<MajorScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MajorCubit>().getAllMajors();
    });
  }

  // =========================
  // ADD / EDIT DIALOG
  // =========================
  Future<void> _showMajorDialog({MajorModel? major}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => MajorFormDialog(major: major),
    );

    if (!mounted || result == null) return;

    final name = result['name'] as String;
    final credits = result['requiredCredits'] as int;

    final cubit = context.read<MajorCubit>();

    if (major == null) {
      await cubit.addMajor(
        name: name,
        requiredCredits: credits,
      );
    } else {
      await cubit.updateMajor(
        id: major.id,
        name: name,
        requiredCredits: credits,
      );
    }
  }
  // =========================
  // DELETE DIALOG
  // =========================
  Future<void> _confirmDelete(MajorModel major) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 40,
          ),
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc muốn xóa ngành "${major.name}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    await context.read<MajorCubit>().deleteMajor(major.id);
  }

  // =========================
  // BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Quản lý ngành học'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<MajorCubit, MajorState>(
            listener: (context, state) {
              if (state is MajorSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              }

              if (state is MajorError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is MajorLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is MajorError) {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Không thể tải dữ liệu ngành học',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          state.message,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<MajorCubit>()
                                .getAllMajors();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final List<MajorModel> majors =
              state is MajorLoaded ? state.majors : [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Danh sách ngành học',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showMajorDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text('Thêm ngành'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Tổng số ngành: ${majors.length}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DATA
                  Expanded(
                    child: majors.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.school_outlined,
                            size: 64,
                            color: Colors.black26,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Chưa có ngành học nào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () =>
                                _showMajorDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text(
                              'Thêm ngành đầu tiên',
                            ),
                          ),
                        ],
                      ),
                    )
                        : Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor:
                            WidgetStateProperty.all(
                              const Color(0xFFEEF3FA),
                            ),
                            columns: const [
                              DataColumn(
                                label: Text('ID'),
                              ),
                              DataColumn(
                                label: Text('Tên ngành'),
                              ),
                              DataColumn(
                                label: Text('Tín chỉ yêu cầu'),
                              ),
                              DataColumn(
                                label: Text('Thao tác'),
                              ),
                            ],
                            rows: majors.map((major) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text('${major.id}'),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 260,
                                      child: Text(
                                        major.name,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${major.requiredCredits}',
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          tooltip: 'Sửa',
                                          onPressed: () {
                                            _showMajorDialog(
                                              major: major,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Xóa',
                                          onPressed: () {
                                            _confirmDelete(major);
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
