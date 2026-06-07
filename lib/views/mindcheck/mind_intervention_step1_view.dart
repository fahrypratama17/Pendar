import 'package:flutter/material.dart';
import '../../config/themes.dart';

class MindInterventionView extends StatelessWidget {
  const MindInterventionView({super.key});

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
                'INTERVENTION 1/2',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '4-7-8 Breathing',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppColors.purple200,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'A powerful technique to calm your nervous system and regain focus.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 48),

              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purple100.withOpacity(0.15),
                  border: Border.all(
                    color: AppColors.purple100,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Exhale...\n(8s)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.palePurple50,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2435),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.air, color: AppColors.purple100),
                      title: Text(
                        'Inhale quietly through your nose for 4s.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.pan_tool, color: AppColors.purple100),
                      title: Text(
                        'Hold your breath for 7s.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.air, color: AppColors.purple100),
                      title: Text(
                        'Exhale completely through your mouth for 8s.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
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
    );
  }
}