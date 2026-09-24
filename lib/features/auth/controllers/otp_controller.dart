import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import 'otp_state.dart';

class OtpController extends Notifier<OtpState> {
  Timer? _timer;

  @override
  OtpState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    startTimer();
    return const OtpState();
  }

  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(countdown: 60, canResend: false);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 1) {
        state = state.copyWith(countdown: state.countdown - 1);
      } else {
        timer.cancel();
        state = state.copyWith(countdown: 0, canResend: true);
      }
    });
  }

  Future<String?> resendOtp(String email) async {
    if (!state.canResend) return null;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final network = NetworkCaller();
      final response = await network.postRequest(
        AppUrls.signupUrl,
        body: {'email': email},
      );

      state = state.copyWith(isLoading: false);

      if (response.isSuccess) {
        startTimer();
        return null;
      } else {
        return response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to resend code';
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return 'Network error: $e';
    }
  }

  Future<String?> verifyOtp({
    required String email,
    required String otp,
  }) async {
    if (otp.length != 4) {
      return 'OTP must be 4 digits';
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final network = NetworkCaller();
      final response = await network.postRequest(
        AppUrls.send_otp,
        body: {
          'email': email.trim().toLowerCase(),
          'otp': otp.trim(),
        },
      );

      state = state.copyWith(isLoading: false);

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;
        final token = data['accessToken']?.toString();

        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', token);
        }

        return null; // Success
      } else {
        final msg = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'OTP verification failed';
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

final otpControllerProvider =
NotifierProvider<OtpController, OtpState>(
  OtpController.new,
);