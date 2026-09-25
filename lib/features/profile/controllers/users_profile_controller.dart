import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../message/controller/websocket_controller.dart';
import 'profile_state.dart';

class ProfileController extends Notifier<ProfileState> {
  final NetworkCaller _network = NetworkCaller();

  @override
  ProfileState build() {
    Future.microtask(() => fetchUserProfile());
    return const ProfileState();
  }

  void toggleVibration() {
    state = state.copyWith(isVibrationOn: !state.isVibrationOn);
  }

  Future<void> fetchUserProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    if (token.isEmpty) {
      state = state.copyWith(isLoading: false);
      return;
    }

    try {
      final response = await _network.getRequest(AppUrls.allResource, token: token);
      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData as Map<String, dynamic>;
        state = state.copyWith(
          name: data['userName']?.toString() ?? '',
          email: data['email']?.toString() ?? '',
          phone: data['phone']?.toString() ?? '',
          address: data['address']?.toString() ?? '',
          profileImageUrl: data['profileImage']?.toString() ?? '',
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.errorMessage.isNotEmpty ? response.errorMessage : 'Failed to load profile',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<String?> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    try {
      final response = await _network.putRequest(
        AppUrls.updateUser,
        body: {
          'userName': name.trim(),
          'phone': phone.trim(),
          'email': state.email,
          'address': address.trim(),
        },
        token: token,
      );

      state = state.copyWith(isLoading: false);

      if (response.isSuccess) {
        state = state.copyWith(name: name, phone: phone, address: address);
        return null;
      }
      return response.errorMessage.isNotEmpty ? response.errorMessage : 'Failed to update profile';
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return e.toString();
    }
  }

  Future<String?> uploadProfilePicture(File imageFile) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    try {
      final result = await _network.putImage(
        'PUT',
        AppUrls.updateUser,
        {
          'userName': state.name,
          'email': state.email,
          'phone': state.phone,
          'address': state.address,
        },
        imageFile,
        token: token,
        imageName: 'profileImage',
      );

      state = state.copyWith(isLoading: false);

      if (result['success'] == true) {
        await fetchUserProfile();
        return null;
      }
      return result['message']?.toString() ?? 'Failed to upload photo';
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return e.toString();
    }
  }

  Future<void> logout() async {
    // 1. Reset WebSocket real-time connections
    await ref.read(chatWebSocketControllerProvider.notifier).reset();

    // 2. Clear credentials from persistent storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userRole');
    await prefs.remove('myid');
    await prefs.remove('profileImage');

    // 3. Reset internal state
    state = const ProfileState();
  }
}

final profileControllerProvider = NotifierProvider<ProfileController, ProfileState>(
  ProfileController.new,
);