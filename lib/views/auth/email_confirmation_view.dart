import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';

class EmailConfirmationView extends StatefulWidget {
  final String email;

  const EmailConfirmationView({
    super.key,
    required this.email,
  });

  @override
  State<EmailConfirmationView> createState() => _EmailConfirmationViewState();
}

class _EmailConfirmationViewState extends State<EmailConfirmationView> {
  bool _isLoading = false;

  Future<void> _resendEmail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification link resent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 2.0,
                  ),
                ),
                child: Icon(
                  Icons.mark_email_read_outlined,
                  size: 80.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 40.0),
              Text(
                'Confirm your email',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.palePurple50,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                "We've sent a verification link to:",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                  color: AppColors.palePurple400,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.email,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Please check your inbox and click the link to activate your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                  color: AppColors.palePurple400,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56.0,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resendEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.neutral900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
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
                      : Text(
                          'Resend Verification Email',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 56.0,
                child: OutlinedButton(
                  onPressed: () {
                    context.go(AppRoutes.auth);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.darkPurple400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                  ),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.palePurple300,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }
}
