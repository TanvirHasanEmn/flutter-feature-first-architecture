import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/signin_controller.dart';
import '../repositories/auth_repository.dart';
import '../widgets/social_auth_button.dart';


class SignInView extends ConsumerStatefulWidget {
  const SignInView({super.key});

  @override
  ConsumerState<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref.read(signInControllerProvider.notifier).handleSignIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.primary,
        ),
      );
    } else {
      context.go(AppRoutes.mainNav);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    final controller = ref.read(signInControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IconButton(
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              //   icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
              //   onPressed: () {
              //     if (context.canPop()) {
              //       context.pop();
              //     } else {
              //       context.go(AppRoutes.onboarding);
              //     }
              //   },
              // ),
              const SizedBox(height: 24),
              Text(
                l10n.translate('Welcome Back'),
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.translate('Sign in to your account'),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff4A5568),
                ),
              ),
              const SizedBox(height: 32),

              // Email Input
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                  hintText: l10n.translate('emailLabel'),
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xff718096)),
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xff718096)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Input
              TextField(
                controller: _passwordController,
                obscureText: !state.isPasswordVisible,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                  hintText: l10n.translate('passwordLabel'),
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xff718096)),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xff718096)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xff718096),
                      size: 20,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: controller.toggleRememberMe,
                    child: Row(
                      children: [
                        Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            color: state.rememberMe ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: state.rememberMe ? AppColors.primary : const Color(0xffCBD5E0),
                              width: 1.5,
                            ),
                          ),
                          child: state.rememberMe
                              ? const Icon(Icons.check, size: 12, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.translate('Remember Me'),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff20222C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.forgotpassword),
                    child: Text(
                      l10n.translate('Forgot Password'),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: state.isLoading ? null : _submit,
                  child: state.isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Text(
                    l10n.translate('signIn'),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),


              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE5E7EC))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      l10n.translate('Or login with'),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xff4A5568),
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE5E7EC))),
                ],
              ),
              const SizedBox(height: 24),

              // Google Logins
              SocialAuthButton(
                label: l10n.translate('Continue with Google'),
                svgAssetPath: ImagePath.google,
                onPressed: state.isLoading
                    ? null
                    : () async {
                  final error = await ref.read(signInControllerProvider.notifier).handleGoogleSignIn();
                  if (mounted && error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error), backgroundColor: AppColors.primary),
                    );
                  } else if (mounted && ref.read(signInControllerProvider).user != null) {
                    context.go(AppRoutes.mainNav);
                  }
                },
              ),
              const SizedBox(height: 12),
              // OutlinedButton(
              //   style: OutlinedButton.styleFrom(
              //     minimumSize: const Size.fromHeight(50),
              //     backgroundColor: Colors.white,
              //     side: const BorderSide(color: Color(0xFFE2E8F0)),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //   ),
              //   onPressed: () => context.go(AppRoutes.mainNav),
              //   child: Text(
              //     'Continue as guest',
              //     style: GoogleFonts.inter(
              //       fontSize: 14,
              //       fontWeight: FontWeight.w500,
              //       color: const Color(0xFF4A5568),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 36),

              // Registration Link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: '${l10n.translate("Dont have an account")} ',
                    style: GoogleFonts.inter(fontSize: 14, color: const Color(0xff4A5568)),
                    children: [
                      TextSpan(
                        text: l10n.translate('signUp'),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push(AppRoutes.signup),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}