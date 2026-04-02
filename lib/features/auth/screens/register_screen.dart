import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedBloodGroup = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
            ),
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
          title: Text(AppStrings.createAccount, style: AppTextStyles.navTitle),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePaddingH,
              vertical: AppDimens.pagePaddingV,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Logo + Heading ────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.ripple2,
                          ),
                          child: const Icon(
                            Icons.water_drop,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMD),
                        Text(
                          AppStrings.joinTitle,
                          style: AppTextStyles.authTitle,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.joinSubtitle,
                          style: AppTextStyles.authSubtitle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  // ── Full Name ─────────────────────────────────
                  AppInputField(
                    label: AppStrings.fullName,
                    hint: AppStrings.fullNameHint,
                    controller: _nameController,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter your name' : null,
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // ── Email ─────────────────────────────────────
                  AppInputField(
                    label: AppStrings.emailAddress,
                    hint: AppStrings.emailAddressHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.inputIcon,
                      size: 18,
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter email' : null,
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // ── Phone ─────────────────────────────────────
                  AppInputField(
                    label: AppStrings.phoneNumber,
                    hint: AppStrings.phoneHint,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // ── Location ──────────────────────────────────
                  AppInputField(
                    label: AppStrings.location,
                    hint: AppStrings.locationHint,
                    controller: _locationController,
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // ── Blood Group ───────────────────────────────
                  Text(AppStrings.bloodGroup, style: AppTextStyles.inputLabel),
                  const SizedBox(height: 10),
                  BloodGroupSelector(
                    onSelected: (group) =>
                        setState(() => _selectedBloodGroup = group),
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  // ── Register Button ───────────────────────────
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppPrimaryButton(
                        label: AppStrings.register,
                        isLoading: state is AuthLoading,
                        icon: const Icon(
                          Icons.person_add_outlined,
                          color: AppColors.textWhite,
                          size: 18,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              AuthRegisterSubmitted(
                                fullName: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                phone: _phoneController.text.trim(),
                                location: _locationController.text.trim(),
                                bloodGroup: _selectedBloodGroup,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  // ── Login link ────────────────────────────────
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyAccount,
                          style: AppTextStyles.authLink,
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            AppStrings.login,
                            style: AppTextStyles.authLinkBold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  // ── Map placeholder ───────────────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      color: AppColors.mapOverlay,
                      child: const Center(
                        child: Icon(
                          Icons.map_outlined,
                          color: AppColors.textSecondary,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceLG),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
