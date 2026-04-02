import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/model/donation_history_model.dart';

class DonationHistoryCard extends StatelessWidget {
  const DonationHistoryCard({super.key, required this.donation});

  final DonationHistoryModel donation;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Hospital icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.ripple2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_hospital,
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
                Text(donation.hospitalName, style: AppTextStyles.hospitalName),
                const SizedBox(height: 3),
                Text(
                  '${donation.date} • ${donation.bags} Bag',
                  style: AppTextStyles.hospitalSub,
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor(donation.status).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              DonationHistoryModel.statusLabel(donation.status),
              style: AppTextStyles.urgentBadge.copyWith(
                color: _statusColor(donation.status),
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(DonationStatus status) {
    switch (status) {
      case DonationStatus.completed:
        return const Color(0xFF22C55E);
      case DonationStatus.pending:
        return AppColors.primary;
      case DonationStatus.cancelled:
        return AppColors.textSecondary;
    }
  }
}
