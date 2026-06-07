import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/themes.dart';
import '../../services/mindcheck_cubit.dart';
import '../../services/mindcheck_state.dart';

class MindCheckStep1View extends StatelessWidget {
  final VoidCallback onNext;

  const MindCheckStep1View({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MindCheckCubit, MindCheckState>(
      builder: (context, state) {
        final selectedIndex = state.mentalHealthIndex;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 360),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFF2A2435),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'How are you feeling today?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.palePurple50,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => context.read<MindCheckCubit>().setMentalHealthIndex(0),
                          child: _MoodChoice(
                            icon: Icons.sentiment_very_dissatisfied,
                            label: 'Low',
                            isSelected: selectedIndex == 0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.read<MindCheckCubit>().setMentalHealthIndex(1),
                          child: _MoodChoice(
                            icon: Icons.sentiment_neutral,
                            label: 'Okay',
                            isSelected: selectedIndex == 1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.read<MindCheckCubit>().setMentalHealthIndex(2),
                          child: _MoodChoice(
                            icon: Icons.sentiment_satisfied,
                            label: 'Good',
                            isSelected: selectedIndex == 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple100,
                    foregroundColor: AppColors.purple900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
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

class _MoodChoice extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _MoodChoice({
	required this.icon,
	required this.label,
	this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
	final Color borderColor = isSelected
		? AppColors.purple100
		: Colors.white.withValues(alpha: 0.12);

	final Color backgroundColor = isSelected
		? AppColors.purple100.withValues(alpha: 0.12)
		: Colors.white.withValues(alpha: 0.03);

	final Color iconColor = isSelected ? AppColors.purple100 : AppColors.palePurple400;

	return Column(
	  children: [
		Container(
		  width: 72,
		  height: 72,
		  decoration: BoxDecoration(
			shape: BoxShape.circle,
			color: backgroundColor,
			border: Border.all(color: borderColor),
		  ),
		  child: Icon(
			icon,
			color: iconColor,
			size: 34,
		  ),
		),
		const SizedBox(height: 12),
		Text(
		  label,
		  style: TextStyle(
			fontFamily: 'Poppins',
			fontSize: 13,
			fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
			color: isSelected ? AppColors.purple100 : AppColors.palePurple400,
		  ),
		),
	  ],
	);
  }
}


