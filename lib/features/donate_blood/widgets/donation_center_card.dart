import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/model/donate_blood_model.dart';

class DonationCenterCard extends StatelessWidget {
  const DonationCenterCard({
    super.key,
    required this.center,
    required this.onTap,
  });

  final DonationCenterModel center;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
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
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.ripple2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                center.status == DonationCenterStatus.available
                    ? Icons.location_on
                    : Icons.medical_services,
                color: AppColors.primary,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(center.name, style: AppTextStyles.hospitalName),
                  const SizedBox(height: 3),
                  Text(
                    '${center.distanceKm} km • ${center.openUntil}',
                    style: AppTextStyles.hospitalSub,
                  ),
                ],
              ),
            ),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusBgColor(center.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                DonationCenterModel.statusLabel(center.status),
                style: AppTextStyles.urgentBadge.copyWith(
                  color: _statusTextColor(center.status),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusBgColor(DonationCenterStatus s) {
    switch (s) {
      case DonationCenterStatus.available:
        return const Color(0xFFDCFCE7);
      case DonationCenterStatus.busy:
        return AppColors.ripple2;
      case DonationCenterStatus.closed:
        return AppColors.inputBackground;
    }
  }

  Color _statusTextColor(DonationCenterStatus s) {
    switch (s) {
      case DonationCenterStatus.available:
        return const Color(0xFF16A34A);
      case DonationCenterStatus.busy:
        return AppColors.primary;
      case DonationCenterStatus.closed:
        return AppColors.textSecondary;
    }
  }
}
