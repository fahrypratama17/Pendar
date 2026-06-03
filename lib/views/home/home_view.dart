import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';
import '../../services/auth_bloc.dart';
import '../../services/auth_event.dart';
import '../../services/auth_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go(AppRoutes.auth);
          }
        },
        builder: (context, state) {
          String userName = 'User';
          String userUniv = 'Institution';
          if (state is AuthAuthenticated) {
            userName = state.user.fullName;
            userUniv = state.user.university;
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
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
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.palePurple50,
                    ),
                  ),
                  Text(
                    userUniv,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.0,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  const Center(
                    child: Text(
                      'Pendar Dashboard Placeholder',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56.0,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
