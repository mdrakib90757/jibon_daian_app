import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/model/donate_blood_model.dart';

class DonorInfoCard extends StatelessWidget {
  const DonorInfoCard({super.key, required this.donorInfo});
  final DonateDonorInfoModel donorInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Welcome text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back,', style: AppTextStyles.homeWelcome),
              const SizedBox(height: 4),
              Text(
                donorInfo.userName,
                style: AppTextStyles.authTitle.copyWith(fontSize: 20),
              ),
            ],
          ),

          // Blood group badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.ripple2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'GROUP',
                  style: AppTextStyles.notifSectionHeader.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  donorInfo.bloodGroup,
                  style: AppTextStyles.homeUserName.copyWith(
                    color: AppColors.primary,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
