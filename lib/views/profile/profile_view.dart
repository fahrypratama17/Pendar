import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/themes.dart';
import '../../services/auth_bloc.dart';
import '../../services/auth_event.dart';
import '../../services/auth_state.dart';
import '../../components/custom_snackbar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _universityController = TextEditingController();
  bool _remindersEnabled = true;
  bool _isSaving = false;

  Future<void> _pickAvatar() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null && mounted) {
        setState(() {
          _isSaving = true;
        });
        context.read<AuthBloc>().add(
              AuthAvatarUpdated(localFilePath: image.path),
            );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          context,
          message: 'Gagal memilih gambar: $e',
          isError: true,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _usernameController.text = authState.user.fullName;
      _emailController.text = authState.user.email;
      _universityController.text = authState.user.university;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkPurple900,
                AppColors.purple900,
              ],
            ),
          ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated && _isSaving) {
              setState(() {
                _isSaving = false;
              });
              CustomSnackBar.show(
                context,
                message: 'Profil berhasil diperbarui!',
                isError: false,
              );
            } else if (state is AuthFailure && _isSaving) {
              setState(() {
                _isSaving = false;
              });
              CustomSnackBar.show(
                context,
                message: state.message,
                isError: true,
              );
            }
          },
          builder: (context, state) {
            String fullName = '';
            String email = '';
            ImageProvider avatarImage = const AssetImage('assets/images/profile_avatar.png');
            if (state is AuthAuthenticated) {
              fullName = state.user.fullName;
              email = state.user.email;
              if (state.user.avatarUrl != null && state.user.avatarUrl!.isNotEmpty) {
                avatarImage = NetworkImage(state.user.avatarUrl!);
              }
            }
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24.0),
                      GestureDetector(
                        onTap: _pickAvatar,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  width: 3.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    blurRadius: 20.0,
                                    spreadRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 56.0,
                                backgroundImage: avatarImage,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: const BoxDecoration(
                                color: AppColors.tertiary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: AppColors.neutral900,
                                size: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.palePurple50,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.0,
                          color: AppColors.palePurple400,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: AppColors.palePurple400.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Username',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.palePurple400,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _usernameController,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                color: AppColors.palePurple50,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.neutral.withValues(alpha: 0.4),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/icon/Iconprofile.svg',
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.palePurple400,
                                      BlendMode.srcIn,
                                    ),
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            const Text(
                              'Email Address',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.palePurple400,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _emailController,
                              readOnly: true,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                color: AppColors.palePurple300,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.neutral.withValues(alpha: 0.2),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/icon/Iconemail.svg',
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.palePurple400,
                                      BlendMode.srcIn,
                                    ),
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const Text(
                              'University / Major',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.palePurple400,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _universityController,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                color: AppColors.palePurple50,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.neutral.withValues(alpha: 0.4),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/icon/Iconuniv.svg',
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.palePurple400,
                                      BlendMode.srcIn,
                                    ),
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your university / major';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24.0),
                            const Divider(
                              color: AppColors.darkPurple600,
                              height: 1.0,
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Mindful Reminders',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.palePurple50,
                                  ),
                                ),
                                Switch(
                                  value: _remindersEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      _remindersEnabled = value;
                                    });
                                  },
                                 activeThumbColor: AppColors.primary,
                                 activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                                  inactiveThumbColor: AppColors.palePurple400,
                                  inactiveTrackColor: AppColors.neutral.withValues(alpha: 0.4),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      SizedBox(
                        width: double.infinity,
                        height: 56.0,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isSaving = true;
                                    });
                                    context.read<AuthBloc>().add(
                                          AuthProfileUpdated(
                                            fullName: _usernameController.text.trim(),
                                            university: _universityController.text.trim(),
                                          ),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tertiary,
                            foregroundColor: AppColors.neutral900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                            elevation: 0,
                          ),
                          child: state is AuthLoading && _isSaving
                              ? const SizedBox(
                                  height: 24.0,
                                  width: 24.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.neutral900,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.neutral900,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextButton.icon(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                        icon: SvgPicture.asset(
                          'assets/icon/Iconlogout.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFFA4A4),
                            BlendMode.srcIn,
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA4A4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
