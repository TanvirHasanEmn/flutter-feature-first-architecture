class ResetPasswordState {
  final bool isLoading;
  final String? errorMessage;

  const ResetPasswordState({
    this.isLoading = false,
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}