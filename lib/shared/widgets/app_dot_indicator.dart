import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';

/// AppDotIndicator - Animated page indicator dots for onboarding
class AppDotIndicator extends StatelessWidget {
  const AppDotIndicator({
    super.key,
    required this.totalDots,
    required this.currentIndex,
  });

  final int totalDots;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? AppDimens.dotWidth : AppDimens.dotInactiveSize,
          height: AppDimens.dotHeight,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.progressActive
                : AppColors.progressInactive,
            borderRadius: BorderRadius.circular(AppDimens.dotRadius),
          ),
        );
      }),
    );
  }
}
