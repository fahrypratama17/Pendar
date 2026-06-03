import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../services/journal_bloc.dart';
import '../../services/journal_event.dart';
import '../../services/journal_state.dart';
import '../../models/journal_model.dart';
import '../../components/custom_snackbar.dart';

class EditJournalView extends StatefulWidget {
  final JournalModel journal;

  const EditJournalView({super.key, required this.journal});

  @override
  State<EditJournalView> createState() => _EditJournalViewState();
}

class _EditJournalViewState extends State<EditJournalView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late int _selectedMood;
  bool _isSaving = false;
  bool _isDeleting = false;

  final List<String> _moodEmojis = const ['😞', '🙁', '😐', '🙂', '😄'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.journal.title);
    _contentController = TextEditingController(text: widget.journal.content);
    _selectedMood = widget.journal.mood;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
            'Delete Journal',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: AppColors.palePurple50,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this journal entry?',
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
                context.read<JournalBloc>().add(
                      JournalDeleteRequested(id: widget.journal.id),
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
          'Edit Journal',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: AppColors.palePurple50,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocConsumer<JournalBloc, JournalState>(
            listener: (context, state) {
              if (state is JournalOperationSuccess && (_isSaving || _isDeleting)) {
                final bool wasDeleting = _isDeleting;
                setState(() {
                  _isSaving = false;
                  _isDeleting = false;
                });
                CustomSnackBar.show(
                  context,
                  message: wasDeleting
                      ? 'Jurnal berhasil dihapus!'
                      : 'Jurnal berhasil diperbarui!',
                  isError: false,
                );
                context.read<JournalBloc>().add(JournalLoadRequested());
                context.pop();
              } else if (state is JournalFailure && (_isSaving || _isDeleting)) {
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
              return TextButton(
                onPressed: state is JournalLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isSaving = true;
                          });
                          context.read<JournalBloc>().add(
                                JournalUpdateRequested(
                                  id: widget.journal.id,
                                  title: _titleController.text.trim(),
                                  content: _contentController.text.trim(),
                                  mood: _selectedMood,
                                ),
                              );
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          final bool isSelected = _selectedMood == index + 1;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMood = index + 1;
                              });
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
                      const SizedBox(height: 32.0),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
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
                  'Delete Journal',
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
  }
}
