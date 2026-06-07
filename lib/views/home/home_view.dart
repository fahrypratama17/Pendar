import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';
import '../../services/auth_bloc.dart';
import '../../services/auth_state.dart';
import '../../utils/greeting_utils.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final greeting = GreetingUtils.getGreeting();

    return  BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {

        String userName = 'User';
        if (state is AuthAuthenticated) {
          userName = state.user.fullName;
        }
        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$greeting,',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              color: AppColors.palePurple400,
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.palePurple50,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            '"The soul always knows what to do to heal itself. The challenge is to silence the mind."',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              color: AppColors.muted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 30.0),
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
                                  border: Border.all(
                                    color: AppColors.palePurple400.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withValues(alpha: 0.4),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Check Your Mind',
                                      style: TextStyle(
                                        color: AppColors.palePurple50,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    FractionallySizedBox(
                                      widthFactor: 0.7,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Measure your daily burnout level to maintain your mental harmony',
                                        style: TextStyle(
                                          color: AppColors.palePurple50,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    SizedBox(
                                      width: 200,
                                      height: 56.0,
                                      child: ElevatedButton(
                                        onPressed: () => context.go(AppRoutes.mindcheck),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.purple100,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(28.0),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          'Start Daily Check-In',
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
                          const SizedBox(height: 30.0),

                          const Text(
                            'Mood journey this week',
                            style: TextStyle(
                              color: AppColors.palePurple50,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30.0),

                          Center(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.palePurple400.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/moodimages.png'),
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
                                      "You're feeling good this week",
                                      style: TextStyle(
                                        color: AppColors.palePurple50,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 8),

                                              const Text(
                                                'Discover how your emotions evolved over the last 7 days.',
                                                style: TextStyle(
                                                  color: AppColors.palePurple50,
                                                  fontSize: 14,
                                                ),
                                              ),

                                              const SizedBox(height: 20),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(width: 16),

                                        Expanded(
                                          flex: 3,
                                          child: Image.asset(
                                            'assets/images/heart.png',
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30.0),

                          const Text(
                            'Recent Journals',
                            style: TextStyle(
                              color: AppColors.palePurple50,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30.0),

                          Center(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.palePurple400.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.secondary.withValues(alpha: 0.5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Oct 24',
                                          style: TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        SvgPicture.asset(
                                          'assets/icon/Iconjournal.svg',
                                          width: 18,
                                          height: 18,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    FractionallySizedBox(
                                      widthFactor: 1,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Felt grounded after the morning walk',
                                        style: TextStyle(
                                          color: AppColors.palePurple50,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30.0),

                          const Text(
                            'Upcoming Priorities',
                            style: TextStyle(
                              color: AppColors.palePurple50,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30.0),

                          Center(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.palePurple400.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 30,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.secondary.withValues(alpha: 0.5),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withValues(alpha: 0.08),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/icon/Iconschedule.svg',
                                            width: 16,
                                            height: 16,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 16),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'UX Research Report',
                                              style: TextStyle(
                                                color: AppColors.palePurple50,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            SizedBox(height: 4),

                                            Text(
                                              'Tomorrow, 10:00 AM',
                                              style: TextStyle(
                                                color: AppColors.muted,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 16),

                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.palePurple400,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ),

                          const SizedBox(height: 10.0),

                          Center(
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.palePurple400.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 30,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.secondary.withValues(alpha: 0.5),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withValues(alpha: 0.08),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/icon/Iconschedule.svg',
                                            width: 16,
                                            height: 16,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 16),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Team Sync',
                                              style: TextStyle(
                                                color: AppColors.palePurple50,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            SizedBox(height: 4),

                                            Text(
                                              'Thursday, 2:00 PM',
                                              style: TextStyle(
                                                color: AppColors.muted,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 16),

                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.palePurple400,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),

                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }
}
