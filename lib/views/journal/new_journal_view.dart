import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../services/journal_bloc.dart';
import '../../services/journal_event.dart';
import '../../services/journal_state.dart';
import '../../components/custom_snackbar.dart';

class NewJournalView extends StatefulWidget {
  const NewJournalView({super.key});

  @override
  State<NewJournalView> createState() => _NewJournalViewState();
}

class _NewJournalViewState extends State<NewJournalView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _selectedMood = 3;
  bool _isSaving = false;
  String? _draftId;
  String _saveStatus = '';
  Timer? _debounceTimer;

  final List<String> _moodEmojis = const ['😞', '🙁', '😐', '🙂', '😄'];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onInputChanged);
    _contentController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      setState(() {
        _saveStatus = '';
      });
      return;
    }
    setState(() {
      _saveStatus = 'Saving...';
    });
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
      _triggerAutoSave();
    });
  }

  void _triggerAutoSave() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) {
      setState(() {
        _saveStatus = '';
      });
      return;
    }
    context.read<JournalBloc>().add(
          JournalAutoSaveRequested(
            id: _draftId,
            title: title.isEmpty ? 'Untitled' : title,
            content: content,
            mood: _selectedMood,
          ),
        );
  }

  String _getLongDate() {
    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final now = DateTime.now();
    return '${days[now.weekday % 7]}, ${months[now.month - 1]} ${now.day}, ${now.year}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.palePurple400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leadingWidth: 80.0,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'New Journal',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AppColors.palePurple50,
              ),
            ),
            if (_saveStatus.isNotEmpty)
              Text(
                _saveStatus,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10.0,
                  color: AppColors.palePurple400,
                ),
              ),
          ],
        ),
        centerTitle: true,
        actions: [
          BlocConsumer<JournalBloc, JournalState>(
            listener: (context, state) {
              if (state is JournalOperationSuccess && _isSaving) {
                setState(() {
                  _isSaving = false;
                });
                CustomSnackBar.show(
                  context,
                  message: 'Jurnal berhasil disimpan!',
                  isError: false,
                );
                context.read<JournalBloc>().add(JournalLoadRequested());
                context.pop();
              } else if (state is JournalFailure && _isSaving) {
                setState(() {
                  _isSaving = false;
                });
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              } else if (state is JournalAutoSaveSuccess) {
                setState(() {
                  _draftId = state.id;
                  _saveStatus = 'Saved to cloud';
                });
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is JournalLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _debounceTimer?.cancel();
                          setState(() {
                            _isSaving = true;
                          });
                          if (_draftId != null) {
                            context.read<JournalBloc>().add(
                                  JournalUpdateRequested(
                                    id: _draftId!,
                                    title: _titleController.text.trim(),
                                    content: _contentController.text.trim(),
                                    mood: _selectedMood,
                                  ),
                                );
                          } else {
                            context.read<JournalBloc>().add(
                                  JournalAddRequested(
                                    title: _titleController.text.trim(),
                                    content: _contentController.text.trim(),
                                    mood: _selectedMood,
                                  ),
                                );
                          }
                        }
                      },
                child: state is JournalLoading && _isSaving
                    ? const SizedBox(
                        height: 16.0,
                        width: 16.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getLongDate(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.palePurple400,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.palePurple50,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Give your entry a title...',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.palePurple700,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'How are you feeling?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.palePurple400,
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final bool isSelected = _selectedMood == index + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMood = index + 1;
                        });
                        _onInputChanged();
                      },
                      child: Container(
                        width: 52.0,
                        height: 52.0,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.darkPurple600,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _moodEmojis[index],
                          style: const TextStyle(fontSize: 24.0),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: AppColors.palePurple300,
                    height: 1.5,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Write down your thoughts, worries, or wins today...',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      color: AppColors.palePurple700,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please write down some thoughts';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
