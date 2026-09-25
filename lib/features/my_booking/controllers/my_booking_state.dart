import '../models/booking_model.dart';

enum BookingTab { activo, completado, cancelado }

class MyBookingState {
  final BookingTab selectedTab;
  final List<BookingModel> activeBookings;
  final List<BookingModel> completedBookings;
  final List<BookingModel> cancelledBookings;
  final bool isLoading;
  final String? errorMessage;

  const MyBookingState({
    this.selectedTab = BookingTab.activo,
    this.activeBookings = const [],
    this.completedBookings = const [],
    this.cancelledBookings = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  List<BookingModel> get currentBookings {
    switch (selectedTab) {
      case BookingTab.activo:
        return activeBookings;
      case BookingTab.completado:
        return completedBookings;
      case BookingTab.cancelado:
        return cancelledBookings;
    }
  }

  MyBookingState copyWith({
    BookingTab? selectedTab,
    List<BookingModel>? activeBookings,
    List<BookingModel>? completedBookings,
    List<BookingModel>? cancelledBookings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MyBookingState(
      selectedTab: selectedTab ?? this.selectedTab,
      activeBookings: activeBookings ?? this.activeBookings,
      completedBookings: completedBookings ?? this.completedBookings,
      cancelledBookings: cancelledBookings ?? this.cancelledBookings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}