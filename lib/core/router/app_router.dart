import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/views/forgot_password_view.dart';
import '../../features/auth/views/new_password_view.dart';
import '../../features/auth/views/otp_view.dart';
import '../../features/auth/views/password_change_success_view.dart';
import '../../features/auth/views/sign_view.dart';
import '../../features/auth/views/signup_view.dart';
import '../../features/onboarding/views/onboarding_view.dart';
import '../services/app_starter_services.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final startupNotifier = ref.watch(appStartupNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    refreshListenable: startupNotifier, // Re-triggers redirect when state transitions out of loading
    redirect: (context, state) {
      final routeState = startupNotifier.state;

      // While reading SharedPreferences, hold redirect
      if (routeState == AppInitialRouteState.loading) {
        return null;
      }

      final isAtOnboarding = state.matchedLocation == AppRoutes.onboarding;
      final isAtSignIn = state.matchedLocation == AppRoutes.signin;

      if (routeState == AppInitialRouteState.authenticated) {
        if (isAtOnboarding || isAtSignIn) {
          return AppRoutes.mainNav;
        }
      } else if (routeState == AppInitialRouteState.unauthenticated) {
        if (isAtOnboarding) {
          return AppRoutes.signin;
        }
      } else if (routeState == AppInitialRouteState.onboarding) {
        // User hasn't completed onboarding yet
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.signin,
        name: AppRoutes.signinName,
        builder: (context, state) => const SignInView(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: AppRoutes.signup,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        name: AppRoutes.otp,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return OtpView(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: AppRoutes.forgotPassword,
        builder: (context, state) => const ResetPasswordView(),
      ),
      GoRoute(
        path: AppRoutes.newPassword,
        name: AppRoutes.newPassword,
        builder: (context, state) => const NewPasswordView(),
      ),
      GoRoute(
        path: AppRoutes.passwordChangeSuccess,
        name: AppRoutes.passwordChangeSuccess,
        builder: (context, state) => const PasswordChangeSuccessView(),
      ),
    ],
  );
});