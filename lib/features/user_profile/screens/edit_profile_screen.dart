import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/user_profile/bloc/user_profile_edit_logic/edit_profile_bloc.dart';
import 'package:jibon_daian_app/features/user_profile/bloc/user_profile_edit_logic/edit_profile_event.dart';
import 'package:jibon_daian_app/features/user_profile/bloc/user_profile_edit_logic/edit_profile_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  static const List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    context.read<EditProfileBloc>().add(const EditProfileLoaded());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Pre-fill controllers once
  void _prefill(EditProfileFormState state) {
    if (_initialized) return;
    _nameController.text = state.fullName;
    _emailController.text = state.email;
    _phoneController.text = state.phone;
    _locationController.text = state.location;
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context);
        }
        if (state is EditProfileSaveFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Edit Profile', style: AppTextStyles.navTitle),
          centerTitle: true,
        ),
        body: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) {
            if (state is EditProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is EditProfileFormState) {
              _prefill(state);
              return _EditProfileForm(
                state: state,
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                locationController: _locationController,
                bloodGroups: _bloodGroups,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _EditProfileForm extends StatelessWidget {
  const _EditProfileForm({
    required this.state,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
    required this.bloodGroups,
  });

  final EditProfileFormState state;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final List<String> bloodGroups;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePaddingH,
        vertical: AppDimens.pagePaddingV,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.ripple3,
                  border: Border.all(color: AppColors.ripple1, width: 2),
                ),
                child: const ClipOval(
                  child: Icon(
                    Icons.person,
                    size: 52,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () {
                    // TODO: image picker
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 15,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Update Photo button
          TextButton(
            onPressed: () {},
            child: Text('Update Photo', style: AppTextStyles.authLinkBold),
          ),

          const SizedBox(height: AppDimens.spaceLG),

          _EditField(
            label: 'Full Name',
            controller: nameController,
            onChanged: (v) =>
                context.read<EditProfileBloc>().add(EditProfileNameChanged(v)),
          ),

          const SizedBox(height: AppDimens.spaceMD),

          _EditField(
            label: 'Email Address',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) =>
                context.read<EditProfileBloc>().add(EditProfileEmailChanged(v)),
          ),

          const SizedBox(height: AppDimens.spaceMD),

          _EditField(
            label: 'Phone Number',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (v) =>
                context.read<EditProfileBloc>().add(EditProfilePhoneChanged(v)),
          ),

          const SizedBox(height: AppDimens.spaceMD),

          _EditField(
            label: 'Location',
            controller: locationController,
            prefixIcon: Icons.location_on_outlined,
            onChanged: (v) => context.read<EditProfileBloc>().add(
              EditProfileLocationChanged(v),
            ),
          ),

          const SizedBox(height: AppDimens.spaceMD),

          Align(
            alignment: Alignment.centerLeft,
            child: Text('Blood Group', style: AppTextStyles.inputLabel),
          ),
          const SizedBox(height: AppDimens.spaceSM),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: bloodGroups.map((g) {
              final isSelected = g == state.bloodGroup;
              return GestureDetector(
                onTap: () => context.read<EditProfileBloc>().add(
                  EditProfileBloodGroupChanged(g),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.inputBorder,
                    ),
                  ),
                  child: Text(
                    g,
                    style: AppTextStyles.bloodGroupChip.copyWith(
                      color: isSelected
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppDimens.spaceXXL),

          AppPrimaryButton(
            label: 'Save Changes',
            isLoading: state.isSaving,
            onPressed: () => context.read<EditProfileBloc>().add(
              const EditProfileSaveSubmitted(),
            ),
          ),

          const SizedBox(height: AppDimens.spaceLG),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  final String label;
  final TextEditingController controller;
  final void Function(String) onChanged;
  final IconData? prefixIcon;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.primary, size: 18)
                : null,
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.inputFocusBorder,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
