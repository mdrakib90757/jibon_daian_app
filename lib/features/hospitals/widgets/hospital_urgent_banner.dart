import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class HospitalUrgentBanner extends StatelessWidget {
  const HospitalUrgentBanner({
    super.key,
    required this.count,
    required this.bloodGroup,
  });

  final int count;
  final String bloodGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ripple3,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ripple1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(
              Icons.priority_high,
              color: AppColors.textWhite,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$count Hospitals nearby have urgent need for $bloodGroup donors.',
              style: AppTextStyles.hospitalSub.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
