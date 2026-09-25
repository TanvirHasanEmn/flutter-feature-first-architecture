import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DateBookingState {
  final DateTime selectedDate;
  final String selectedTime;
  final List<String> timeSlots;

  const DateBookingState({
    required this.selectedDate,
    required this.selectedTime,
    required this.timeSlots,
  });

  DateBookingState copyWith({
    DateTime? selectedDate,
    String? selectedTime,
    List<String>? timeSlots,
  }) {
    return DateBookingState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      timeSlots: timeSlots ?? this.timeSlots,
    );
  }
}

class DateBookingController extends Notifier<DateBookingState> {
  @override
  DateBookingState build() {
    final slots = List.generate(
      13,
          (index) => DateFormat('hh:00 a').format(DateTime(0, 0, 0, 9 + index)),
    );

    return DateBookingState(
      selectedDate: DateTime.now(),
      selectedTime: slots.isNotEmpty ? slots.first : '',
      timeSlots: slots,
    );
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void selectTime(String time) {
    state = state.copyWith(selectedTime: time);
  }
}

final dateBookingControllerProvider =
NotifierProvider<DateBookingController, DateBookingState>(
  DateBookingController.new,
);