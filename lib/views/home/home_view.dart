import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/themes.dart';
import '../../services/auth_bloc.dart';
import '../../services/auth_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String userName = 'User';
          String userUniv = 'Institution';
          if (state is AuthAuthenticated) {
            userName = state.user.fullName;
            userUniv = state.user.university;
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
                              'Hello,',
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
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.palePurple50,
                              ),
                            ),
                            Text(
                              userUniv,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                color: AppColors.primary,
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
      ),
    );
  }
}
