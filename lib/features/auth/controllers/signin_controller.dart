import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/validators.dart';
import '../repositories/auth_repository.dart';
import 'signin_state.dart';

class SignInController extends Notifier<SignInState> {
  @override
  SignInState build() => const SignInState();

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  Future<String?> handleSignIn({
    required String email,
    required String password,
  }) async {
    final emailError = AppValidators.validateEmail(email);
    if (emailError != null) return emailError;

    final passwordError = AppValidators.validateStrongPassword(password);
    if (passwordError != null) return passwordError;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.signInWithEmail(
        email: email,
        password: password,
      );

      state = state.copyWith(isLoading: false, user: user);
      return null;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return msg;
    }
  }

  Future<String?> handleGoogleSignIn() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.signInWithGoogle();

      state = state.copyWith(isLoading: false);
      if (user == null) {
        return null; // User canceled the dialog
      }

      state = state.copyWith(user: user);
      return null;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return msg;
    }
  }
}

final signInControllerProvider =
NotifierProvider<SignInController, SignInState>(
  SignInController.new,
);