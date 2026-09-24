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
import '../controllers/signup_controller.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref.read(signUpControllerProvider.notifier).handleSignUp(
      fullName: _fullNameController.text,
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
      context.push(
        AppRoutes.otp,
        extra: _emailController.text.trim().toLowerCase(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);
    final controller = ref.read(signUpControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IconButton(
              //   padding: EdgeInsets.zero,
              //   constraints: const BoxConstraints(),
              //   icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
              //   onPressed: () {
              //     if (context.canPop()) {
              //       context.pop();
              //     } else {
              //       context.go(AppRoutes.signin);
              //     }
              //   },
              // ),
              const SizedBox(height: 24),
              Text(
                l10n.translate('Create your account'),
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.translate('create your account'),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff4A5568),
                ),
              ),
              const SizedBox(height: 32),

              // Full Name
              TextField(
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                  hintText: l10n.translate('Full name'),
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xff718096)),
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xff718096)),
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

              // Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
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

              // Password
              TextField(
                controller: _passwordController,
                obscureText: !state.isPasswordVisible,
                textInputAction: TextInputAction.done,
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
                    l10n.translate('signUp'),
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
                      l10n.translate('Or register with'),
                      style: GoogleFonts.inter(fontSize: 13, color: const Color(0xff4A5568)),
                    ),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE5E7EC))),
                ],
              ),
              const SizedBox(height: 24),

              // Google Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImagePath.google, height: 20, width: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.translate('Continue with Google'),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Guest Button
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
              //       fontWeight: FontWeight.w600,
              //       color: const Color(0xff4A5568),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 36),

              Center(
                child: RichText(
                  text: TextSpan(
                    text: '${l10n.translate("already have account question")} ',
                    style: GoogleFonts.inter(fontSize: 14, color: const Color(0xff4A5568)),
                    children: [
                      TextSpan(
                        text: l10n.translate('signIn'),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push(AppRoutes.signin),
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