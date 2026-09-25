enum PaymentOption { cod, stripe }

class PaymentState {
  final PaymentOption selectedOption;
  final String selectedMethodName;
  final bool isLoading;
  final String? errorMessage;
  final List<String> availableMethods;

  const PaymentState({
    this.selectedOption = PaymentOption.cod,
    this.selectedMethodName = 'Credit Card',
    this.isLoading = false,
    this.errorMessage,
    this.availableMethods = const [
      'Credit Card',
      'PayPal',
      'Google Pay',
      'Apple Pay',
      'Bank Transfer',
    ],
  });

  PaymentState copyWith({
    PaymentOption? selectedOption,
    String? selectedMethodName,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PaymentState(
      selectedOption: selectedOption ?? this.selectedOption,
      selectedMethodName: selectedMethodName ?? this.selectedMethodName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      availableMethods: availableMethods,
    );
  }
}