import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes.dart';
import '../../config/themes.dart';

class InterventionCompleteView extends StatelessWidget {
  const InterventionCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purple100.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.check,
                  size: 48,
                  color: AppColors.purple100,
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Great job taking a pause.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.palePurple50,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "It's completely okay to feel tired and run down. Acknowledge the fatigue, rest when needed, and bounce back stronger.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.palePurple400,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2435),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.edit_note,
                      color: AppColors.purple100,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Recommendation",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
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
                              height: 1.5,
                            ),
                          ),
                        ],
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
                    context.go(AppRoutes.journal);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple100,
                    foregroundColor: AppColors.purple900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Start Journaling',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  context.go(AppRoutes.home);
                },
                child: const Text(
                  "I'm feeling better, Back to Dashboard",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    decoration: TextDecoration.underline,
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