import 'package:flutter/material.dart';
import '../../config/themes.dart';

class CheckInView extends StatelessWidget {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Check-in Page Placeholder',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: AppColors.palePurple300,
            ),
          ),
        ),
      ),
    );
  }
}
