import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/model/donate_blood_model.dart';

class DonationStatsRow extends StatelessWidget {
  const DonationStatsRow({super.key, required this.donorInfo});
  final DonateDonorInfoModel donorInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Total donations — white card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(color: AppColors.primary, width: 4),
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL\nDONATIONS',
                  style: AppTextStyles.notifSectionHeader,
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${donorInfo.totalDonations} ',
                        style: AppTextStyles.homeUserName.copyWith(
                          fontSize: 28,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(text: 'Units', style: AppTextStyles.hospitalSub),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Next eligible — red card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEXT ELIGIBLE',
                  style: AppTextStyles.notifSectionHeader.copyWith(
                    color: AppColors.textWhite.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  donorInfo.nextEligible,
                  style: AppTextStyles.homeUserName.copyWith(
                    color: AppColors.textWhite,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
