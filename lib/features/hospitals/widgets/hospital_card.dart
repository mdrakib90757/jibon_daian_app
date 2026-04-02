import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/model/hospital_model.dart';

class HospitalCard extends StatelessWidget {
  const HospitalCard({
    super.key,
    required this.hospital,
    required this.onCall,
    required this.onDirections,
  });

  final HospitalModel hospital;
  final VoidCallback onCall;
  final VoidCallback onDirections;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hospital image ───────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimens.radiusLG),
            ),
            child: Container(
              width: double.infinity,
              height: 160,
              color: AppColors.mapOverlay,
              child: const Center(
                child: Icon(
                  Icons.local_hospital,
                  size: 60,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Urgent badge + status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (hospital.hasUrgentNeed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.ripple2,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'URGENT NEED FOR ${hospital.urgentBloodGroup}',
                          style: AppTextStyles.urgentBadge.copyWith(
                            color: AppColors.primary,
                            fontSize: 9,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    // Open/Close status
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _statusColor(hospital.status),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hospital.statusLabel,
                          style: AppTextStyles.hospitalSub.copyWith(
                            color: _statusColor(hospital.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Name
                Text(
                  hospital.name,
                  style: AppTextStyles.hospitalName.copyWith(fontSize: 17),
                ),

                const SizedBox(height: 4),

                // Location + distance
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${hospital.location} • ${hospital.distanceKm} km away',
                      style: AppTextStyles.hospitalSub,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _ActionBtn(
                        icon: Icons.call,
                        label: 'Call',
                        bgColor: AppColors.primary,
                        fgColor: AppColors.textWhite,
                        onTap: onCall,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionBtn(
                        icon: Icons.diamond_outlined,
                        label: 'Directions',
                        bgColor: AppColors.ripple2,
                        fgColor: AppColors.primary,
                        onTap: onDirections,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(HospitalStatus status) {
    switch (status) {
      case HospitalStatus.open24h:
        return const Color(0xFF22C55E);
      case HospitalStatus.closingSoon:
        return AppColors.textSecondary;
      case HospitalStatus.closed:
        return AppColors.primary;
    }
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.fgColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fgColor, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.buttonLabel.copyWith(
                color: fgColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
