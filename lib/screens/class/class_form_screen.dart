import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/class/class_model.dart';
import '../../data/models/class/create_class_request.dart';

import '../../viewmodels/class/class_cubit.dart';
import '../../viewmodels/class/class_state.dart';

import '../../viewmodels/grade/grade_cubit.dart';
import '../../viewmodels/grade/grade_state.dart';

class ClassFormScreen extends StatefulWidget {
  final ClassModel? classModel;

  const ClassFormScreen({
    super.key,
    this.classModel,
  });

  bool get isEdit => classModel != null;

  @override
  State<ClassFormScreen> createState() =>
      _ClassFormScreenState();
}

class _ClassFormScreenState
    extends State<ClassFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;

  int? _selectedGradeId;

  @override
  void initState() {
    super.initState();

    // ==========================================
    // CLASS NAME
    // ==========================================

    _nameController = TextEditingController(
      text: widget.classModel?.name ?? '',
    );

    // ==========================================
    // GRADE ID
    // ==========================================

    _selectedGradeId =
        widget.classModel?.gradeId;

    // ==========================================
    // DEBUG
    // ==========================================

    debugPrint(
      '========================================',
    );

    debugPrint(
      'EDIT CLASS: ${widget.classModel?.name}',
    );

    debugPrint(
      'CLASS ID: ${widget.classModel?.id}',
    );

    debugPrint(
      'GRADE ID: ${widget.classModel?.gradeId}',
    );

    debugPrint(
      'GRADE NAME: ${widget.classModel?.gradeName}',
    );

    debugPrint(
      '========================================',
    );

    // ==========================================
    // LOAD GRADE
    // ==========================================

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (!mounted) {
          return;
        }

        context
            .read<GradeCubit>()
            .getAllGrades();
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  // ==========================================================
  // SUBMIT
  // ==========================================================

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGradeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng chọn Grade',
          ),
        ),
      );

      return;
    }

    final name =
    _nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    final request = CreateClassRequest(
      name: name,
      gradeId: _selectedGradeId!,
    );

    // ==========================================
    // UPDATE
    // ==========================================

    if (widget.isEdit) {
      context.read<ClassCubit>().updateClass(
        widget.classModel!.id,
        request,
      );

      return;
    }

    // ==========================================
    // CREATE
    // ==========================================

    context.read<ClassCubit>().addClass(
      request,
    );
  }

  // ==========================================================
  // BUILD GRADE DROPDOWN
  // ==========================================================

  Widget _buildGradeDropdown(
      GradeLoaded state,
      ) {
    // ========================================================
    // LẤY GRADE
    // ========================================================

    final allGrades = state.grades;

    // ========================================================
    // DEBUG
    // ========================================================

    debugPrint(
      '========================================',
    );

    debugPrint(
      'TOTAL GRADES: ${allGrades.length}',
    );

    debugPrint(
      'SELECTED GRADE ID: $_selectedGradeId',
    );

    debugPrint(
      'GRADE IDS: ${allGrades.map((e) => e.id).toList()}',
    );

    debugPrint(
      '========================================',
    );

    // ========================================================
    // LOẠI GRADE TRÙNG ID
    // ========================================================

    final Map<int, dynamic> uniqueMap = {};

    for (final grade in allGrades) {
      uniqueMap[grade.id] = grade;
    }

    final grades = uniqueMap.values.toList();

    // ========================================================
    // KIỂM TRA SELECTED ID
    // ========================================================

    final selectedExists = grades.any(
          (grade) =>
      grade.id == _selectedGradeId,
    );

    final int? validGradeId =
    selectedExists
        ? _selectedGradeId
        : null;

    // ========================================================
    // DEBUG SAU KHI FILTER
    // ========================================================

    debugPrint(
      'UNIQUE GRADE IDS: '
          '${grades.map((e) => e.id).toList()}',
    );

    debugPrint(
      'VALID GRADE ID: $validGradeId',
    );

    // ========================================================
    // KHÔNG CÓ GRADE
    // ========================================================

    if (grades.isEmpty) {
      return const Text(
        'Không có Grade',
        style: TextStyle(
          color: Colors.red,
        ),
      );
    }

    // ========================================================
    // DROPDOWN
    // ========================================================

    return DropdownButtonFormField<int>(
      value: validGradeId,

      isExpanded: true,

      decoration: const InputDecoration(
        labelText: 'Grade',
        hintText: 'Chọn Grade',
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.school,
        ),
      ),

      // ======================================================
      // ITEMS
      // ======================================================

      items: grades.map(
            (grade) {
          return DropdownMenuItem<int>(
            value: grade.id,

            child: Text(
              grade.name,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ).toList(),

      // ======================================================
      // CHANGE
      // ======================================================

      onChanged: (value) {
        setState(() {
          _selectedGradeId = value;
        });
      },

      // ======================================================
      // VALIDATE
      // ======================================================

      validator: (value) {
        if (value == null) {
          return 'Vui lòng chọn Grade';
        }

        return null;
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit
              ? 'Chỉnh sửa Class'
              : 'Thêm Class',
        ),
      ),

      body: BlocListener<ClassCubit, ClassState>(
        listener: (context, state) {
          // ==================================================
          // SUCCESS
          // ==================================================

          if (state is ClassSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );

            Navigator.pop(
              context,
              true,
            );
          }

          // ==================================================
          // ERROR
          // ==================================================

          if (state is ClassError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

        child: BlocBuilder<ClassCubit, ClassState>(
          builder: (context, classState) {
            final isLoading =
            classState is ClassLoading;

            return BlocBuilder<GradeCubit, GradeState>(
              builder: (context, gradeState) {
                return AbsorbPointer(
                  absorbing: isLoading,

                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(
                      20,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,

                        children: [
                          // ==================================================
                          // CLASS NAME
                          // ==================================================

                          TextFormField(
                            controller:
                            _nameController,

                            textInputAction:
                            TextInputAction.next,

                            decoration:
                            const InputDecoration(
                              labelText:
                              'Tên Class',

                              hintText:
                              'Ví dụ: 10A1',

                              border:
                              OutlineInputBorder(),

                              prefixIcon:
                              Icon(
                                Icons.class_,
                              ),
                            ),

                            validator: (value) {
                              if (value == null ||
                                  value
                                      .trim()
                                      .isEmpty) {
                                return 'Vui lòng nhập tên Class';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // ==================================================
                          // GRADE
                          // ==================================================

                          if (gradeState
                          is GradeLoading)
                            const Center(
                              child:
                              CircularProgressIndicator(),
                            )

                          else if (gradeState
                          is GradeLoaded)
                            _buildGradeDropdown(
                              gradeState,
                            )

                          else if (gradeState
                            is GradeError)
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .stretch,

                                children: [
                                  Text(
                                    gradeState.message,

                                    style:
                                    const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  OutlinedButton(
                                    onPressed: () {
                                      context
                                          .read<
                                          GradeCubit>()
                                          .getAllGrades();
                                    },

                                    child:
                                    const Text(
                                      'Tải lại Grade',
                                    ),
                                  ),
                                ],
                              )

                            else
                              const Text(
                                'Chưa tải được danh sách Grade',
                              ),

                          const SizedBox(
                            height: 30,
                          ),

                          // ==================================================
                          // SUBMIT BUTTON
                          // ==================================================

                          SizedBox(
                            height: 50,

                            child:
                            ElevatedButton(
                              onPressed:
                              isLoading
                                  ? null
                                  : _submit,

                              child: isLoading
                                  ? const SizedBox(
                                width: 22,
                                height: 22,

                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )

                                  : Text(
                                widget.isEdit
                                    ? 'Cập nhật'
                                    : 'Thêm Class',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}