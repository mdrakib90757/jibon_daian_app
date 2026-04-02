import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/donation_history/bloc/donation_history_event.dart';
import 'package:jibon_daian_app/features/donation_history/bloc/donation_history_state.dart';
import 'package:jibon_daian_app/features/donation_history/widgets/donation_badge_banner.dart';
import 'package:jibon_daian_app/features/donation_history/widgets/donation_history_card.dart';
import 'package:jibon_daian_app/features/donation_history/widgets/donation_stat_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../bloc/donation_history_bloc.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key, this.onBackPressed});

  final VoidCallback? onBackPressed;

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DonationHistoryBloc>().add(const DonationHistoryLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
        ),
        title: Text('Donation History', style: AppTextStyles.navTitle),
        centerTitle: false,
      ),
      body: BlocBuilder<DonationHistoryBloc, DonationHistoryState>(
        builder: (context, state) {
          if (state is DonationHistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is DonationHistoryLoadedState) {
            return ListView(
              padding: const EdgeInsets.all(AppDimens.pagePaddingH),
              children: [
                Row(
                  children: [
                    DonationStatCard(
                      label: 'Total\nDonations',
                      value: state.totalDonations.toString(),
                      icon: Icons.water_drop,
                    ),
                    const SizedBox(width: 12),
                    DonationStatCard(
                      label: 'Lives Saved',
                      value: state.livesSaved.toString(),
                      icon: Icons.favorite,
                    ),
                  ],
                ),

                const SizedBox(height: AppDimens.spaceMD),

                DonationBadgeBanner(message: state.badgeMessage),

                const SizedBox(height: AppDimens.spaceXL),

                Text('Past Donations', style: AppTextStyles.sectionTitle),

                const SizedBox(height: AppDimens.spaceMD),

                ...state.donations.map((d) => DonationHistoryCard(donation: d)),

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
