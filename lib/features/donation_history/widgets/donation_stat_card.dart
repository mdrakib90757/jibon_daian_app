import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class DonationStatCard extends StatelessWidget {
  const DonationStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
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
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 16),
                const SizedBox(width: 6),
                Text(label, style: AppTextStyles.notifSectionHeader),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.homeUserName.copyWith(
                fontSize: 28,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
