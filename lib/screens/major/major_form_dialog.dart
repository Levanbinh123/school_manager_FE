
import 'package:flutter/material.dart';

import '../../data/models/major/major_model.dart';

class MajorFormDialog extends StatefulWidget {
  final MajorModel? major;

  const MajorFormDialog({
    super.key,
    this.major,
  });

  @override
  State<MajorFormDialog> createState() => _MajorFormDialogState();
}

class _MajorFormDialogState extends State<MajorFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _creditsController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.major?.name ?? '',
    );

    _creditsController = TextEditingController(
      text: (widget.major?.requiredCredits ?? 120).toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final credits = int.tryParse(_creditsController.text.trim());

    if (credits == null) return;

    Navigator.of(context).pop(<String, dynamic>{
      'name': _nameController.text.trim(),
      'requiredCredits': credits,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.major == null
            ? 'Thêm ngành học'
            : 'Cập nhật ngành học',
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Tên ngành',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tên ngành';
                    }

                    if (value.trim().length > 150) {
                      return 'Tên ngành không được quá 150 ký tự';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _creditsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số tín chỉ yêu cầu',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final credits = int.tryParse(value ?? '');

                    if (credits == null ||
                        credits < 1 ||
                        credits > 300) {
                      return 'Nhập số tín chỉ từ 1 đến 300';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Lưu'),
        ),
      ],
    );
  }
}
