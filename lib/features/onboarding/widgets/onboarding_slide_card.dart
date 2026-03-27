import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/onboarding_page_model.dart';

/// OnboardingSlideCard - Displays the images, title, and description for one slide
class OnboardingSlideCard extends StatelessWidget {
  const OnboardingSlideCard({
    super.key,
    required this.page,
    required this.pageIndex,
  });

  final OnboardingPage page;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Image Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePaddingH,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppDimens.onboardingImageRadius,
              ),
              child: Container(
                width: double.infinity,
                color: _imageBackgroundColor(pageIndex),
                child: _OnboardingIllustration(pageIndex: pageIndex),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spaceXL),

        // Title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pagePaddingH,
          ),
          child: Text(
            page.title,
            style: AppTextStyles.onboardingTitle,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: AppDimens.spaceMD),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXXL),
          child: Text(
            page.description,
            style: AppTextStyles.onboardingDescription,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Color _imageBackgroundColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFDE8E4); // warm peach for "Find Donors"
      case 1:
        return const Color(0xFFE8F5F3); // soft mint for "Be a Hero"
      case 2:
        return const Color(0xFFF0F0F0); // light grey for "Save Lives Together"
      default:
        return AppColors.ripple3;
    }
  }
}

/// Illustration placeholder widget - replace with actual assets
class _OnboardingIllustration extends StatelessWidget {
  const _OnboardingIllustration({required this.pageIndex});
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    // Each slide has its own themed illustration
    // Replace Icon with Image.asset(page.imagePath) when assets are added
    final configs = [
      _IllustrationConfig(
        imagePath: "assets/images/onboarding_save_lives.png",
        bgColor: const Color(0xFFFDE8E4),
      ),
      _IllustrationConfig(
        imagePath: "assets/images/onboarding_be_hero.png",
        bgColor: const Color(0xFFE8F5F3),
      ),
      _IllustrationConfig(
        imagePath: "assets/images/onboarding_find_donors.png",
        bgColor: const Color(0xFFF0F0F0),
      ),
    ];

    final config = configs[pageIndex.clamp(0, configs.length - 1)];

    return SizedBox(
      height: AppDimens.onboardingImageHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset(config.imagePath), const SizedBox(height: 16)],
        ),
      ),
    );
  }
}

class _IllustrationConfig {
  const _IllustrationConfig({
    this.icon,
    this.color,
    this.bgColor,
    this.subtitle,
    required this.imagePath,
  });
  final IconData? icon;
  final Color? color;
  final Color? bgColor;
  final String? subtitle;
  final String imagePath;
}
