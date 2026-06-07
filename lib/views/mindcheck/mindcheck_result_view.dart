import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';
import '../../models/mindcheck_result_model.dart';
import '../home/app_header_view.dart';

class MindCheckResultView extends StatefulWidget {
  final MindCheckResultModel result;

  const MindCheckResultView({super.key, required this.result});

  @override
  State<MindCheckResultView> createState() => _MindCheckResultViewState();
}

class _MindCheckResultViewState extends State<MindCheckResultView> {
  @override
  Widget build(BuildContext context) {
    final bool isHighBurnout = widget.result.isBurnout;
    final double score = widget.result.burnoutLevelPct.toDouble();
    final double focusPercentage = widget.result.focusLevelPct / 100.0;
    final double burnoutPercentage = widget.result.burnoutLevelPct / 100.0;

    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              onProfileTap: () {
                context.go(AppRoutes.home);
              },
            ),
            
            // Content ScrollView
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Circular Gauge Section
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer Glow / Ring
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              boxShadow: isHighBurnout ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.08),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                )
                              ] : [],
                            ),
                          ),
                          // Circular Progress Bar
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: score / 100),
                              duration: const Duration(milliseconds: 1200),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return CircularProgressIndicator(
                                  value: value == 0 ? 0.03 : value, // Keep tiny sliver for 0
                                  strokeWidth: 10,
                                  backgroundColor: Colors.white.withValues(alpha: 0.06),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isHighBurnout ? AppColors.primary : AppColors.secondary.withValues(alpha: 0.6),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Center Text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                score.toInt().toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: isHighBurnout ? AppColors.palePurple50 : AppColors.primary,
                                  height: 1.1,
                                ),
                              ),
                              const Text(
                                '/100',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: AppColors.palePurple400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Diagnostic Description text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.result.analysisMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppColors.palePurple400,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Focus Level Card
                    _buildMetricsProgressCard(
                      icon: Icons.psychology_outlined,
                      label: "Focus Level",
                      percentage: focusPercentage,
                    ),
                    const SizedBox(height: 16),

                    // Burnout Level Card
                    _buildMetricsProgressCard(
                      icon: Icons.opacity_outlined,
                      label: "Burnout Level",
                      percentage: burnoutPercentage,
                    ),
                    const SizedBox(height: 24),

                    // Action Card (Journaling vs Let's Manage Burnout)
                    isHighBurnout 
                        ? _buildManageBurnoutCard(context)
                        : _buildJournalingCard(context),
                    
                    const SizedBox(height: 24),

                    // Go back to Dashboard Button (Visible for low burnout as per screenshot)
                    if (!isHighBurnout)
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => context.go(AppRoutes.home),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple100,
                            foregroundColor: AppColors.purple900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Go back to Dashboard',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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

  // Builder for Focus & Burnout Progress cards
  Widget _buildMetricsProgressCard({
    required IconData icon,
    required String label,
    required double percentage,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: AppColors.purple100,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.palePurple50,
                    ),
                  ),
                ],
              ),
              Text(
                "${(percentage * 100).round()}%",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.palePurple50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar with animation
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 8,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: percentage),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.purple100),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builder for Low Burnout Journaling Card
  Widget _buildJournalingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF191427),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(
                Icons.edit_note_outlined,
                color: AppColors.purple100,
                size: 24,
              ),
              SizedBox(width: 10),
              Text(
                'Journaling',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.palePurple50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Writing down your thoughts can help unload cognitive weight. Let's reflect on what triggered your stress today.",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: AppColors.palePurple400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => context.go(AppRoutes.newJournal),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple100,
                foregroundColor: AppColors.purple900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Start Journaling',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builder for High Burnout Intervention Card
  Widget _buildManageBurnoutCard(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF191427),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          // Background Custom Paint meditation silhouette
          Positioned(
            right: -20,
            bottom: -10,
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(
                size: const Size(180, 180),
                painter: _MeditationSilhouettePainter(),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Let's manage your Burnout",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.palePurple50,
                  ),
                ),
                const SizedBox(height: 12),
                const FractionallySizedBox(
                  widthFactor: 0.85,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Start with a proper breathing technique, continued by some small exercises to ease your mind and body",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppColors.palePurple400,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => context.go(AppRoutes.interventionBreathing),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple100,
                      foregroundColor: AppColors.purple900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Start Intervention',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

// Paints a custom glowing meditation vector pose
class _MeditationSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.purple100
      ..style = PaintingStyle.fill;

    final double cx = size.width / 2;
    final double cy = size.height / 2 + 10;

    // 1. Draw glowing aura ring
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.purple100.withValues(alpha: 0.35),
          AppColors.purple100.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy - 20), radius: size.width / 2))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy - 20), size.width / 2, auraPaint);

    // 2. Draw head
    canvas.drawCircle(Offset(cx, cy - 45), 13, paint);

    // 3. Draw torso / shoulders
    final bodyPath = Path()
      ..moveTo(cx - 22, cy - 22) // Left shoulder
      ..quadraticBezierTo(cx, cy - 28, cx + 22, cy - 22) // Neck and right shoulder
      ..lineTo(cx + 15, cy + 15) // Right waist
      ..lineTo(cx - 15, cy + 15) // Left waist
      ..close();
    canvas.drawPath(bodyPath, paint);

    // 4. Draw arms resting on knees
    final leftArmPath = Path()
      ..moveTo(cx - 22, cy - 22)
      ..cubicTo(cx - 38, cy - 10, cx - 35, cy + 15, cx - 22, cy + 12)
      ..close();
    canvas.drawPath(leftArmPath, paint);

    final rightArmPath = Path()
      ..moveTo(cx + 22, cy - 22)
      ..cubicTo(cx + 38, cy - 10, cx + 35, cy + 15, cx + 22, cy + 12)
      ..close();
    canvas.drawPath(rightArmPath, paint);

    // 5. Draw crossed legs (lotus base)
    final legsPath = Path()
      ..moveTo(cx - 15, cy + 15)
      ..cubicTo(cx - 48, cy + 12, cx - 36, cy + 34, cx, cy + 34)
      ..cubicTo(cx + 36, cy + 34, cx + 48, cy + 12, cx + 15, cy + 15)
      ..close();
    canvas.drawPath(legsPath, paint);

    // 6. Draw small details (knees/feet)
    canvas.drawCircle(Offset(cx - 32, cy + 22), 6, paint);
    canvas.drawCircle(Offset(cx + 32, cy + 22), 6, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
