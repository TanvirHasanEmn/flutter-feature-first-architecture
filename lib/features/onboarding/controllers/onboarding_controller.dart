import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingState {
  final int currentIndex;
  final PageController pageController;

  const OnboardingState({
    required this.currentIndex,
    required this.pageController,
  });

  OnboardingState copyWith({
    int? currentIndex,
    PageController? pageController,
  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      pageController: pageController ?? this.pageController,
    );
  }
}

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    final pageController = PageController();

    ref.onDispose(() {
      pageController.dispose();
    });

    return OnboardingState(
      currentIndex: 0,
      pageController: pageController,
    );
  }

  void onPageChanged(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void nextPage({required VoidCallback onFinished}) {
    if (state.currentIndex < 2) {
      state.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      onFinished();
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
  }
}

final onboardingControllerProvider =
NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);