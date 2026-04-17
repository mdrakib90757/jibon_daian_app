import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_Bachan_app/features/auth/bloc/auth_event.dart';
import 'package:jibon_Bachan_app/features/auth/bloc/auth_state.dart';
import 'package:jibon_Bachan_app/shared/widgets/app_snackbar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          AppSnackbar.show(context, message: "Welcome Back!");
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
        if (state is AuthFailure) {
          AppSnackbar.show(context, message: state.message, isError: true);
        }
        if (state is AuthPasswordVisibilityChanged) {
          setState(() => _isPasswordVisible = state.isVisible);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePaddingH,
              vertical: AppDimens.pagePaddingV,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppDimens.spaceXL),

                  // logo
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.ripple2,
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // App Name
                  Text(AppStrings.appName, style: AppTextStyles.authRedTitle),

                  const SizedBox(height: AppDimens.spaceXXL),

                  // Heart illustration placeholder
                  // Container(
                  //   width: double.infinity,
                  //   height: 140,
                  //   decoration: BoxDecoration(
                  //     color: AppColors.ripple3,
                  //     borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                  //   ),
                  //   child: const Center(
                  //     child: Icon(
                  //       Icons.favorite,
                  //       color: AppColors.primary,
                  //       size: 80,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: AppDimens.spaceLG),

                  // Title
                  Text(AppStrings.welcomeBack, style: AppTextStyles.authTitle),
                  const SizedBox(height: 6),
                  Text(
                    AppStrings.loginSubtitle,
                    style: AppTextStyles.authSubtitle,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  // ── Email ─────────────────────────────────────
                  AppInputField(
                    label: AppStrings.email,
                    hint: AppStrings.emailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.inputIcon,
                      size: 18,
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter email' : null,
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // ── Password ──────────────────────────────────
                  AppInputField(
                    label: AppStrings.password,
                    hint: AppStrings.passwordHint,
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.inputIcon,
                      size: 18,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => context.read<AuthBloc>().add(
                        const AuthPasswordVisibilityToggled(),
                      ),
                      child: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.inputIcon,
                        size: 18,
                      ),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter password' : null,
                  ),

                  // ── Forgot Password ───────────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.forgotPassword,
                      ),
                      child: Text(
                        AppStrings.forgotPassword,
                        style: AppTextStyles.forgotPasswordText,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // ── Login Button ──────────────────────────────
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppPrimaryButton(
                        label: AppStrings.login,
                        isLoading: state is AuthLoading,
                        icon: const Icon(
                          Icons.login,
                          color: AppColors.textWhite,
                          size: 18,
                        ),
                        onPressed: _handleLogin,
                      );
                    },
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  // ── OR divider ────────────────────────────────
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.divider)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          AppStrings.orContinueWith,
                          style: AppTextStyles.orDivider,
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.divider)),
                    ],
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  // ── Social Buttons ────────────────────────────
                  Row(
                    children: [
                      SocialButton(
                        label: AppStrings.google,
                        icon: const Icon(
                          Icons.g_mobiledata,
                          color: Colors.red,
                          size: 22,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 12),
                      SocialButton(
                        label: AppStrings.facebook,
                        icon: const Icon(
                          Icons.facebook,
                          color: Colors.blue,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  // ── Sign Up link ──────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.noAccount, style: AppTextStyles.authLink),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.register),
                        child: Text(
                          AppStrings.signUp,
                          style: AppTextStyles.authLinkBold,
                        ),
                      ),
                    ],
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
