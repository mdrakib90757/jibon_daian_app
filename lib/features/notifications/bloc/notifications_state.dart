import 'package:equatable/equatable.dart';
import 'package:jibon_daian_app/features/notifications/data/model.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded({
    required this.todayItems,
    required this.yesterdayItems,
  });
  final List<NotificationItem> todayItems;
  final List<NotificationItem> yesterdayItems;

  @override
  List<Object?> get props => [todayItems, yesterdayItems];
}
