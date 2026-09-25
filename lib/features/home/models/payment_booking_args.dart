class PaymentBookingArgs {
  final String serviceId;
  final DateTime selectedDate;
  final String selectedTime;
  final double amount;

  const PaymentBookingArgs({
    required this.serviceId,
    required this.selectedDate,
    required this.selectedTime,
    required this.amount,
  });
}