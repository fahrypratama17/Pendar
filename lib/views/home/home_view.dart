import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/themes.dart';
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
                          const Spacer(),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.spa_outlined,
                                  size: 80.0,
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'Welcome to Pendar Dashboard',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.palePurple50,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                const Text(
                                  'Start your mindfulness journey today.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.0,
                                    color: AppColors.palePurple400,
                                  ),
                                ),
                              ],
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
