
import 'package:jibon_Bachan_app/features/notifications/widgets/notifications_enum.dart';

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    this.actionLabel,
  });

  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotifType type;
  final String? actionLabel;
}
