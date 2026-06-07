import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/themes.dart';
import '../../services/mindcheck_cubit.dart';
import '../../services/mindcheck_state.dart';

class MindCheckStep5View extends StatelessWidget {
  final VoidCallback onComplete;

  const MindCheckStep5View({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MindCheckCubit, MindCheckState>(
      builder: (context, state) {
        final cubit = context.read<MindCheckCubit>();
        final isSubmitting = state.status == MindCheckStatus.submitting;

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
                value: state.sleepHours,
                onDecrement: isSubmitting
                    ? null
                    : () {
                        if (state.sleepHours > 0) {
                          cubit.setSleepHours(state.sleepHours - 1);
                        }
                      },
                onIncrement: isSubmitting
                    ? null
                    : () {
                        if (state.sleepHours < 24) {
                          cubit.setSleepHours(state.sleepHours + 1);
                        }
                      },
              ),
              const SizedBox(height: 16),
              _MetricCard(
                question: 'How many hours did you study today ?',
                icon: Icons.menu_book_outlined,
                label: 'Study Hours',
                value: state.studyHours,
                onDecrement: isSubmitting
                    ? null
                    : () {
                        if (state.studyHours > 0) {
                          cubit.setStudyHours(state.studyHours - 1);
                        }
                      },
                onIncrement: isSubmitting
                    ? null
                    : () {
                        if (state.studyHours < 24) {
                          cubit.setStudyHours(state.studyHours + 1);
                        }
                      },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : () => cubit.submitMindCheck(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple100,
                    foregroundColor: AppColors.purple900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    disabledBackgroundColor: AppColors.purple100.withOpacity(0.3),
                    elevation: 0,
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple900),
                          ),
                        )
                      : const Text(
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
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String question;
  final IconData icon;
  final String label;
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const _MetricCard({
    required this.question,
    required this.icon,
    required this.label,
    required this.value,
    this.onDecrement,
    this.onIncrement,
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
                onTap: onDecrement,
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
                onTap: onIncrement,
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
  final VoidCallback? onTap;

  const _RoundActionButton({required this.icon, this.onTap});

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
              color: onTap == null ? AppColors.palePurple400.withOpacity(0.3) : AppColors.palePurple50,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}


