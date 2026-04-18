import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_Bachan_app/core/constants/app_routes.dart';
import 'package:jibon_Bachan_app/core/data/repository/token_repository.dart';
import 'package:jibon_Bachan_app/features/auth/bloc/auth_event.dart';
import 'package:jibon_Bachan_app/features/auth/bloc/auth_state.dart';
import 'package:jibon_Bachan_app/shared/widgets/app_snackbar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final TokenRepository _tokenRepository = TokenRepository();
  bool _obscureOld = true;
  bool _obscureNew = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthChangePasswordSuccess) {
          AppSnackbar.show(context, message: state.message);
          Navigator.pop(context);
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
          title: Text(AppStrings.appName, style: AppTextStyles.authRedTitle),
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
                  const SizedBox(height: AppDimens.spaceXXL),

                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.ripple2,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusCircle,
                      ),
                    ),
                    child: const Icon(
                      Icons.lock_reset,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  Text(
                    AppStrings.forgotPasswordTitle,
                    style: AppTextStyles.authTitle.copyWith(fontSize: 22),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    AppStrings.forgotPasswordSubtitle,
                    style: AppTextStyles.authSubtitle,
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  AppInputField(
                    label: "Current Password",
                    hint: "********",
                    controller: _oldPasswordController,
                    obscureText: _obscureOld,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.inputIcon,
                      size: 18,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureOld ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscureOld = !_obscureOld),
                    ),
                    validator: (v) => v!.isEmpty ? 'Enter old password' : null,
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  AppInputField(
                    label: "New Password",
                    hint: "********",
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    validator: (v) => v!.length < 6 ? 'Too short' : null,
                  ),
                  const SizedBox(height: AppDimens.spaceXL),
                  AppInputField(
                    label: "Confirm New Password",
                    hint: "********",
                    controller: _confirmPasswordController,
                    validator: (v) {
                      if (v != _newPasswordController.text)
                        return 'Passwords do not match';
                      return null;
                    },
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppPrimaryButton(
                        label: AppStrings.sendLink,
                        isLoading: state is AuthLoading,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final String? currentUserId = await _tokenRepository
                                .getUserId();

                            print(
                              "--- Attempting to change password for ID: $currentUserId ---",
                            );

                            if (currentUserId != null &&
                                currentUserId.isNotEmpty) {
                              context.read<AuthBloc>().add(
                                AuthChangePasswordSubmitted(
                                  userId: currentUserId,
                                  oldPassword: _oldPasswordController.text,
                                  newPassword: _newPasswordController.text,
                                ),
                              );
                            } else {
                              AppSnackbar.show(
                                context,
                                message:
                                    "User ID not found. Please login again.",
                                isError: true,
                              );
                            }
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        AppStrings.tryAnotherWay,
                        style: AppTextStyles.authLinkBold,
                      ),
                    ),
                  ),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${AppStrings.havingTrouble} ',
                          style: AppTextStyles.authLink,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.contactSupport,
                          ),
                          child: Text(
                            AppStrings.contactSupport,
                            style: AppTextStyles.authLinkBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
