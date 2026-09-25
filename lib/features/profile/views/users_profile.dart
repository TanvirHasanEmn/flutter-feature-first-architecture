import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../controllers/users_profile_controller.dart';
import 'logout.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.translate('profile_title'),
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Avatar with fallback
              Center(
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: const Color(0xFFF1F5F9),
                  backgroundImage: state.profileImageUrl.isNotEmpty
                      ? NetworkImage(state.profileImageUrl)
                      : null,
                  child: state.profileImageUrl.isEmpty
                      ? const Icon(Icons.person, size: 54, color: Color(0xFF94A3B8))
                      : null,
                ),
              ),
              const SizedBox(height: 12),

              Center(
                child: Text(
                  state.name.isNotEmpty ? state.name : 'User',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              Center(
                child: Text(
                  state.email,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Navigation Options
              _ProfileOptionTile(
                iconPath: 'assets/icons/edit_profile1.png',
                fallbackIcon: Icons.person_outline,
                title: l10n.translate('edit_profile_button'),
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              _ProfileOptionTile(
                iconPath: 'assets/icons/edit_profile2.png',
                fallbackIcon: Icons.notifications_none,
                title: l10n.translate('notifications_menu_item'),
                onTap: () => context.push(AppRoutes.notification),
              ),
              _ProfileOptionTile(
                iconPath: 'assets/icons/edit_profile3.png',
                fallbackIcon: Icons.privacy_tip_outlined,
                title: l10n.translate('privacy_policy_menu_item'),
                onTap: () => context.push(AppRoutes.privacy),
              ),
              _ProfileOptionTile(
                iconPath: 'assets/icons/edit_profile4.png',
                fallbackIcon: Icons.help_outline,
                title: l10n.translate('faq_menu_item'),
                onTap: () => context.push(AppRoutes.faq),
              ),
              _ProfileOptionTile(
                iconPath: 'assets/icons/edit_profile5.png',
                fallbackIcon: Icons.logout,
                title: l10n.translate('logout_menu_item'),
                textColor: const Color(0xFFEF4444),
                onTap: () => LogoutBottomSheet.show(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  final String iconPath;
  final IconData fallbackIcon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _ProfileOptionTile({
    required this.iconPath,
    required this.fallbackIcon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        iconPath,
        width: 22,
        height: 22,
        errorBuilder: (_, __, ___) => Icon(fallbackIcon, size: 22, color: textColor ?? Colors.black87),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
      onTap: onTap,
    );
  }
}