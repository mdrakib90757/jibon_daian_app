import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_Bachan_app/features/hospitals/bloc/hospital_event.dart';
import 'package:jibon_Bachan_app/features/hospitals/bloc/hospital_state.dart';
import 'package:jibon_Bachan_app/features/hospitals/widgets/hospital_card.dart';
import 'package:jibon_Bachan_app/features/hospitals/widgets/hospital_search_bar.dart';
import 'package:jibon_Bachan_app/features/hospitals/widgets/hospital_urgent_banner.dart';
import 'package:jibon_Bachan_app/features/hospitals/widgets/hospital_view_toggle.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/navigation/navigation.dart';
import '../bloc/hospital_bloc.dart';

class FindHospitalsScreen extends StatefulWidget {
  const FindHospitalsScreen({super.key, this.onBackPressed});

  final VoidCallback? onBackPressed;

  @override
  State<FindHospitalsScreen> createState() => _FindHospitalsScreenState();
}

class _FindHospitalsScreenState extends State<FindHospitalsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HospitalBloc>().add(const HospitalLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HospitalBloc, HospitalState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundWhite,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
            ),
            title: Text('Find Hospitals', style: AppTextStyles.navTitle),
            centerTitle: true,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, HospitalState state) {
    if (state is HospitalLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state is HospitalLoadedState) {
      return Column(
        children: [
          // ── Search + Toggle (sticky top) ────────────────────
          Container(
            color: AppColors.backgroundWhite,
            padding: const EdgeInsets.fromLTRB(
              AppDimens.pagePaddingH,
              AppDimens.spaceSM,
              AppDimens.pagePaddingH,
              AppDimens.spaceMD,
            ),
            child: Column(
              children: [
                HospitalSearchBar(
                  onChanged: (q) => context.read<HospitalBloc>().add(
                    HospitalSearchChanged(q),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMD),
                HospitalViewToggle(
                  isListView: state.isListView,
                  onToggle: (isList) => context.read<HospitalBloc>().add(
                    HospitalViewToggled(isList),
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable content ───────────────────────────────
          Expanded(
            child: state.isListView
                ? _buildListView(context, state)
                : _buildMapView(),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildListView(BuildContext context, HospitalLoadedState state) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePaddingH,
        vertical: AppDimens.spaceSM,
      ),
      children: [
        // Urgent banner
        if (state.urgentCount > 0) ...[
          HospitalUrgentBanner(
            count: state.urgentCount,
            bloodGroup: state.urgentBloodGroup,
          ),
          const SizedBox(height: AppDimens.spaceMD),
        ],

        // Hospital cards
        ...state.filteredHospitals.map(
          (h) => HospitalCard(
            hospital: h,
            onCall: () => _onCall(context, h.phone),
            onDirections: () => _onDirections(context, h.name),
          ),
        ),

        const SizedBox(height: AppDimens.spaceXXL),
      ],
    );
  }

  Widget _buildMapView() {
    return Container(
      color: AppColors.mapOverlay,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 80, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'Map View Coming Soon',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _onCall(BuildContext context, String? phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${phone ?? '...'}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onDirections(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening directions for $name'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
