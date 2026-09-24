import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/validators.dart';
import 'new_password_state.dart';

class NewPasswordController extends Notifier<NewPasswordState> {
  @override
  NewPasswordState build() => const NewPasswordState();

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  Future<String?> changePassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    final passwordError = AppValidators.validateStrongPassword(newPassword);
    if (passwordError != null) return passwordError;

    if (newPassword != confirmPassword) {
      return 'Passwords do not match';
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final prefs = await SharedPreferences.getInstance();
      final forgetToken = prefs.getString('forgetToken');

      if (forgetToken == null || forgetToken.isEmpty) {
        state = state.copyWith(isLoading: false);
        return 'Session expired: Missing reset authorization token';
      }

      final network = NetworkCaller();
      final response = await network.patchRequest(
        AppUrls.resetPassword,
        body: {'newPassword': newPassword.trim()},
        token: forgetToken,
      );

      state = state.copyWith(isLoading: false);

      if (response.isSuccess) {
        await prefs.remove('forgetToken');
        return null;
      } else {
        final msg = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Password reset failed';
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

final newPasswordControllerProvider =
NotifierProvider<NewPasswordController, NewPasswordState>(
  NewPasswordController.new,
);