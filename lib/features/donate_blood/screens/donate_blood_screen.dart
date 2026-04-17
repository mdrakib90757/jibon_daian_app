import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_Bachan_app/features/donate_blood/bloc/donate_blood_event.dart';
import 'package:jibon_Bachan_app/features/donate_blood/bloc/donate_blood_state.dart';
import 'package:jibon_Bachan_app/features/donate_blood/widgets/donation_stats_row.dart';
import 'package:jibon_Bachan_app/features/donate_blood/widgets/donor_info_card.dart';
import 'package:jibon_Bachan_app/features/donate_blood/widgets/why_donate_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../../eligibility/bloc/eligibility_bloc.dart';
import '../../eligibility/screens/eligibility_check_screen.dart';
import '../bloc/donate_blood_bloc.dart';
import '../widgets/donation_center_card.dart';

class DonateBloodScreen extends StatefulWidget {
  const DonateBloodScreen({super.key, this.onBackPressed});

  final VoidCallback? onBackPressed;

  @override
  State<DonateBloodScreen> createState() => _DonateBloodScreenState();
}

class _DonateBloodScreenState extends State<DonateBloodScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DonateBloodBloc>().add(const DonateBloodLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DonateBloodBloc, DonateBloodState>(
      listener: (context, state) {
        if (state is DonateBloodRegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registered successfully! Thank you 🩸'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: widget.onBackPressed != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: widget.onBackPressed,
                )
              : null,
          automaticallyImplyLeading: widget.onBackPressed == null,

          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.water_drop, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Text(
                'Donate Blood',
                style: AppTextStyles.navTitle.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          actions: [
            // Avatar
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.ripple2,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<DonateBloodBloc, DonateBloodState>(
          builder: (context, state) {
            if (state is DonateBloodLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is DonateBloodLoadedState) {
              return _DonateBloodContent(state: state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DonateBloodContent extends StatelessWidget {
  const _DonateBloodContent({required this.state});
  final DonateBloodLoadedState state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePaddingH,
        vertical: AppDimens.spaceMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DonorInfoCard(donorInfo: state.donorInfo),

          const SizedBox(height: AppDimens.spaceMD),

          DonationStatsRow(donorInfo: state.donorInfo),

          const SizedBox(height: AppDimens.spaceMD),

          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                const Icon(Icons.search, color: AppColors.inputIcon, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (q) => context.read<DonateBloodBloc>().add(
                      DonateBloodSearchChanged(q),
                    ),
                    style: AppTextStyles.inputText,
                    decoration: InputDecoration(
                      hintText: 'Find Donation Centers',
                      hintStyle: AppTextStyles.inputHint,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spaceMD),

          AppPrimaryButton(
            label: 'Register to Donate',
            icon: const Icon(
              Icons.volunteer_activism,
              color: AppColors.textWhite,
              size: 20,
            ),
            // Register to Donate button onPressed এ
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => EligibilityBloc(),
                  child: const EligibilityCheckScreen(),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimens.spaceXL),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Centers',
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
              ),
              GestureDetector(
                onTap: () => context.read<DonateBloodBloc>().add(
                  const DonateBloodSeeMapTapped(),
                ),
                child: Text('See Map', style: AppTextStyles.viewAll),
              ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceMD),

          ...state.filteredCenters.map(
            (center) => DonationCenterCard(center: center, onTap: () {}),
          ),

          const SizedBox(height: AppDimens.spaceXL),

          Text(
            'Why Donate?',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
          ),

          const SizedBox(height: AppDimens.spaceMD),

          Row(
            children: const [
              WhyDonateCard(
                icon: Icons.favorite,
                title: 'Save 3 Lives',
                description: 'One donation can help multiple patients.',
                iconColor: AppColors.primary,
              ),
              SizedBox(width: 12),
              WhyDonateCard(
                icon: Icons.health_and_safety,
                title: 'Health Check',
                description: 'Get a free mini-physical and blood screening.',
                iconColor: Color(0xFF16A34A),
              ),
            ],
          ),

          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }
}
