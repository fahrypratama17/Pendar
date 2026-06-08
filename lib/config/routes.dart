import 'package:go_router/go_router.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/auth/auth_view.dart';
import '../views/auth/register_view.dart';
import '../views/auth/email_confirmation_view.dart';
import '../views/home/main_layout_view.dart';
import '../views/mindcheck/mindcheck_layout_view.dart';
import '../views/mindcheck/mindcheck_result_view.dart';
import '../views/mindcheck/intervention_breathing_view.dart';
import '../views/mindcheck/intervention_squat_view.dart';
import '../views/mindcheck/intervention_complete_view.dart';
import '../views/journal/new_journal_view.dart';
import '../views/journal/edit_journal_view.dart';
import '../views/schedule/edit_schedule_view.dart';
import '../models/journal_model.dart';
import '../models/schedule_model.dart';
import '../models/mindcheck_result_model.dart';

class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/';
  static const String auth = '/auth';
  static const String register = '/register';
  static const String confirmEmail = '/confirm-email';
  static const String home = '/home';
  static const String mindcheck = '/mindcheck';
  static const String mindcheckResult = '/mindcheck-result';
  static const String interventionBreathing = '/intervention-breathing';
  static const String interventionSquat = '/intervention-squat';
  static const String interventionComplete = '/intervention-complete';
  static const String newJournal = '/new-journal';
  static const String editJournal = '/edit-journal';
  static const String editSchedule = '/edit-schedule';

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
        builder: (context, state) {
          final initialIndex = state.extra as int? ?? 0;
          return MainLayoutView(initialIndex: initialIndex);
        },
      ),
      GoRoute(
        path: mindcheck,
        builder: (context, state) => const MindCheckLayoutView(),
      ),
      GoRoute(
        path: mindcheckResult,
        builder: (context, state) {
          final result = state.extra as MindCheckResultModel;
          return MindCheckResultView(result: result);
        },
      ),
      GoRoute(
        path: interventionBreathing,
        builder: (context, state) => const InterventionBreathingView(),
      ),
      GoRoute(
        path: interventionSquat,
        builder: (context, state) => const InterventionSquatView(),
      ),
      GoRoute(
        path: interventionComplete,
        builder: (context, state) => const InterventionCompleteView(),
      ),
      GoRoute(
        path: newJournal,
        builder: (context, state) => const NewJournalView(),
      ),
      GoRoute(
        path: editJournal,
        builder: (context, state) {
          final journal = state.extra as JournalModel;
          return EditJournalView(journal: journal);
        },
      ),
      GoRoute(
        path: editSchedule,
        builder: (context, state) {
          final schedule = state.extra as ScheduleModel;
          return EditScheduleView(schedule: schedule);
        },
      ),
    ],
  );
}
