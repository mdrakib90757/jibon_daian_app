import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../bloc/splash_bloc.dart';
import '../widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const SplashStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToOnboarding) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              // ── Top Bar ─────────────────────────────────────
              Positioned(
                top: AppDimens.spaceMD,
                left: AppDimens.pagePaddingH,
                right: AppDimens.pagePaddingH,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.menu, color: AppColors.textPrimary),
                    const Icon(
                      Icons.notifications,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),

              // ── Main Content ─────────────────────────────────
              Column(
                children: [
                  // Logo area - takes most of the screen
                  Expanded(
                    flex: 6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SplashLogo(),
                          const SizedBox(height: AppDimens.spaceXXL),
                          Text(
                            AppStrings.appName,
                            style: AppTextStyles.appName,
                          ),
                          const SizedBox(height: AppDimens.spaceXS),
                          Text(
                            AppStrings.appTagline,
                            style: AppTextStyles.appTagline,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Progress bar area
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.pagePaddingH,
                      ),
                      child: BlocBuilder<SplashBloc, SplashState>(
                        builder: (context, state) {
                          final progress =
                              state is SplashLoading ? state.progress : 0.0;
                          return SplashProgressBar(
                            progress: progress,
                            label: AppStrings.splashLoading,
                          );
                        },
                      ),
                    ),
                  ),

                  // Bottom area with dots and network text
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Dot indicator (first dot active on splash)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDot(true),
                            const SizedBox(width: 8),
                            _buildDot(false),
                            const SizedBox(width: 8),
                            _buildDot(false),
                          ],
                        ),
                        const SizedBox(height: AppDimens.spaceLG),
                        Text(
                          AppStrings.appNetwork,
                          style: AppTextStyles.networkCaption,
                        ),
                        const SizedBox(height: AppDimens.spaceLG),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? AppDimens.dotWidth : AppDimens.dotInactiveSize,
      height: AppDimens.dotHeight,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.progressInactive,
        borderRadius: BorderRadius.circular(AppDimens.dotRadius),
      ),
    );
  }
}
