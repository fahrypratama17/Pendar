import 'package:go_router/go_router.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/auth/auth_view.dart';
import '../views/auth/register_view.dart';
import '../views/auth/email_confirmation_view.dart';
import '../views/home/main_layout_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/';
  static const String auth = '/auth';
  static const String register = '/register';
  static const String confirmEmail = '/confirm-email';
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
        path: register,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: confirmEmail,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return EmailConfirmationView(email: email);
        },
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const MainLayoutView(),
      ),
    ],
  );
}
