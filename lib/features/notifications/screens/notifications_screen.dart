import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/notifications/bloc/notifications_event.dart';
import 'package:jibon_daian_app/features/notifications/bloc/notifications_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../bloc/notifications_bloc.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(const LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.notifications, style: AppTextStyles.navTitle),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is NotificationsLoaded) {
            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.pagePaddingH,
                vertical: AppDimens.spaceMD,
              ),
              children: [
                //TODAY
                Text(AppStrings.today, style: AppTextStyles.notifSectionHeader),
                const SizedBox(height: AppDimens.spaceSM),

                ...state.todayItems.map((item) => NotificationCard(item: item)),

                const SizedBox(height: AppDimens.spaceMD),

                // YESTERDAY
                Text(
                  AppStrings.yesterday,
                  style: AppTextStyles.notifSectionHeader,
                ),
                const SizedBox(height: AppDimens.spaceSM),

                ...state.yesterdayItems.map(
                  (item) => NotificationCard(item: item),
                ),

                const SizedBox(height: AppDimens.spaceXXL),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
