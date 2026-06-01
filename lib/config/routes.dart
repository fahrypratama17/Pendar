import 'package:go_router/go_router.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/auth/auth_view.dart';
import '../views/home/home_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/';
  static const String auth = '/auth';
  static const String home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: onboarding,
    routes: [
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: auth,
        builder: (context, state) => const AuthView(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}
