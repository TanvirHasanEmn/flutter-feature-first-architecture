import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/validators.dart';
import 'reset_password_state.dart';

class ResetPasswordController extends Notifier<ResetPasswordState> {
  @override
  ResetPasswordState build() => const ResetPasswordState();

  Future<String?> sendOtp(String email) async {

    final emailError = AppValidators.validateEmail(email);
    if (emailError != null) return emailError;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final network = NetworkCaller();
      final response = await network.postRequest(
        AppUrls.send_otp,
        body: {'email': email.trim().toLowerCase()},
      );

      state = state.copyWith(isLoading: false);

      if (response.isSuccess) {
        return null;
      } else {
        final msg = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to send OTP';
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

final resetPasswordControllerProvider =
NotifierProvider<ResetPasswordController, ResetPasswordState>(
  ResetPasswordController.new,
);