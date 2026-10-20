
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_ma/data/models/session/tuition_rate_model.dart';
import 'package:school_ma/viewmodels/session/tuition_rate_cubit.dart';
import 'package:school_ma/viewmodels/session/tuition_rate_state.dart';

import '../../data/models/session/create_session_request.dart';
import '../../viewmodels/session/session_cubit.dart';
import '../../viewmodels/session/session_state.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SessionCubit>().getAllSessions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Session'),
        actions: [
          IconButton(
            onPressed: _showAddSessionDialog,
            icon: const Icon(Icons.add),
            tooltip: 'Thêm Session',
          ),
        ],
      ),
      body: BlocConsumer<SessionCubit, SessionState>(
        listener: (context, state) {
          if (state is SessionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }

          if (state is SessionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SessionLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SessionError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<SessionCubit>().getAllSessions();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is SessionLoaded) {
            if (state.sessions.isEmpty) {
              return RefreshIndicator(
                onRefresh: () {
                  return context.read<SessionCubit>().getAllSessions();
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 250),
                    Center(child: Text('Chưa có Session')),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () {
                return context.read<SessionCubit>().getAllSessions();
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.sessions.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final session = state.sessions[index];

                  final sessionName = session.name.isEmpty
                      ? 'Session #${session.id}'
                      : session.name;

                  return Card(
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const CircleAvatar(
                        child: Icon(Icons.calendar_month),
                      ),
                      title: Text(
                        sessionName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Thời gian: '
                              '${_formatSession(session.start, session.end)}\n'
                              'Session ID: ${session.id}\n'
                              'Tối đa: ${session.maxCredits} tín chỉ',
                        ),
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        tooltip: 'Chỉnh học phí',
                        icon: const Icon(
                          Icons.payments_outlined,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          _showTuitionRateDialog(
                            sessionId: session.id,
                            sessionName: sessionName,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(
            child: Text('Đang tải dữ liệu Session...'),
          );
        },
      ),
    );
  }

  // ============================================================
  // THÊM SESSION
  // ============================================================

  Future<void> _showAddSessionDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final maxCreditsController = TextEditingController(text: '30');

    DateTime? startDate;
    DateTime? endDate;
    bool isSaving = false;

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Thêm Session'),
                content: SizedBox(
                  width: 400,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: nameController,
                            enabled: !isSaving,
                            textCapitalization:
                            TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: 'Tên Session',
                              hintText: 'Ví dụ: Học kỳ 1 năm 2026-2027',
                              prefixIcon: Icon(Icons.school),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Vui lòng nhập tên Session';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: maxCreditsController,
                            enabled: !isSaving,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Số tín chỉ tối đa',
                              hintText: 'Ví dụ: 30',
                              prefixIcon: Icon(Icons.credit_score),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              final credits = int.tryParse(
                                value?.trim() ?? '',
                              );

                              if (credits == null || credits <= 0) {
                                return 'Nhập số nguyên lớn hơn 0';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Ngày bắt đầu'),
                            subtitle: Text(
                              startDate == null
                                  ? 'Chưa chọn ngày'
                                  : _formatDate(startDate!),
                            ),
                            trailing: const Icon(Icons.edit_calendar),
                            onTap: isSaving
                                ? null
                                : () async {
                              final date = await showDatePicker(
                                context: dialogContext,
                                initialDate:
                                startDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );

                              if (date != null) {
                                setDialogState(() {
                                  startDate = date;

                                  if (endDate != null &&
                                      endDate!.isBefore(date)) {
                                    endDate = null;
                                  }
                                });
                              }
                            },
                          ),
                          const Divider(),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.event),
                            title: const Text('Ngày kết thúc'),
                            subtitle: Text(
                              endDate == null
                                  ? 'Chưa chọn ngày'
                                  : _formatDate(endDate!),
                            ),
                            trailing: const Icon(Icons.edit_calendar),
                            onTap: isSaving
                                ? null
                                : () async {
                              final date = await showDatePicker(
                                context: dialogContext,
                                initialDate: endDate ??
                                    startDate ??
                                    DateTime.now(),
                                firstDate:
                                startDate ?? DateTime(2020),
                                lastDate: DateTime(2100),
                              );

                              if (date != null) {
                                setDialogState(() {
                                  endDate = date;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () => Navigator.pop(dialogContext),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton.icon(
                    onPressed: isSaving
                        ? null
                        : () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      if (startDate == null || endDate == null) {
                        ScaffoldMessenger.of(this.context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Vui lòng chọn ngày bắt đầu và kết thúc',
                            ),
                          ),
                        );
                        return;
                      }

                      if (endDate!.isBefore(startDate!)) {
                        ScaffoldMessenger.of(this.context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Ngày kết thúc phải sau ngày bắt đầu',
                            ),
                          ),
                        );
                        return;
                      }

                      final request = CreateSessionRequest(
                        name: nameController.text.trim(),
                        maxCredits: int.parse(
                          maxCreditsController.text.trim(),
                        ),
                        start: startDate!,
                        end: endDate!,
                      );

                      setDialogState(() {
                        isSaving = true;
                      });

                      try {
                        final cubit =
                        this.context.read<SessionCubit>();

                        await cubit.addSession(request);

                        if (!dialogContext.mounted) return;

                        final currentState = cubit.state;

                        if (currentState is SessionError) {
                          setDialogState(() {
                            isSaving = false;
                          });
                          return;
                        }

                        if (currentState is SessionLoaded ||
                            currentState is SessionSuccess) {
                          Navigator.pop(dialogContext);
                          return;
                        }

                        setDialogState(() {
                          isSaving = false;
                        });
                      } catch (e) {
                        if (!dialogContext.mounted) return;

                        setDialogState(() {
                          isSaving = false;
                        });

                        ScaffoldMessenger.of(this.context)
                            .showSnackBar(
                          SnackBar(
                            content: Text('Lỗi khi thêm Session: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: isSaving
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.save),
                    label: Text(isSaving ? 'Đang lưu...' : 'Lưu'),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      nameController.dispose();
      maxCreditsController.dispose();
    }
  }

  // ============================================================
  // CHỈNH HỌC PHÍ THEO SESSION
  // ============================================================

  Future<void> _showTuitionRateDialog({
    required int sessionId,
    required String sessionName,
  }) async {
    final cubit = context.read<TuitionRateCubit>();

    // Lấy dữ liệu học phí từ API.
    await cubit.loadRates();

    if (!mounted) return;

    final state = cubit.state;

    if (state is! TuitionRateLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state is TuitionRateError
                ? state.message
                : 'Không tải được dữ liệu học phí.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    TuitionRateModel? existingRate;

    for (final rate in state.rates) {
      if (rate.sessionId == sessionId) {
        existingRate = rate;
        break;
      }
    }

    final priceController = TextEditingController(
      text: existingRate == null
          ? ''
          : existingRate.pricePerCredit.toStringAsFixed(0),
    );

    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(
                  existingRate == null
                      ? 'Thiết lập học phí'
                      : 'Chỉnh học phí',
                ),
                content: SizedBox(
                  width: 400,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.school,
                              color: Colors.green,
                            ),
                            title: Text(sessionName),
                            subtitle: Text('Session ID: $sessionId'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: priceController,
                            enabled: !isSaving,
                            autofocus: true,
                            keyboardType:
                            const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Giá một tín chỉ (VNĐ)',
                              hintText: 'Ví dụ: 500000',
                              prefixIcon: Icon(Icons.payments),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              final price = double.tryParse(
                                (value ?? '').trim(),
                              );

                              if (price == null || price <= 0) {
                                return 'Giá phải lớn hơn 0';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Text(
                            existingRate == null
                                ? 'Session này chưa có mức học phí.'
                                : 'Giá hiện tại: '
                                '${_formatMoney(existingRate.pricePerCredit)} VNĐ/tín chỉ',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () => Navigator.pop(dialogContext),
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton.icon(
                    onPressed: isSaving
                        ? null
                        : () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      final price = double.parse(
                        priceController.text.trim(),
                      );

                      setDialogState(() {
                        isSaving = true;
                      });

                      try {
                        if (existingRate == null) {
                          await cubit.createRate(
                            sessionId: sessionId,
                            pricePerCredit: price,
                          );
                        } else {
                          await cubit.updateRate(
                            id: existingRate!.id,
                            pricePerCredit: price,
                          );
                        }

                        if (!dialogContext.mounted) return;

                        final result = cubit.state;

                        if (result is TuitionRateError) {
                          setDialogState(() {
                            isSaving = false;
                          });

                          ScaffoldMessenger.of(this.context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(result.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (result is! TuitionRateLoaded) {
                          setDialogState(() {
                            isSaving = false;
                          });

                          ScaffoldMessenger.of(this.context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Chưa xác nhận được kết quả lưu học phí.',
                              ),
                            ),
                          );
                          return;
                        }

                        Navigator.pop(dialogContext);

                        ScaffoldMessenger.of(this.context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              existingRate == null
                                  ? 'Thiết lập học phí thành công.'
                                  : 'Cập nhật học phí thành công.',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        if (!dialogContext.mounted) return;

                        setDialogState(() {
                          isSaving = false;
                        });

                        ScaffoldMessenger.of(this.context)
                            .showSnackBar(
                          SnackBar(
                            content: Text('Lỗi: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: isSaving
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.save),
                    label: Text(
                      isSaving ? 'Đang lưu...' : 'Lưu học phí',
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      priceController.dispose();
    }
  }

  // ============================================================
  // FORMAT NGÀY VÀ TIỀN
  // ============================================================

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatSession(DateTime start, DateTime end) {
    return '${_formatDate(start)} → ${_formatDate(end)}';
  }

  String _formatMoney(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    );
  }
}
