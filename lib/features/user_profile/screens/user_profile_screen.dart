import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/user_profile/bloc/user_profile_edit_logic/edit_profile_bloc.dart';
import 'package:jibon_daian_app/features/user_profile/bloc/user_profile_event.dart';
import 'package:jibon_daian_app/features/user_profile/bloc/user_profile_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../bloc/user_profile_bloc.dart';
import '../data/model/user_profile_model.dart';
import 'edit_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const UserProfileScreen({super.key, this.onBackPressed});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(const UserProfileLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileNavigateLogin) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
        if (state is UserProfileNavigateEdit) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Edit Profile coming soon!'),
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: widget.onBackPressed,
          ),
          title: Text('Profile', style: AppTextStyles.navTitle),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.primary,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is UserProfileLoadedState) {
              return _ProfileContent(profile: state.profile);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});
  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: AppColors.backgroundWhite,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceLG),
            child: Column(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.ripple1, width: 2),
                        color: AppColors.ripple3,
                      ),
                      child: const ClipOval(
                        child: Icon(
                          Icons.person,
                          size: 52,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    // Edit icon badge
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => EditProfileBloc(),
                                child: const EditProfileScreen(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 14,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Name
                Text(profile.fullName, style: AppTextStyles.authTitle),

                const SizedBox(height: 6),

                // Blood group badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.ripple2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.water_drop,
                        color: AppColors.primary,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'BLOOD GROUP: ${profile.bloodGroup}',
                        style: AppTextStyles.urgentBadge.copyWith(
                          color: AppColors.primary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Edit Profile button
                SizedBox(
                  width: 160,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => EditProfileBloc(),
                          child: const EditProfileScreen(),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Edit Profile',
                      style: AppTextStyles.buttonLabel.copyWith(fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimens.spaceLG),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.pagePaddingH,
                  ),
                  child: Row(
                    children: [
                      _StatCard(
                        label: 'TOTAL DONATIONS',
                        value: profile.totalDonations.toString().padLeft(
                          2,
                          '0',
                        ),
                        valueColor: AppColors.textPrimary,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.inputBorder,
                      ),
                      _StatCard(
                        label: 'LAST DONATION',
                        value: profile.lastDonation,
                        valueColor: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimens.spaceMD),

                // Next eligible
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.pagePaddingH,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'NEXT ELIGIBLE',
                        style: AppTextStyles.notifSectionHeader,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.pagePaddingH,
                  ),
                  child: Row(
                    children: [
                      Text(
                        profile.nextEligible,
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: const Color(0xFF22C55E),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimens.spaceMD),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spaceXS),

          _Section(
            title: 'Personal Information',
            child: Column(
              children: [
                _InfoRow(icon: Icons.person_outline, label: profile.fullName),
                _Divider(),
                _InfoRow(icon: Icons.email_outlined, label: profile.email),
                _Divider(),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: profile.phoneNumber,
                ),
                _Divider(),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: profile.location,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spaceXS),

          _Section(
            title: 'Account Settings',
            child: Column(
              children: [
                _SettingRow(
                  icon: Icons.lock_outline,
                  label: 'Change Password',
                  onTap: () => context.read<UserProfileBloc>().add(
                    const UserProfileChangePasswordTapped(),
                  ),
                ),
                _Divider(),
                _SettingRow(
                  icon: Icons.notifications_outlined,
                  label: 'Notification Settings',
                  onTap: () => context.read<UserProfileBloc>().add(
                    const UserProfileNotificationsTapped(),
                  ),
                ),
                _Divider(),
                _SettingRow(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Privacy Policy',
                  onTap: () => context.read<UserProfileBloc>().add(
                    const UserProfilePrivacyTapped(),
                  ),
                ),

                _SettingRow(
                  icon: Icons.info_outline,
                  label: 'About Us',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.aboutUs),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spaceMD),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePaddingH,
            ),
            child: GestureDetector(
              onTap: () => _showLogoutDialog(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.ripple3,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.ripple1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Logout', style: AppTextStyles.authTitle),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.authSubtitle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.authLinkBold.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<UserProfileBloc>().add(
                const UserProfileLogoutTapped(),
              );
            },
            child: Text('Logout', style: AppTextStyles.authLinkBold),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.notifSectionHeader),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.homeUserName.copyWith(
                color: valueColor,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundWhite,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePaddingH,
        vertical: AppDimens.spaceMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppDimens.spaceMD),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: AppTextStyles.inputText)),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTextStyles.hospitalName)),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.inputBorder, height: 1, thickness: 1);
  }
}
