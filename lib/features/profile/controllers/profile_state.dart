class ProfileState {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String profileImageUrl;
  final bool isVibrationOn;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.profileImageUrl = '',
    this.isVibrationOn = false,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
    bool? isVibrationOn,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isVibrationOn: isVibrationOn ?? this.isVibrationOn,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}