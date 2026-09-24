import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/services/app_starter_services.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/onboarding_controller.dart';
import '../models/onboarding_model.dart';
import '../widgets/curved_clipper.dart';

class OnboardingView extends ConsumerWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final localizations = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);

    final List<OnboardingModel> pages = [
      OnboardingModel(
        image: ImagePath.onboarding_one,
        title: localizations.translate('onboarding_title_1'),
        subtitle: localizations.translate('onboarding_description_1'),
      ),
      OnboardingModel(
        image: ImagePath.onboarding_two,
        title: localizations.translate('onboarding_title_2'),
        subtitle: localizations.translate('onboarding_description_2'),
      ),
      OnboardingModel(
        image: ImagePath.onboarding_three,
        title: localizations.translate('onboarding_title_3'),
        subtitle: localizations.translate('onboarding_description_3'),
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // 1. Sliding Background Images Only
            Positioned.fill(
              child: PageView.builder(
                controller: state.pageController,
                itemCount: pages.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  return Image.asset(
                    pages[index].image,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            // 2. Fixed Curved Bottom Sheet (Does NOT slide)
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: const CurvedClipper(),
                child: Container(
                  height: size.height * 0.50,
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // 3. Sliding Title & Subtitle Only
                      Expanded(
                        child: PageView.builder(
                          // Using a separate controller or linking to avoid gesture conflicts,
                          // or listening to active index for immediate cross-fade/slide:
                          physics: const NeverScrollableScrollPhysics(), // Driven by the main image swipe / button
                          controller: PageController(initialPage: state.currentIndex),
                          itemCount: pages.length,
                          itemBuilder: (context, index) {
                            final page = pages[state.currentIndex];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  page.title,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  page.subtitle,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF7C8091),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // 4. Fixed Indicator
                      SmoothPageIndicator(
                        controller: state.pageController,
                        count: pages.length,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 10,
                          dotColor: Colors.grey.shade300,
                          activeDotColor: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 5. Fixed Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () async {
                            controller.nextPage(
                              onFinished: () async {
                                await ref.read(appStartupNotifierProvider).setOnboardingSeen();
                                if (context.mounted) {
                                  context.go(AppRoutes.signin);
                                }
                              },
                            );
                          },
                          child: Text(
                            state.currentIndex == pages.length - 1
                                ? localizations.translate('GET STARTED')
                                : localizations.translate('NEXT'),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}