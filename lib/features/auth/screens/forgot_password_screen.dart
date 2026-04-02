import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/core/constants/app_routes.dart';
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
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reset link sent! Check your email.'),
              backgroundColor: AppColors.primary,
            ),
          );
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

                  // ── Icon ──────────────────────────────────────
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

                  // ── Title ─────────────────────────────────────
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

                  // ── Email input ───────────────────────────────
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

                  const SizedBox(height: AppDimens.spaceXL),

                  // ── Send Link Button ──────────────────────────
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppPrimaryButton(
                        label: AppStrings.sendLink,
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              AuthForgotPasswordSubmitted(
                                email: _emailController.text.trim(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  // ── Try another way ───────────────────────────
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        AppStrings.tryAnotherWay,
                        style: AppTextStyles.authLinkBold,
                      ),
                    ),
                  ),

                  // ── Contact Support ───────────────────────────
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
