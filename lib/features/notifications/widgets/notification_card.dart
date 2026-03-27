import 'package:flutter/material.dart';
import 'package:jibon_daian_app/features/notifications/data/model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../bloc/notifications_bloc.dart';
import 'notifications_enum.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.item});

  final NotificationItem item;

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
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon dot
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _iconBgColor.withOpacity(0.15),
            ),
            child: Icon(_iconData, color: _iconBgColor, size: 18),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTextStyles.notifTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(item.timeAgo, style: AppTextStyles.notifTime),
                  ],
                ),
                const SizedBox(height: 4),
                Text(item.body, style: AppTextStyles.notifBody),
                if (item.actionLabel != null) ...[
                  const SizedBox(height: 6),
                  Text(item.actionLabel!, style: AppTextStyles.notifLink),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _iconBgColor {
    switch (item.type) {
      case NotifType.urgent:
        return AppColors.notifUrgent;
      case NotifType.success:
        return AppColors.notifSuccess;
      case NotifType.reminder:
        return AppColors.notifReminder;
      case NotifType.system:
        return AppColors.notifSystem;
    }
  }

  IconData get _iconData {
    switch (item.type) {
      case NotifType.urgent:
        return Icons.water_drop;
      case NotifType.success:
        return Icons.favorite;
      case NotifType.reminder:
        return Icons.calendar_today_outlined;
      case NotifType.system:
        return Icons.settings_outlined;
    }
  }
}
