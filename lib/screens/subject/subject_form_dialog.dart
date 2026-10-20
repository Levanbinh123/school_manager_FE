
import 'package:flutter/material.dart';
import 'package:school_ma/data/models/subject/subject.dart';


class SubjectFormDialog extends StatefulWidget {
  final Subject? subject;

  const SubjectFormDialog({
    super.key,
    this.subject,
  });

  @override
  State<SubjectFormDialog> createState() =>
      _SubjectFormDialogState();
}

class _SubjectFormDialogState extends State<SubjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _creditsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.subject?.name ?? '',
    );
    _creditsController = TextEditingController(
      text: widget.subject?.credits.toString() ?? '3',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subject != null;

    return AlertDialog(
      title: Text(
        isEditing ? 'Cập nhật môn học' : 'Thêm môn học',
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Tên môn học',
                  hintText: 'Ví dụ: Lập trình C#',
                  prefixIcon: Icon(Icons.menu_book),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên môn học.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tín chỉ',
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final credits = int.tryParse(value ?? '');
                  if (credits == null ||
                      credits < 1 ||
                      credits > 10) {
                    return 'Tín chỉ phải từ 1 đến 10.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;

            Navigator.pop(
              context,
              <String, dynamic>{
                'name': _nameController.text.trim(),
                'credits': int.parse(
                  _creditsController.text.trim(),
                ),
              },
            );
          },
          child: Text(isEditing ? 'Lưu' : 'Thêm'),
        ),
      ],
    );
  }
}
