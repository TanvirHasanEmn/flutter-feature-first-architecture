import '../models/user_model.dart';

class SignInState {
  final bool isLoading;
  final bool isPasswordVisible;
  final bool rememberMe;
  final UserModel? user;
  final String? errorMessage;

  const SignInState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.user,
    this.errorMessage,
  });

  SignInState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    bool? rememberMe,
    UserModel? user,
    String? errorMessage,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}