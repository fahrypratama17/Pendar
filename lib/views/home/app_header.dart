import 'package:flutter/material.dart';
import '../../config/themes.dart';
import '../profile/profile_view.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const AppHeader({
    super.key,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/icon/pendaricon.png',
                      width: 32,
                      height: 32,
                    ),
                    IconButton(
                      onPressed: onProfileTap,
                      icon: const Icon(
                        Icons.person_outline,
                        color: AppColors.palePurple50,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Pendar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.palePurple50,
                  ),
                ),
              ],
            )
      ),
    );
  }
}