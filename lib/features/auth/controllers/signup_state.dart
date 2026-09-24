class SignUpState {
  final bool isLoading;
  final bool isPasswordVisible;
  final String selectedRole;
  final String? errorMessage;

  const SignUpState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.selectedRole = 'client',
    this.errorMessage,
  });

  SignUpState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    String? selectedRole,
    String? errorMessage,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      selectedRole: selectedRole ?? this.selectedRole,
      errorMessage: errorMessage,
    );
  }
}