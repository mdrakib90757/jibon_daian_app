import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../data/model.dart';

/// DonorCard - Individual donor result card with Call and Message buttons
class DonorCard extends StatelessWidget {
  const DonorCard({
    super.key,
    required this.donor,
    required this.onCall,
    required this.onMessage,
  });

  final DonorModel donor;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // ── Top row: avatar + info ─────────────────────────
            Row(
              children: [
                // Avatar with blood group badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Avatar circle
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.ripple3,
                        border: Border.all(
                          color: AppColors.ripple1,
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: donor.avatarUrl != null
                            ? Image.network(donor.avatarUrl!, fit: BoxFit.cover)
                            : Icon(
                                Icons.person,
                                size: 32,
                                color: AppColors.textSecondary,
                              ),
                      ),
                    ),
                    // Blood group badge
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.textWhite,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          donor.bloodGroup,
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                // Donor info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        donor.name,
                        style: AppTextStyles.hospitalName.copyWith(
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            donor.location,
                            style: AppTextStyles.hospitalSub,
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Availability status
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: donor.isAvailable
                                  ? const Color(0xFF22C55E)
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            donor.lastDonated,
                            style: AppTextStyles.hospitalSub.copyWith(
                              color: donor.isAvailable
                                  ? const Color(0xFF22C55E)
                                  : AppColors.textSecondary,
                              fontWeight: donor.isAvailable
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Action buttons ─────────────────────────────────
            Row(
              children: [
                // Call button
                Expanded(
                  child: _ActionButton(
                    icon: Icons.call,
                    label: 'Call',
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    onTap: onCall,
                  ),
                ),
                const SizedBox(width: 10),
                // Message button
                Expanded(
                  child: _ActionButton(
                    icon: Icons.message_outlined,
                    label: 'Message',
                    backgroundColor: AppColors.ripple2,
                    foregroundColor: AppColors.primary,
                    onTap: onMessage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foregroundColor, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.buttonLabel.copyWith(
                color: foregroundColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
