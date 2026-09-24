import 'package:feature_first_architecture/features/auth/controllers/signup_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/validators.dart';

class SignUpController extends Notifier<SignUpState> {
  @override
  SignUpState build() => const SignUpState();

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void setRole(String role) {
    state = state.copyWith(selectedRole: role);
  }

  Future<String?> handleSignUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final nameError = AppValidators.validateName(fullName);
    if (nameError != null) return nameError;

    final emailError = AppValidators.validateEmail(email);
    if (emailError != null) return emailError;

    final passwordError = AppValidators.validateStrongPassword(password);
    if (passwordError != null) return passwordError;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final network = NetworkCaller();
      final response = await network.postRequest(
        AppUrls.signupUrl,
        body: {
          'userName': fullName.trim(),
          'email': email.trim().toLowerCase(),
          'password': password.trim(),
          'role': state.selectedRole,
        },
      );

      state = state.copyWith(isLoading: false);

      if (response.isSuccess) {
        return null;
      } else {
        final msg = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Sign up failed';
        state = state.copyWith(errorMessage: msg);
        return msg;
      }
    } catch (e) {
      final msg = 'Unexpected error: $e';
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return msg;
    }
  }
}

final signUpControllerProvider =
NotifierProvider<SignUpController, SignUpState>(
  SignUpController.new,
);