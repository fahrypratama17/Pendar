import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';

class InterventionSquatView extends StatefulWidget {
  const InterventionSquatView({super.key});

  @override
  State<InterventionSquatView> createState() => _InterventionSquatViewState();
}

class _InterventionSquatViewState extends State<InterventionSquatView> {
  Timer? _timer;
  int _secondsRemaining = 45;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_isRunning) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer?.cancel();
            // Automatically navigate on timer completion
            context.go(AppRoutes.interventionComplete);
          }
        });
      }
    });
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _skipTimer() {
    _timer?.cancel();
    context.go(AppRoutes.interventionComplete);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final int mins = seconds ~/ 60;
    final int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
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
                    'INTERVENTION 2/2',
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
                      'Chair Squat',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.palePurple50,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Illustration Box
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1B30),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(200, 200),
                          painter: _SquatSilhouettePainter(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Timer text
                    Text(
                      _formatTime(_secondsRemaining),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: AppColors.palePurple50,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Play/Pause & Skip Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Play / Pause Button
                        Material(
                          color: AppColors.purple100,
                          shape: const CircleBorder(),
                          elevation: 4,
                          child: InkWell(
                            onTap: _toggleTimer,
                            customBorder: const CircleBorder(),
                            child: SizedBox(
                              width: 64,
                              height: 64,
                              child: Center(
                                child: Icon(
                                  _isRunning ? Icons.pause : Icons.play_arrow,
                                  color: AppColors.purple900,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Skip Button
                        Material(
                          color: Colors.white.withValues(alpha: 0.06),
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: _skipTimer,
                            customBorder: const CircleBorder(),
                            child: const SizedBox(
                              width: 48,
                              height: 48,
                              child: Center(
                                child: Icon(
                                  Icons.skip_next,
                                  color: AppColors.palePurple50,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Bottom info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1B30),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.favorite,
                            color: AppColors.purple100,
                            size: 20,
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Increases blood flow to the brain and breaks physical tension.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: AppColors.palePurple400,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Finish button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          _timer?.cancel();
                          context.go(AppRoutes.interventionComplete);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple100,
                          foregroundColor: AppColors.purple900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Finish Intervention',
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
}

// Custom Painter to draw a clean vector silhouette of a person doing a chair squat
class _SquatSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw glowing background circle
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.purple100.withValues(alpha: 0.18),
          AppColors.purple100.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, glowPaint);

    final double cx = size.width / 2 + 10;
    final double cy = size.height / 2 + 15;

    // Gradient for the person silhouette
    final personPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE4D5FF),
          AppColors.purple400,
        ],
      ).createShader(Rect.fromLTWH(cx - 60, cy - 80, 120, 140))
      ..style = PaintingStyle.fill;

    // Paint for the chair (dark and subtle)
    final chairPaint = Paint()
      ..color = AppColors.palePurple700.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // 2. Draw Chair
    // Seat
    canvas.drawLine(Offset(cx - 50, cy + 10), Offset(cx - 15, cy + 10), chairPaint);
    // Backrest
    canvas.drawLine(Offset(cx - 48, cy - 40), Offset(cx - 50, cy + 10), chairPaint);
    // Back leg
    canvas.drawLine(Offset(cx - 48, cy + 10), Offset(cx - 46, cy + 55), chairPaint);
    // Front leg
    canvas.drawLine(Offset(cx - 20, cy + 10), Offset(cx - 18, cy + 55), chairPaint);

    // 3. Draw Person doing squat
    // Head
    canvas.drawCircle(Offset(cx - 3, cy - 65), 11, personPaint);

    // Torso / Neck / Hips Path
    // Hips are pushed back over the chair, shoulders forward
    final bodyPath = Path()
      // Neck joint
      ..moveTo(cx - 8, cy - 50)
      // Shoulder joint
      ..lineTo(cx - 14, cy - 44)
      // Extended arms (forward)
      ..lineTo(cx + 25, cy - 44)
      ..lineTo(cx + 25, cy - 38)
      ..lineTo(cx - 10, cy - 38)
      // Spine down to hip joint
      ..lineTo(cx - 24, cy + 4)
      // Buttocks / thighs (upper leg)
      ..lineTo(cx - 26, cy + 8)
      ..lineTo(cx - 4, cy + 8) // knee joint (roughly)
      // Shins (lower leg)
      ..lineTo(cx - 2, cy + 45) // foot ankle
      ..lineTo(cx + 10, cy + 45) // foot toes
      ..lineTo(cx + 10, cy + 51)
      ..lineTo(cx - 8, cy + 51)
      ..lineTo(cx - 10, cy + 45)
      ..lineTo(cx - 12, cy + 8) // under thigh
      ..lineTo(cx - 30, cy + 4) // under hip
      ..lineTo(cx - 18, cy - 50)
      ..close();

    canvas.drawPath(bodyPath, personPaint);

    // Draw hands joint highlight
    final jointPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx + 25, cy - 41), 3.5, jointPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
