import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/themes.dart';

class PendarApp extends StatelessWidget {
  const PendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pendar',
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRoutes.router,
    );
  }
}
