import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/themes.dart';
import '../../config/routes.dart';
import '../../services/auth_bloc.dart';
import '../../services/auth_state.dart';
import 'home_view.dart';
import '../journal/journal_view.dart';
import '../checkin/checkin_view.dart';
import '../schedule/schedule_view.dart';
import '../profile/profile_view.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({super.key});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    JournalView(),
    CheckInView(),
    ScheduleView(),
    ProfileView(),
  ];

  Widget _buildNavBarItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    final bool isActive = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 16.0,
                          spreadRadius: 2.0,
                        )
                      ]
                    : null,
              ),
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.auth);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
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
