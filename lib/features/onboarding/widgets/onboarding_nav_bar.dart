import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

/// OnboardingNavBar - Top bar with back arrow, title, and skip button
class OnboardingNavBar extends StatelessWidget implements PreferredSizeWidget {
  const OnboardingNavBar({
    super.key,
    required this.titleStyle,
    required this.onBack,
    required this.onSkip,
    this.showBackButton = true,
  });

  /// 'red' = red title (slide 2), 'dark' = dark title (slides 1 & 3)
  final String titleStyle;
  final VoidCallback onBack;
  final VoidCallback onSkip;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final isRedTitle = titleStyle == 'red';

    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.backgroundWhite,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.pagePaddingH,
          vertical: AppDimens.spaceMD,
        ),
        child: Row(
          children: [
            // Back button
            if (showBackButton)
              GestureDetector(
                onTap: onBack,
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                  size: AppDimens.iconMD,
                ),
              )
            else
              const SizedBox(width: AppDimens.iconMD),

            // Title - centered
            Expanded(
              child: Text(
                AppStrings.appName,
                textAlign: TextAlign.center,
                style: isRedTitle
                    ? AppTextStyles.navTitleRed
                    : AppTextStyles.navTitle,
              ),
            ),

            // Skip button
            GestureDetector(
              onTap: onSkip,
              child: Text(
                AppStrings.skip,
                style: isRedTitle
                    ? AppTextStyles.navSkip
                    : AppTextStyles.navSkip.copyWith(
                        color: AppColors.textSecondary,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
