class AppRoutes {
  AppRoutes._();

  // Paths (Used for URLs and deep links)
  static const String onboarding = '/onboarding';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgotpassword = '/forgotpassword';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgotPassword';
  static const String newPassword = '/newPassword';
  static const String passwordChangeSuccess = '/passwordChangeSuccess';
  static const String home = '/home';
  static const String mainNav = '/main-nav';
  static const String reminder = '/reminder';
  static const String profile = '/profile';
  static const String sessionPlayer = '/session-player';

  // Route Names (Used for context.goNamed)
  static const String signinName = 'signin';
  static const String homeName = 'home';
  static const String mainNavName = 'mainNav';
  static const String reminderName = 'reminder';
  static const String profileName = 'profile';
  static const String sessionPlayerName = 'sessionPlayer';
}