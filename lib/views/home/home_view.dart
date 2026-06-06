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
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withOpacity(0.4),
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
                                        onPressed: () {

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
                            )
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
