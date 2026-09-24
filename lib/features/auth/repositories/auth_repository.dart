import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/user_model.dart';

class AuthRepository {
  final NetworkCaller _network;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    NetworkCaller? network,
    GoogleSignIn? googleSignIn,
  })  : _network = network ?? NetworkCaller(),
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email']);

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _network.postRequest(
      AppUrls.loginUrl,
      body: {'email': email.trim().toLowerCase(), 'password': password.trim()},
    );

    if (response.isSuccess && response.responseData != null) {
      final user = UserModel.fromJson(response.responseData as Map<String, dynamic>);
      await _persistSession(user);
      return user;
    }
    throw Exception(response.errorMessage.isNotEmpty ? response.errorMessage : 'Sign in failed');
  }

  Future<UserModel?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null; // User canceled sign in
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    // Send token to your backend exchange endpoint
    final response = await _network.postRequest(
      AppUrls.loginUrl, // or ApiEndpoints.googleLogin
      body: {
        'idToken': idToken,
        'accessToken': accessToken,
        'email': googleUser.email,
        'displayName': googleUser.displayName,
      },
    );

    if (response.isSuccess && response.responseData != null) {
      final user = UserModel.fromJson(
        response.responseData as Map<String, dynamic>,
        fallbackToken: accessToken,
      );
      await _persistSession(user);
      return user;
    }

    throw Exception(response.errorMessage.isNotEmpty ? response.errorMessage : 'Google Sign-In failed');
  }

  Future<void> _persistSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user.token.isNotEmpty) await prefs.setString('accessToken', user.token);
    await prefs.setString('userRole', user.role);
    await prefs.setString('myid', user.id);
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userRole');
    await prefs.remove('myid');
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});