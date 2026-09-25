import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../models/booking_model.dart';
import 'my_booking_state.dart';

class MyBookingController extends Notifier<MyBookingState> {
  @override
  MyBookingState build() {
    Future.microtask(() => loadBookings(state.selectedTab));
    return const MyBookingState();
  }

  void changeTab(BookingTab tab) {
    if (state.selectedTab == tab) return;
    state = state.copyWith(selectedTab: tab);
    loadBookings(tab);
  }

  Future<void> refreshBookings() async {
    await loadBookings(state.selectedTab);
  }

  Future<void> loadBookings(BookingTab tab) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    String statusQuery = 'Pending';
    if (tab == BookingTab.completado) statusQuery = 'Complete';
    if (tab == BookingTab.cancelado) statusQuery = 'Cancel';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final network = NetworkCaller();
      final response = await network.getRequest(
        'https://api.manospro.app/api/v1/booking/client/my-bookings?status=$statusQuery',
        token: token,
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData;
        final list = (data is Map && data['bookings'] is List)
            ? data['bookings'] as List
            : (data is List ? data : []);

        final parsed = list
            .whereType<Map<String, dynamic>>()
            .map(BookingModel.fromJson)
            .toList();

        switch (tab) {
          case BookingTab.activo:
            state = state.copyWith(isLoading: false, activeBookings: parsed);
            break;
          case BookingTab.completado:
            state = state.copyWith(isLoading: false, completedBookings: parsed);
            break;
          case BookingTab.cancelado:
            state = state.copyWith(isLoading: false, cancelledBookings: parsed);
            break;
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load bookings',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred: $e',
      );
    }
  }
}

final myBookingControllerProvider =
NotifierProvider<MyBookingController, MyBookingState>(
  MyBookingController.new,
);