import 'package:flutter/material.dart';

import '../../config/themes.dart';

class MindCheckStep5View extends StatelessWidget {
  final VoidCallback onComplete;

  const MindCheckStep5View({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'DAILY METRICS',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.palePurple50,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 16),
          _MetricCard(
            question: 'How long did you sleep last night ?',
            icon: Icons.nightlight_round,
            label: 'Sleep Hours',
            value: 4,
          ),
          const SizedBox(height: 16),
          _MetricCard(
            question: 'How many hours did you study today ?',
            icon: Icons.menu_book_outlined,
            label: 'Study Hours',
            value: 4,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple100,
                foregroundColor: AppColors.purple900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Analyze Result',
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
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String question;
  final IconData icon;
  final String label;
  final int value;

  const _MetricCard({
    required this.question,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2435),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.palePurple50,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Icon(
            icon,
            color: AppColors.purple100,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.palePurple400,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundActionButton(
                icon: Icons.remove,
                onTap: () {},
              ),
              const SizedBox(width: 20),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.palePurple50,
                ),
              ),
              const SizedBox(width: 20),
              _RoundActionButton(
                icon: Icons.add,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.04),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Icon(
              icon,
              color: AppColors.palePurple50,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}


