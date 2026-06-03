import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Icon(
                          Icons.spa_outlined,
                          size: 100.0,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 32.0),
                        Text(
                          'Pendar',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.palePurple50,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Detect and manage burnout effectively to live a more mindful and balanced life.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            color: AppColors.palePurple400,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 56.0,
                          child: ElevatedButton(
                            onPressed: () {
                              context.go(AppRoutes.auth);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.neutral900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48.0),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
