import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../services/schedule_bloc.dart';
import '../../services/schedule_event.dart';
import '../../services/schedule_state.dart';
import '../../models/schedule_model.dart';
import '../../components/custom_snackbar.dart';

class EditScheduleView extends StatefulWidget {
  final ScheduleModel schedule;

  const EditScheduleView({super.key, required this.schedule});

  @override
  State<EditScheduleView> createState() => _EditScheduleViewState();
}

class _EditScheduleViewState extends State<EditScheduleView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _taskNameController;
  late final TextEditingController _notesController;

  late String _selectedPriority;
  late DateTime _selectedDateTime;
  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.schedule.taskName);
    _notesController = TextEditingController(text: widget.schedule.notes);
    _selectedPriority = widget.schedule.priority;
    _selectedDateTime = widget.schedule.deadline;
  }

  @override
  void dispose() {
    _taskNameController.dispose();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
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
      setState(() {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
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
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text(
            'Delete Schedule',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: AppColors.palePurple50,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this schedule task?',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.palePurple300,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.palePurple400,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isDeleting = true;
                });
                context.read<ScheduleBloc>().add(
                      ScheduleDeleteRequested(id: widget.schedule.id),
                    );
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFFFFA4A4),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriorityButton(String label, String value, Color activeColor) {
    final bool isSelected = _selectedPriority == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPriority = value;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : AppColors.darkPurple400,
            borderRadius: BorderRadius.circular(16.0),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.palePurple400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.palePurple400,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(
          'Pendar',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: AppColors.palePurple50,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: AppColors.palePurple400,
              size: 28.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state is ScheduleOperationSuccess && (_isSaving || _isDeleting)) {
              final bool wasDeleting = _isDeleting;
              setState(() {
                _isSaving = false;
                _isDeleting = false;
              });
              CustomSnackBar.show(
                context,
                message: wasDeleting
                    ? 'Tugas berhasil dihapus!'
                    : 'Tugas berhasil diperbarui!',
                isError: false,
              );
              context.read<ScheduleBloc>().add(ScheduleLoadRequested());
              context.pop();
            } else if (state is ScheduleFailure && (_isSaving || _isDeleting)) {
              setState(() {
                _isSaving = false;
                _isDeleting = false;
              });
              CustomSnackBar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _taskNameController,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.palePurple50,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Give your task a name...',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.palePurple900,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a task name';
                        }
                        return null;
                      },
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PRIORITY',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.palePurple400,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPriorityButton('High', 'high', const Color(0xFFBA1A1A)),
                              _buildPriorityButton('Med', 'medium', const Color(0xFF8B8000)),
                              _buildPriorityButton('Low', 'low', const Color(0xFF1B8500)),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          const Divider(color: AppColors.darkPurple400, height: 1.0),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'DATE',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.palePurple400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16.0,
                                      color: AppColors.palePurple400,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      _formatDate(_selectedDateTime),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14.0,
                                        color: AppColors.palePurple50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          const Divider(color: AppColors.darkPurple400, height: 1.0),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'TIME',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.palePurple400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _selectTime(context),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                      size: 16.0,
                                      color: AppColors.palePurple400,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      _formatTime(_selectedDateTime),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14.0,
                                        color: AppColors.palePurple50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28.0),
                    const Text(
                      'NOTES',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.palePurple400,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: AppColors.darkPurple600,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        controller: _notesController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.0,
                          color: AppColors.palePurple50,
                          height: 1.5,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter note description...',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            color: AppColors.palePurple900,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    SizedBox(
                      width: double.infinity,
                      height: 52.0,
                      child: ElevatedButton(
                        onPressed: state is ScheduleLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isSaving = true;
                                  });
                                  context.read<ScheduleBloc>().add(
                                        ScheduleUpdateRequested(
                                          id: widget.schedule.id,
                                          taskName: _taskNameController.text.trim(),
                                          priority: _selectedPriority,
                                          deadline: _selectedDateTime,
                                          notes: _notesController.text.trim(),
                                          isCompleted: widget.schedule.isCompleted,
                                        ),
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary,
                          foregroundColor: AppColors.neutral900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26.0),
                          ),
                          elevation: 0.0,
                        ),
                        child: state is ScheduleLoading && _isSaving
                            ? const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutral900),
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: TextButton.icon(
                        onPressed: _isDeleting ? null : _showDeleteConfirmation,
                        icon: SvgPicture.asset(
                          'assets/icon/Icondelete.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFFA4A4),
                            BlendMode.srcIn,
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        label: const Text(
                          'Delete Schedule',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA4A4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
