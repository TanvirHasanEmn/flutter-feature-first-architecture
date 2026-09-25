import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/views/forgot_password_view.dart';
import '../../features/auth/views/new_password_view.dart';
import '../../features/auth/views/otp_view.dart';
import '../../features/auth/views/password_change_success_view.dart';
import '../../features/auth/views/sign_view.dart';
import '../../features/auth/views/signup_view.dart';
import '../../features/home/models/payment_booking_args.dart';
import '../../features/home/models/service_item_model.dart';
import '../../features/home/views/checkout.dart';
import '../../features/home/views/date_booking.dart';
import '../../features/home/views/notification.dart';
import '../../features/home/views/payment_method.dart';
import '../../features/home/views/services.dart';
import '../../features/message/views/chat_page.dart';
import '../../features/my_booking/views/cancel_service.dart';
import '../../features/my_booking/views/leave_review.dart';
import '../../features/nav/views/nav_view.dart';
import '../../features/onboarding/views/onboarding_view.dart';
import '../../features/profile/views/edit_profile.dart';
import '../../features/profile/views/faq_page.dart';
import '../../features/profile/views/privacy.dart';
import '../../features/profile/views/subscription_details.dart';
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
      GoRoute(
        path: AppRoutes.mainNav,
        name: AppRoutes.mainNavName,
        builder: (context, state) => const MainNavView(),
      ),
      GoRoute(
        path: AppRoutes.dateBooking,
        name: AppRoutes.dateBooking,
        builder: (context, state) {
          final service = state.extra as ServiceItem;
          return DateBookingView(service: service);
        },
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: AppRoutes.checkout,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return CheckoutView(
            service: params['service'] as ServiceItem,
            selectedDate: params['date'] as DateTime,
            selectedTime: params['time'] as String,
          );
        },
      ),

      GoRoute(
        path: AppRoutes.notification,
        name: AppRoutes.notification,
        builder: (context, state) => const NotificationView(),
      ),
      GoRoute(
        path: AppRoutes.services,
        name: AppRoutes.services,
        builder: (context, state) => const ServicesView(),
      ),

      GoRoute(
        path: AppRoutes.paymentMethod,
        name: AppRoutes.paymentMethod,
        builder: (context, state) {
          final args = state.extra as PaymentBookingArgs;
          return PaymentMethodView(args: args);
        },
      ),

      GoRoute(
        path: AppRoutes.chatRoom,
        name: AppRoutes.chatRoom,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return ChatPage(
            userId: params['userId'] as String,
            userName: params['userName'] as String? ?? 'Messages',
            userImage: params['userImage'] as String? ?? '',
          );
        },
      ),


      GoRoute(
        path: AppRoutes.cancelBooking,
        name: AppRoutes.cancelBooking,
        builder: (context, state) {
          final bookingId = state.extra as String? ?? '';
          return CancelServiceView(bookingId: bookingId);
        },
      ),
      GoRoute(
        path: AppRoutes.leaveReview,
        name: AppRoutes.leaveReview,
        builder: (context, state) {
          final serviceId = state.extra as String? ?? '';
          return LeaveReviewView(serviceId: serviceId);
        },
      ),

      GoRoute(
        path: AppRoutes.editProfile,
        name: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileView(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        name: AppRoutes.faq,
        builder: (context, state) => const FaqView(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        name: AppRoutes.privacy,
        builder: (context, state) => const PrivacyPolicyView(),
      ),
      GoRoute(
        path: AppRoutes.subscriptionDetails,
        name: AppRoutes.subscriptionDetails,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return SubscriptionDetailsView(subscriptionData: data);
        },
      ),
    ],
  );
});