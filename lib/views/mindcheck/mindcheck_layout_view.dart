import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes.dart';
import '../../config/themes.dart';
import '../../services/auth_bloc.dart';
import '../../services/auth_state.dart';
import '../home/app_header.dart';
import 'mindcheck_step1_view.dart';
import 'mindcheck_step2_view.dart';
import 'mindcheck_step3_view.dart';
import 'mindcheck_step4_view.dart';
import 'mindcheck_step5_view.dart';

class MindCheckLayoutView extends StatefulWidget {
  const MindCheckLayoutView({super.key});

  @override
  State<MindCheckLayoutView> createState() => _MindCheckLayoutViewState();
}

class _MindCheckLayoutViewState extends State<MindCheckLayoutView> {
  int _currentStep = 0;

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  List<Widget> _buildPages() {
    return [
      MindCheckStep1View(onNext: () => _goToStep(1)),
      MindCheckStep2View(onNext: () => _goToStep(2)),
      MindCheckStep3View(onNext: () => _goToStep(3)),
      MindCheckStep4View(onNext: () => _goToStep(4)),
      MindCheckStep5View(
        onComplete: () => context.go(AppRoutes.home),
      ),
    ];
  }

  Widget _buildNavBarItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    final bool isActive = index == 2;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 2) {
            _goToStep(0);
            return;
          }
          context.go(AppRoutes.home);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6.0),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  isActive ? AppColors.primary : AppColors.palePurple400,
                  BlendMode.srcIn,
                ),
                width: 22.0,
                height: 22.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10.0,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.palePurple400,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    final double progress = (_currentStep + 1) / 5;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STEP ${_currentStep + 1} OF 5',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.palePurple400,
                  letterSpacing: 0.6,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.purple100,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.purple100),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.auth);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(
                onProfileTap: () {
                  context.go(AppRoutes.home);
                },
              ),
              _buildProgressHeader(),
              Expanded(
                child: IndexedStack(
                  index: _currentStep,
                  children: pages,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 76.0 + MediaQuery.of(context).padding.bottom,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
            border: Border.all(
              color: AppColors.darkPurple600,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10.0,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavBarItem(
                  index: 0,
                  iconPath: 'assets/icon/Iconhome.svg',
                  label: 'Home',
                ),
                _buildNavBarItem(
                  index: 1,
                  iconPath: 'assets/icon/Iconjournal.svg',
                  label: 'Journal',
                ),
                _buildNavBarItem(
                  index: 2,
                  iconPath: 'assets/icon/Iconmind.svg',
                  label: 'Check-in',
                ),
                _buildNavBarItem(
                  index: 3,
                  iconPath: 'assets/icon/Iconschedule.svg',
                  label: 'Schedule',
                ),
                _buildNavBarItem(
                  index: 4,
                  iconPath: 'assets/icon/Iconprofile.svg',
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


