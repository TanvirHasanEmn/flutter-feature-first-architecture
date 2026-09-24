class OtpState {
  final bool isLoading;
  final bool canResend;
  final int countdown;
  final String? errorMessage;

  const OtpState({
    this.isLoading = false,
    this.canResend = false,
    this.countdown = 60,
    this.errorMessage,
  });

  OtpState copyWith({
    bool? isLoading,
    bool? canResend,
    int? countdown,
    String? errorMessage,
  }) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      canResend: canResend ?? this.canResend,
      countdown: countdown ?? this.countdown,
      errorMessage: errorMessage,
    );
  }
}