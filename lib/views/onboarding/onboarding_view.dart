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
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 360,
                              height: 360,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFFD0A9FF),
                                    const Color(0xFFD0A9FF).withOpacity(0),
                                  ],
                                ),
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.20),
                                    blurRadius: 40,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/icon/pendaricon.png',
                                width: 200,
                                height: 200,
                              ),
                            ),
                          ],
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
                          'Redup sejenak, berpendar lebih lama.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            color: AppColors.muted,
                            fontStyle: FontStyle.italic,
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
                              'Mari Berpendar',
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
