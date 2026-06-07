import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';

class InterventionBreathingView extends StatefulWidget {
  const InterventionBreathingView({super.key});

  @override
  State<InterventionBreathingView> createState() => _InterventionBreathingViewState();
}

class _InterventionBreathingViewState extends State<InterventionBreathingView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  Timer? _timer;
  String _breathStatus = 'Inhale...';
  int _secondsRemaining = 4;
  int _cyclePhase = 0; // 0 = Inhale, 1 = Hold, 2 = Exhale

  @override
  void initState() {
    super.initState();
    
    // Animation Controller setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Will be dynamically modified
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.25).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutSine),
    );

    _glowAnimation = Tween<double>(begin: 3.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutSine),
    );

    _startBreathingCycle();
  }

  void _startBreathingCycle() {
    _runPhase();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 1) {
          _secondsRemaining--;
        } else {
          // Switch phase
          _cyclePhase = (_cyclePhase + 1) % 3;
          _runPhase();
        }
      });
    });
  }

  void _runPhase() {
    if (_cyclePhase == 0) {
      // INHALE (4 seconds)
      _breathStatus = 'Inhale...';
      _secondsRemaining = 4;
      _animationController.duration = const Duration(seconds: 4);
      _animationController.forward(from: 0.0);
    } else if (_cyclePhase == 1) {
      // HOLD (7 seconds)
      _breathStatus = 'Hold...';
      _secondsRemaining = 7;
      _animationController.duration = const Duration(seconds: 7);
      // Stays expanded and does a slow, subtle pulse/glow animation
      _animationController.repeat(reverse: true);
    } else {
      // EXHALE (8 seconds)
      _breathStatus = 'Exhale...';
      _secondsRemaining = 8;
      _animationController.duration = const Duration(seconds: 8);
      _animationController.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Bar with Close X Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.palePurple50, size: 26),
                    onPressed: () => context.go(AppRoutes.mindcheckResult),
                  ),
                  const Text(
                    'INTERVENTION 1/2',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.muted,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 48), // Balancing spacer
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    // Heading Text
                    const Text(
                      '4-7-8 Breathing',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.palePurple50,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    const Text(
                      'A powerful technique to calm your nervous system and regain focus.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppColors.palePurple400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Breathing Circle Animation Widget
                    Center(
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Container(
                            width: 250,
                            height: 250,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer ripple 3
                                Container(
                                  width: 230 * _scaleAnimation.value,
                                  height: 230 * _scaleAnimation.value,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.purple100.withValues(alpha: 0.06),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                // Outer ripple 2
                                Container(
                                  width: 190 * _scaleAnimation.value,
                                  height: 190 * _scaleAnimation.value,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.purple100.withValues(alpha: 0.12),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                // Outer ripple 1
                                Container(
                                  width: 150 * _scaleAnimation.value,
                                  height: 150 * _scaleAnimation.value,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.purple100.withValues(alpha: 0.25),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                // Inner Glowing Circle
                                Container(
                                  width: 110 * _scaleAnimation.value,
                                  height: 110 * _scaleAnimation.value,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF2E2542),
                                    border: Border.all(
                                      color: AppColors.purple100.withValues(alpha: 0.5),
                                      width: 2.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.18),
                                        blurRadius: _glowAnimation.value * _scaleAnimation.value,
                                        spreadRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icon/Iconbreath.svg',
                                        width: 26,
                                        height: 26,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.palePurple50,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _breathStatus,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.palePurple50,
                                        ),
                                      ),
                                      Text(
                                        '(${_secondsRemaining}s)',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.palePurple400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Guide Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1B30),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
                      ),
                      child: Column(
                        children: [
                          _buildGuideRow(
                            iconPath: 'assets/icon/Icontimer.svg',
                            text: 'Inhale quietly through your nose for ',
                            boldText: '4s.',
                          ),
                          const SizedBox(height: 16),
                          _buildGuideRow(
                            iconPath: 'assets/icon/Iconhand.svg',
                            text: 'Hold your breath for ',
                            boldText: '7s.',
                          ),
                          const SizedBox(height: 16),
                          _buildGuideRow(
                            iconPath: 'assets/icon/Iconbreath.svg',
                            text: 'Exhale completely through your mouth for ',
                            boldText: '8s.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => context.go(AppRoutes.interventionSquat),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple100,
                          foregroundColor: AppColors.purple900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Next Intervention',
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
    );
  }

  Widget _buildGuideRow({
    required String iconPath,
    required String text,
    required String boldText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            iconPath,
            colorFilter: const ColorFilter.mode(AppColors.palePurple400, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.palePurple400,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: text),
                  TextSpan(
                    text: boldText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.palePurple50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
