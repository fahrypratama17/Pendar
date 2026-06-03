import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes.dart';
import 'config/themes.dart';
import 'services/auth_bloc.dart';
import 'services/auth_event.dart';

class PendarApp extends StatelessWidget {
  const PendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(AuthAppStarted()),
      child: MaterialApp.router(
        title: 'Pendar',
        themeMode: ThemeMode.dark,
        darkTheme: AppTheme.darkTheme,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
