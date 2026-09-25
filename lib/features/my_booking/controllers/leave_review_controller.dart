import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';

class LeaveReviewState {
  final int selectedRating;
  final int selectedTipIndex;
  final List<int> tipOptions;
  final bool isLoading;
  final String? errorMessage;

  const LeaveReviewState({
    this.selectedRating = 5,
    this.selectedTipIndex = -1,
    this.tipOptions = const [10, 15, 20],
    this.isLoading = false,
    this.errorMessage,
  });

  LeaveReviewState copyWith({
    int? selectedRating,
    int? selectedTipIndex,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LeaveReviewState(
      selectedRating: selectedRating ?? this.selectedRating,
      selectedTipIndex: selectedTipIndex ?? this.selectedTipIndex,
      tipOptions: tipOptions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LeaveReviewController extends Notifier<LeaveReviewState> {
  @override
  LeaveReviewState build() => const LeaveReviewState();

  void selectRating(int rating) {
    state = state.copyWith(selectedRating: rating);
  }

  void selectTipIndex(int index) {
    state = state.copyWith(selectedTipIndex: index);
  }

  void nextTip() {
    if (state.selectedTipIndex < state.tipOptions.length - 1) {
      state = state.copyWith(selectedTipIndex: state.selectedTipIndex + 1);
    }
  }

  void previousTip() {
    if (state.selectedTipIndex > 0) {
      state = state.copyWith(selectedTipIndex: state.selectedTipIndex - 1);
    }
  }

  Future<String?> submitReview({
    required String serviceId,
    required String comment,
  }) async {
    if (state.selectedRating <= 0) {
      return 'Por favor selecciona una calificación';
    }
    if (comment.trim().isEmpty) {
      return 'Por favor escribe tu experiencia';
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final tipAmount = (state.selectedTipIndex >= 0 &&
        state.selectedTipIndex < state.tipOptions.length)
        ? state.tipOptions[state.selectedTipIndex]
        : 0;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final network = NetworkCaller();
      final response = await network.postRequest(
        'https://api.manospro.app/api/v1/review/create/$serviceId',
        body: {
          'rating': state.selectedRating,
          'tips': tipAmount,
          'comment': comment.trim(),
        },
        token: token,
      );

      state = state.copyWith(isLoading: false);

      if (response.isSuccess) {
        return null;
      } else {
        final err = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Error al enviar la reseña';
        state = state.copyWith(errorMessage: err);
        return err;
      }
    } catch (e) {
      final err = 'Excepción al reseñar: $e';
      state = state.copyWith(isLoading: false, errorMessage: err);
      return err;
    }
  }
}

final leaveReviewControllerProvider =
NotifierProvider<LeaveReviewController, LeaveReviewState>(
  LeaveReviewController.new,
);