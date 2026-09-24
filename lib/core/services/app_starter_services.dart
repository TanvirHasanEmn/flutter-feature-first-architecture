import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppInitialRouteState { loading, onboarding, unauthenticated, authenticated }

class AppStartupNotifier extends ChangeNotifier {
  AppInitialRouteState state = AppInitialRouteState.loading;

  AppStartupNotifier() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    if (!hasSeenOnboarding) {
      state = AppInitialRouteState.onboarding;
      notifyListeners();
      return;
    }

    final token = prefs.getString('accessToken');
    if (token != null && token.isNotEmpty) {
      state = AppInitialRouteState.authenticated;
    } else {
      state = AppInitialRouteState.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    state = AppInitialRouteState.unauthenticated;
    notifyListeners();
  }
}

final appStartupNotifierProvider = Provider<AppStartupNotifier>((ref) {
  return AppStartupNotifier();
});