import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';

class InterventionCompleteView extends StatelessWidget {
  const InterventionCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: SafeArea(
        child: Column(
          children: [
            // Content area
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Success Checkmark Icon
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1E1B30),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.08),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.purple100,
                                size: 48,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Great Job Header
                    const Text(
                      'Great job taking a\npause.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.palePurple50,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Encouragement Subtitle
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "It's completely okay to feel tired and run down. Acknowledge the fatigue, rest when needed, and bounce back stronger.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: AppColors.palePurple400,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Today's Recommendation Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1B30),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit_note_outlined,
                              color: AppColors.purple100,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Today's Recommendation",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.palePurple50,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Writing down your thoughts can help unload cognitive weight. Let's reflect on what triggered your stress today.",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: AppColors.palePurple400,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Start Journaling Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => context.go(AppRoutes.newJournal),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple100,
                          foregroundColor: AppColors.purple900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Start Journaling',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Back to Dashboard Link
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.home),
                      child: const Text(
                        "I'm feeling better, Back to Dashboard",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.palePurple50,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Bottom Navigation Bar matching the main design
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 76.0 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
        border: Border.all(
          color: AppColors.darkPurple600,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavBarItem(context, 0, 'assets/icon/Iconhome.svg', 'Home'),
            _buildNavBarItem(context, 1, 'assets/icon/Iconjournal.svg', 'Journal'),
            _buildNavBarItem(context, 2, 'assets/icon/Iconmind.svg', 'Check-in', isActive: true),
            _buildNavBarItem(context, 3, 'assets/icon/Iconschedule.svg', 'Schedule'),
            _buildNavBarItem(context, 4, 'assets/icon/Iconprofile.svg', 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(
    BuildContext context,
    int index,
    String iconPath,
    String label, {
    bool isActive = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Check-in (index 2) is already active. Tapping it resets or stays.
          if (index == 2) return;
          // GoRouter back to main layout dashboard
          context.go(AppRoutes.home);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6.0),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  isActive ? AppColors.primary : AppColors.palePurple400,
                  BlendMode.srcIn,
                ),
                width: 22.0,
                height: 22.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10.0,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.palePurple400,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
