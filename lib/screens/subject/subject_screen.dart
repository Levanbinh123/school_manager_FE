
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_ma/data/models/subject/subject.dart';
import 'package:school_ma/data/models/subject/subject_viewmodel.dart';
import 'package:school_ma/screens/subject/subject_delete_dialog.dart';
import 'package:school_ma/screens/subject/subject_empty_view.dart';
import 'package:school_ma/screens/subject/subject_form_dialog.dart';
import 'package:school_ma/screens/subject/subject_item_card.dart';
import 'package:school_ma/screens/subject/subject_summary_card.dart';
import 'package:school_ma/viewmodels/subject/subject_cubit.dart';
import 'package:school_ma/viewmodels/subject/subject_state.dart';


class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Quản lý môn học'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<SubjectCubit>().loadSubjects(),
          ),
        ],
      ),
      body: BlocConsumer<SubjectCubit, SubjectState>(
        listener: (context, state) {
          if (state is SubjectSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is SubjectError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SubjectLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Subject> subjects = [];

          if (state is SubjectLoaded) {
            subjects = state.subjects;
          } else if (state is SubjectSuccess) {
            subjects = state.subjects;
          } else if (state is SubjectInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SubjectError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context
                          .read<SubjectCubit>()
                          .loadSubjects(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (subjects.isEmpty) {
            return const SubjectEmptyView();
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SubjectSummaryCard(total: subjects.length),
              const SizedBox(height: 20),
              ...subjects.map(
                    (subject) => SubjectItemCard(
                  subject: subject,
                  onEdit: () => _editSubject(context, subject),
                  onDelete: () => _deleteSubject(context, subject),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addSubject(context),
        icon: const Icon(Icons.add),
        label: const Text('Thêm môn học'),
      ),
    );
  }

  Future<void> _addSubject(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const SubjectFormDialog(),
    );

    if (result == null || !context.mounted) return;

    await context.read<SubjectCubit>().addSubject(
      SubjectViewModel(
        name: result['name'] as String,
        credits: result['credits'] as int,
      ),
    );
  }

  Future<void> _editSubject(
      BuildContext context,
      Subject subject,
      ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => SubjectFormDialog(subject: subject),
    );

    if (result == null || !context.mounted) return;

    await context.read<SubjectCubit>().updateSubject(
      subject.id,
      SubjectViewModel(
        name: result['name'] as String,
        credits: result['credits'] as int,
      ),
    );
  }

  Future<void> _deleteSubject(
      BuildContext context,
      Subject subject,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => SubjectDeleteDialog(subject: subject),
    );

    if (confirmed != true || !context.mounted) return;

    await context.read<SubjectCubit>().deleteSubject(subject.id);
  }
}
