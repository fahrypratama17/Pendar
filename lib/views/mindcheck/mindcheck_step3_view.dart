import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/themes.dart';
import '../../services/mindcheck_cubit.dart';
import '../../services/mindcheck_state.dart';

class MindCheckStep3View extends StatelessWidget {
  final VoidCallback onNext;

  const MindCheckStep3View({super.key, required this.onNext});

  static const List<String> _questions = [
    'I experienced dryness of my mouth',
    'I experienced breathing difficulty',
    'I experienced trembling in the hands',
    'I was worried about the situations in which I might panic and make a fool of myself',
    'I felt I was close to panic',
    'I was aware that my heart beat faster without any physical exertion',
    'I felt scared without any good reason',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MindCheckCubit, MindCheckState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'ANXIETY ASSESSMENT',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.palePurple50,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose a number from 0-3 which indicates how much the statement applied to you over the past week.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.palePurple400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(_questions.length, (index) {
                final question = _questions[index];
                final selectedScore = state.anxietyAnswers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AssessmentCard(
                    statement: question,
                    selectedScore: selectedScore,
                    onScoreSelected: (score) {
                      context.read<MindCheckCubit>().setAnxietyAnswer(index, score);
                    },
                  ),
                );
              }),
              const SizedBox(height: 12),
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

class _AssessmentCard extends StatelessWidget {
  final String statement;
  final int selectedScore;
  final ValueChanged<int> onScoreSelected;

  const _AssessmentCard({
    required this.statement,
    required this.selectedScore,
    required this.onScoreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2435),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            statement,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: AppColors.palePurple50,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildChip(0),
              const SizedBox(width: 6),
              _buildChip(1),
              const SizedBox(width: 6),
              _buildChip(2),
              const SizedBox(width: 6),
              _buildChip(3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(int score) {
    return _ScoreChip(
      label: score.toString(),
      isSelected: selectedScore == score,
      onTap: () => onScoreSelected(score),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ScoreChip({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.purple100 : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.purple100 : Colors.white.withOpacity(0.06),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.purple900 : AppColors.palePurple400,
            ),
          ),
        ),
      ),
    );
  }
}

