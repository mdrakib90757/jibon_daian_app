import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/navigation/navigation.dart';
import '../bloc/home_bloc.dart';
import '../widgets/widgets.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  void initState() {
    super.initState();

    context.read<HomeBloc>().add(const HomeLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        if (state is HomeDashState) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: _HomeContent(state: state),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});
  final HomeDashState state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          floating: true,
          pinned: false,
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.ripple2,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.welcomeBack2,
                    style: AppTextStyles.homeWelcome,
                  ),
                  Text(state.userName, style: AppTextStyles.homeUserName),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.notifications),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size: 26,
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.pagePaddingH,
            vertical: AppDimens.spaceMD,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              HomeSearchBar(
                hint: AppStrings.searchHint,
                onChanged: (q) =>
                    context.read<HomeBloc>().add(HomeSearchChanged(q)),
              ),

              const SizedBox(height: AppDimens.spaceXL),

              Text(AppStrings.quickActions, style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppDimens.spaceMD),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  QuickActionButton(
                    icon: Icons.water_drop,
                    label: AppStrings.donateBlood,
                    onTap: () {},
                  ),
                  QuickActionButton(
                    icon: Icons.bloodtype,
                    label: AppStrings.requestBlood,
                    onTap: () {},
                  ),
                  QuickActionButton(
                    icon: Icons.local_hospital_outlined,
                    label: AppStrings.nearbyHospitals,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: AppDimens.spaceXL),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.urgentRequests,
                    style: AppTextStyles.sectionTitle,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      AppStrings.viewAll,
                      style: AppTextStyles.viewAll,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceMD),

              const UrgentRequestCard(
                bloodGroup: 'O+',
                hospitalName: 'City Hospital',
                location: 'Dhaka, Bangladesh',
                timeAgo: '2 mins ago',
                isUrgent: true,
              ),
              const UrgentRequestCard(
                bloodGroup: 'B+',
                hospitalName: 'Apollo Diagnostic',
                location: 'Chittagong',
                timeAgo: '18 mins ago',
                isUrgent: true,
              ),

              const SizedBox(height: AppDimens.spaceXL),

              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 160,
                      color: AppColors.mapOverlay,
                      child: const Center(
                        child: Icon(
                          Icons.map,
                          color: AppColors.textSecondary,
                          size: 60,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        color: AppColors.textPrimary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '12 ${AppStrings.activeDonorsNearby}',
                              style: AppTextStyles.hospitalSub.copyWith(
                                color: AppColors.textWhite,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  AppStrings.trackNow,
                                  style: AppTextStyles.hospitalSub.copyWith(
                                    color: AppColors.textWhite,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimens.spaceXXL),
            ]),
          ),
        ),
      ],
    );
  }
}
