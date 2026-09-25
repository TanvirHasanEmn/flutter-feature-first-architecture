import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../models/payment_booking_args.dart';
import 'payment_state.dart';

class PaymentController extends Notifier<PaymentState> {
  @override
  PaymentState build() => const PaymentState();

  void selectOption(PaymentOption option) {
    state = state.copyWith(selectedOption: option);
  }

  void selectMethodName(String method) {
    state = state.copyWith(selectedMethodName: method);
  }

  String _formatIso8601(DateTime date) {
    final utc = date.toUtc();
    final iso = utc.toIso8601String();
    return "${iso.length > 23 ? iso.substring(0, 23) : iso}+00:00";
  }

  Future<String?> processCashOnDelivery(PaymentBookingArgs args) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final requestBody = {
        'date': _formatIso8601(args.selectedDate),
        'time': args.selectedTime,
      };

      final network = NetworkCaller();
      final response = await network.postRequest(
        'https://api.manospro/${args.serviceId}',
        body: requestBody,
        token: token,
      );

      state = state.copyWith(isLoading: false);

      if (response.isSuccess) {
        return null; // Success
      } else {
        final error = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to create booking';
        state = state.copyWith(errorMessage: error);
        return error;
      }
    } catch (e) {
      final error = 'An unexpected error occurred: $e';
      state = state.copyWith(isLoading: false, errorMessage: error);
      return error;
    }
  }

  Future<String?> processPayment(PaymentBookingArgs args) async {
    switch (state.selectedOption) {
      case PaymentOption.cod:
        return await processCashOnDelivery(args);
      case PaymentOption.stripe:
      // Trigger Stripe workflow via native or custom StripeService
        return null;
    }
  }
}

final paymentControllerProvider =
NotifierProvider<PaymentController, PaymentState>(
  PaymentController.new,
);