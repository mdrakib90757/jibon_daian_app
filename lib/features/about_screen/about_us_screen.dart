import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const List<_HowItWorksItem> _items = [
    _HowItWorksItem(
      icon: Icons.person_search_outlined,
      title: 'Find Donors',
      description:
          'Search for blood donors nearby based on blood group and location.',
    ),
    _HowItWorksItem(
      icon: Icons.campaign_outlined,
      title: 'Post Requests',
      description:
          'Quickly create a blood request that notifies all eligible donors in your area.',
    ),
    _HowItWorksItem(
      icon: Icons.verified_user_outlined,
      title: 'Save Lives',
      description:
          'Connect directly and securely to coordinate the donation process.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('About Us', style: AppTextStyles.navTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.pagePaddingH,
          vertical: AppDimens.pagePaddingV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.ripple2,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.water_drop,
                color: AppColors.primary,
                size: 44,
              ),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            Text('Jibon Bachan', style: AppTextStyles.appName),

            const SizedBox(height: 6),

            Text(
              'Connecting Life Through Donation',
              style: AppTextStyles.appTagline,
            ),

            const SizedBox(height: AppDimens.spaceLG),

            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              child: Container(
                width: double.infinity,
                height: 180,
                color: AppColors.mapOverlay,
                child: const Center(
                  child: Icon(
                    Icons.volunteer_activism,
                    size: 72,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppDimens.spaceXL),

            _SectionHeader(label: 'Our Mission'),

            const SizedBox(height: AppDimens.spaceMD),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.spaceLG),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '"To bridge the gap between blood donors and those in urgent need, '
                'ensuring that no life is lost due to the unavailability of blood. '
                'We strive to build a community where voluntary blood donation is a way of life."',
                style: AppTextStyles.authSubtitle.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.7,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            const SizedBox(height: AppDimens.spaceXL),

            _SectionHeader(label: 'How It Works'),

            const SizedBox(height: AppDimens.spaceMD),

            ..._items.map((item) => _HowItWorksCard(item: item)),

            const SizedBox(height: AppDimens.spaceXL),

            AppPrimaryButton(
              label: 'Contact Us',
              icon: const Icon(
                Icons.mail_outline,
                color: AppColors.textWhite,
                size: 18,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.contactSupport),
            ),

            const SizedBox(height: AppDimens.spaceXXL),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
      ],
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.item});
  final _HowItWorksItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.ripple2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTextStyles.hospitalName),
                const SizedBox(height: 3),
                Text(item.description, style: AppTextStyles.hospitalSub),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksItem {
  const _HowItWorksItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
