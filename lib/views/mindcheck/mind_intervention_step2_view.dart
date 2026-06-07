import 'package:flutter/material.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';
import 'package:go_router/go_router.dart';

class MindExerciseView extends StatelessWidget {
  const MindExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.palePurple50,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                'INTERVENTION 2/2',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.palePurple400,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Chair Squat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.palePurple50,
                ),
              ),

              const SizedBox(height: 28),

              Container(
                width: 240,
                height: 240,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2435),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/chair.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              const Text(
                '00:45',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: AppColors.purple100,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.purple100,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.pause,
                        color: AppColors.purple900,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white24,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.play_arrow,
                        color: AppColors.palePurple50,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2435),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: AppColors.purple100,
                      size: 18,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        'Increases blood flow to the brain and breaks physical tension.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: AppColors.palePurple50,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(AppRoutes.interventionComplete);
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
    );
  }
}