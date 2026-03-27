import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class UrgentRequestCard extends StatelessWidget {
  const UrgentRequestCard({
    super.key,
    required this.bloodGroup,
    required this.hospitalName,
    required this.location,
    required this.timeAgo,
    required this.isUrgent,
  });

  final String bloodGroup;
  final String hospitalName;
  final String location;
  final String timeAgo;
  final bool isUrgent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Blood group badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.ripple2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(bloodGroup, style: AppTextStyles.bloodGroupBadge),
            ),
          ),

          const SizedBox(width: 12),

          // Hospital info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hospitalName, style: AppTextStyles.hospitalName),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppColors.textSecondary, size: 12),
                    const SizedBox(width: 2),
                    Text(location, style: AppTextStyles.hospitalSub),
                  ],
                ),
              ],
            ),
          ),

          // Urgent badge + time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isUrgent)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.ripple2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('URGENT', style: AppTextStyles.urgentBadge),
                ),
              const SizedBox(height: 4),
              Text(timeAgo, style: AppTextStyles.hospitalSub),
            ],
          ),
        ],
      ),
    );
  }
}
