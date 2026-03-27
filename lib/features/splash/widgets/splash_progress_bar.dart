import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';

/// SplashProgressBar - Loading progress indicator with label and percentage
class SplashProgressBar extends StatelessWidget {
  const SplashProgressBar({
    super.key,
    required this.progress,
    required this.label,
  });

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.progressLabel),
            Text('$percentage%', style: AppTextStyles.progressPercent),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.progressRadius),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: AppDimens.progressHeight,
            backgroundColor: AppColors.progressInactive,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.progressActive,
            ),
          ),
        ),
      ],
    );
  }
}
