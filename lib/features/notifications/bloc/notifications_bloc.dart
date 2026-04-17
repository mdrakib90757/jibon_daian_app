import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_Bachan_app/features/notifications/data/model.dart';
import 'package:jibon_Bachan_app/features/notifications/widgets/notifications_enum.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(const NotificationsInitial()) {
    on<LoadNotifications>(_onLoaded);
    on<NotificationDismissed>(_onDismissed);
  }

  Future<void> _onLoaded(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());
    await Future.delayed(const Duration(milliseconds: 400));

    emit(
      const NotificationsLoaded(
        todayItems: [
          NotificationItem(
            id: '1',
            title: 'Urgent Blood Request',
            body:
                'A+ blood needed at City General Hospital\nDistance: 2.4 km away • Patient ID: 4821',
            timeAgo: '1 MIN AGO',
            type: NotifType.urgent,
          ),
          NotificationItem(
            id: '2',
            title: 'Donation Successful',
            body: 'Thank you for saving a life today!',
            timeAgo: '3 MINS AGO',
            type: NotifType.success,
            actionLabel: 'View digital certificate →',
          ),
        ],
        yesterdayItems: [
          NotificationItem(
            id: '3',
            title: 'Donation Reminder',
            body:
                'You are eligible to donate again tomorrow.\nLast donation: 3 months ago',
            timeAgo: '1 DAY AGO',
            type: NotifType.reminder,
          ),
          NotificationItem(
            id: '4',
            title: 'App Update',
            body: 'New map feature is now available',
            timeAgo: '1 DAY AGO',
            type: NotifType.system,
          ),
        ],
      ),
    );
  }

  void _onDismissed(
    NotificationDismissed event,
    Emitter<NotificationsState> emit,
  ) {}
}
