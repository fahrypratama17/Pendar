import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/themes.dart';
import 'mind_intervention_step1_view.dart';

class MindCheckResultView extends StatelessWidget {
  final VoidCallback onFinish;

  const MindCheckResultView({
    super.key,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Analysis Result',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.palePurple50,
            ),
          ),

          const SizedBox(height: 32),

          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: 0.85,
                      strokeWidth: 12,
                      backgroundColor: Colors.white12,
                      color: AppColors.purple100,
                    ),
                  ),

                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '85',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: AppColors.palePurple50,
                        ),
                      ),
                      Text(
                        '/100',
                        style: TextStyle(
                          color: AppColors.palePurple400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "You're doing great! Your focus is high today, but consider more rest tonight.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.palePurple400,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),

          _buildMetric(
            title: 'Focus Level',
            percentage: 85,
          ),

          const SizedBox(height: 16),

          _buildMetric(
            title: 'Burnout Level',
            percentage: 15,
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2435),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/icon/Iconjournal.svg',
                  width: 20,
                  height: 20,
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Journaling',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.purple200,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Writing down your thoughts can help unload cognitive weight. Let's reflect on what triggered your stress today.",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          height: 1.5,
                          color: AppColors.palePurple400,
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple100,
                            foregroundColor: AppColors.purple900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Start Journaling',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          const SizedBox(height: 24),

          Center(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/mindimages.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withValues(alpha: 0.4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Let’s manage your Burnout',
                      style: TextStyle(
                        color: AppColors.palePurple50,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    FractionallySizedBox(
                      widthFactor: 1,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Start with a proper breathing technique, continued by some small exercises to ease your mind and body',
                        style: TextStyle(
                          color: AppColors.palePurple50,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MindInterventionView(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple100,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Start Intervention',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.purple900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onFinish,
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
    );
  }

  Widget _buildMetric({
    required String title,
    required int percentage,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2435),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.palePurple50,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.palePurple400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.purple100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}