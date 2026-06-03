import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';
import '../../services/schedule_bloc.dart';
import '../../services/schedule_event.dart';
import '../../services/schedule_state.dart';
import '../../components/custom_snackbar.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPriority = 'high';
  DateTime? _selectedDateTime;
  bool _isAdding = false;

  @override
  void dispose() {
    _taskNameController.dispose();
    _deadlineController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime dateTime) {
    final int hour = dateTime.hour;
    final int minute = dateTime.minute;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final int displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final String displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.secondary,
              onSurface: AppColors.palePurple50,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                surface: AppColors.secondary,
                onSurface: AppColors.palePurple50,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _deadlineController.text =
              '${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.year.toString().substring(2)} - ${_formatTime(_selectedDateTime!)}';
        });
      }
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFBA1A1A);
      case 'medium':
        return const Color(0xFF8B8000);
      case 'low':
        return const Color(0xFF1B8500);
      default:
        return const Color(0xFF1B8500);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: SafeArea(
        child: BlocListener<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state is ScheduleOperationSuccess && _isAdding) {
              setState(() {
                _isAdding = false;
                _taskNameController.clear();
                _deadlineController.clear();
                _notesController.clear();
                _selectedPriority = 'high';
                _selectedDateTime = null;
              });
              CustomSnackBar.show(
                context,
                message: 'Tugas berhasil ditambahkan!',
                isError: false,
              );
              context.read<ScheduleBloc>().add(ScheduleLoadRequested());
            } else if (state is ScheduleFailure && _isAdding) {
              setState(() {
                _isAdding = false;
              });
              CustomSnackBar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<ScheduleBloc>().add(ScheduleLoadRequested());
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/icon/pendaricon.png',
                        width: 32.0,
                        height: 32.0,
                      ),
                      const Text(
                        'Pendar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.palePurple50,
                        ),
                      ),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.darkPurple600,
                            width: 1.0,
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.person_outline,
                            color: AppColors.palePurple400,
                            size: 20.0,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: AppColors.darkPurple600,
                        width: 1.0,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'New Focus',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.palePurple50,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Task Name',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.palePurple400,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          TextFormField(
                            controller: _taskNameController,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              color: AppColors.palePurple50,
                            ),
                            decoration: InputDecoration(
                              hintText: 'What needs your attention?',
                              hintStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                color: AppColors.palePurple900,
                              ),
                              filled: true,
                              fillColor: AppColors.neutral.withValues(alpha: 0.3),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(color: AppColors.darkPurple400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(color: AppColors.primary),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(color: Colors.redAccent),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(color: Colors.redAccent),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a task name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Priority',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.palePurple400,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    DropdownButtonFormField<String>(
                                      initialValue: _selectedPriority,
                                      dropdownColor: AppColors.secondary,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14.0,
                                        color: AppColors.palePurple50,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColors.neutral.withValues(alpha: 0.3),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                          borderSide: const BorderSide(color: AppColors.darkPurple400),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                          borderSide: const BorderSide(color: AppColors.primary),
                                        ),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'high',
                                          child: Text('High'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'medium',
                                          child: Text('Medium'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'low',
                                          child: Text('Low'),
                                        ),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _selectedPriority = val;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Deadline',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.palePurple400,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    TextFormField(
                                      controller: _deadlineController,
                                      readOnly: true,
                                      onTap: () => _selectDeadline(context),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14.0,
                                        color: AppColors.palePurple50,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'mm/dd/yy',
                                        hintStyle: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14.0,
                                          color: AppColors.palePurple900,
                                        ),
                                        filled: true,
                                        fillColor: AppColors.neutral.withValues(alpha: 0.3),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                          borderSide: const BorderSide(color: AppColors.darkPurple400),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                          borderSide: const BorderSide(color: AppColors.primary),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                          borderSide: const BorderSide(color: Colors.redAccent),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                          borderSide: const BorderSide(color: Colors.redAccent),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Set deadline';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Notes',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.palePurple400,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 4,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              color: AppColors.palePurple50,
                            ),
                            decoration: InputDecoration(
                              hintText: 'insert notes...',
                              hintStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                color: AppColors.palePurple900,
                              ),
                              filled: true,
                              fillColor: AppColors.neutral.withValues(alpha: 0.3),
                              contentPadding: const EdgeInsets.all(16.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(color: AppColors.darkPurple400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: const BorderSide(color: AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            height: 52.0,
                            child: ElevatedButton(
                              onPressed: _isAdding
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isAdding = true;
                                        });
                                        context.read<ScheduleBloc>().add(
                                              ScheduleAddRequested(
                                                taskName: _taskNameController.text.trim(),
                                                priority: _selectedPriority,
                                                deadline: _selectedDateTime!,
                                                notes: _notesController.text.trim(),
                                              ),
                                            );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.purple100,
                                foregroundColor: AppColors.neutral900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26.0),
                                ),
                                elevation: 0.0,
                              ),
                              child: _isAdding
                                  ? const SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutral900),
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add, size: 20.0),
                                        SizedBox(width: 8.0),
                                        Text(
                                          'Add a Task',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    children: [
                      Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.palePurple50,
                            width: 2.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      const Text(
                        "Today's Journey",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.palePurple50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  BlocBuilder<ScheduleBloc, ScheduleState>(
                    builder: (context, state) {
                      if (state is ScheduleLoading && !_isAdding) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }
                      if (state is ScheduleFailure) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Column(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.redAccent, size: 40.0),
                                const SizedBox(height: 12.0),
                                Text(
                                  state.message,
                                  style: const TextStyle(color: AppColors.palePurple300),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (state is ScheduleLoadSuccess) {
                        if (state.schedules.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: AppColors.darkPurple600,
                                width: 1.0,
                              ),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.playlist_add_check_outlined, size: 48.0, color: AppColors.palePurple900),
                                SizedBox(height: 12.0),
                                Text(
                                  'No schedules for today.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.palePurple50,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Use the Focus card above to plan a task.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12.0,
                                    color: AppColors.palePurple400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = state.schedules[index];
                            return GestureDetector(
                              onTap: () {
                                context.push(AppRoutes.editSchedule, extra: schedule);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: const Color(0xFF2E284F),
                                    width: 1.0,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          width: 4.0,
                                          color: AppColors.primary,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    context.read<ScheduleBloc>().add(
                                                          ScheduleToggleCompleteRequested(
                                                            id: schedule.id,
                                                            isCompleted: !schedule.isCompleted,
                                                          ),
                                                        );
                                                  },
                                                  child: Container(
                                                    width: 22.0,
                                                    height: 22.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: schedule.isCompleted
                                                            ? AppColors.primary
                                                            : AppColors.palePurple400,
                                                        width: 2.0,
                                                      ),
                                                      color: schedule.isCompleted
                                                          ? AppColors.primary
                                                          : Colors.transparent,
                                                    ),
                                                    child: schedule.isCompleted
                                                        ? const Icon(
                                                            Icons.check,
                                                            color: AppColors.neutral900,
                                                            size: 14.0,
                                                          )
                                                        : null,
                                                  ),
                                                ),
                                                const SizedBox(width: 16.0),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              schedule.taskName,
                                                              style: TextStyle(
                                                                fontFamily: 'Poppins',
                                                                fontSize: 18.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: schedule.isCompleted
                                                                    ? AppColors.palePurple300.withValues(alpha: 0.5)
                                                                    : AppColors.palePurple50,
                                                                decoration: schedule.isCompleted
                                                                    ? TextDecoration.lineThrough
                                                                    : null,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8.0),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                                            decoration: BoxDecoration(
                                                              color: _getPriorityColor(schedule.priority),
                                                              borderRadius: BorderRadius.circular(12.0),
                                                            ),
                                                            child: Text(
                                                              schedule.priority[0].toUpperCase() +
                                                                  schedule.priority.substring(1).toLowerCase(),
                                                              style: const TextStyle(
                                                                fontFamily: 'Poppins',
                                                                fontSize: 10.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (schedule.notes.isNotEmpty) ...[
                                                        const SizedBox(height: 8.0),
                                                        Text(
                                                          schedule.notes,
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 14.0,
                                                            color: schedule.isCompleted
                                                                ? AppColors.palePurple900.withValues(alpha: 0.5)
                                                                : AppColors.palePurple400,
                                                            decoration: schedule.isCompleted
                                                                ? TextDecoration.lineThrough
                                                                : null,
                                                            height: 1.4,
                                                          ),
                                                        ),
                                                      ],
                                                      const SizedBox(height: 12.0),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/icon/Iconjam.svg',
                                                            colorFilter: ColorFilter.mode(
                                                              schedule.isCompleted
                                                                  ? AppColors.palePurple900.withValues(alpha: 0.5)
                                                                  : AppColors.palePurple400,
                                                              BlendMode.srcIn,
                                                            ),
                                                            width: 14.0,
                                                            height: 14.0,
                                                          ),
                                                          const SizedBox(width: 6.0),
                                                          Text(
                                                            _formatTime(schedule.deadline),
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 12.0,
                                                              color: schedule.isCompleted
                                                                  ? AppColors.palePurple900.withValues(alpha: 0.5)
                                                                  : AppColors.palePurple400,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 16.0),
                                                          SvgPicture.asset(
                                                            'assets/icon/Icondate.svg',
                                                            colorFilter: ColorFilter.mode(
                                                              schedule.isCompleted
                                                                  ? AppColors.palePurple900.withValues(alpha: 0.5)
                                                                  : AppColors.palePurple400,
                                                              BlendMode.srcIn,
                                                            ),
                                                            width: 14.0,
                                                            height: 14.0,
                                                          ),
                                                          const SizedBox(width: 6.0),
                                                          Text(
                                                            _formatDate(schedule.deadline),
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 12.0,
                                                              color: schedule.isCompleted
                                                                  ? AppColors.palePurple900.withValues(alpha: 0.5)
                                                                  : AppColors.palePurple400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
