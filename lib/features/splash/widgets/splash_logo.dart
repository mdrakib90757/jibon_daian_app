import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';

/// SplashLogo - Animated concentric circle blood drop logo
class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: SizedBox(
        width: AppDimens.splashLogoOuter,
        height: AppDimens.splashLogoOuter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outermost ripple
            Container(
              width: AppDimens.splashLogoOuter,
              height: AppDimens.splashLogoOuter,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.ripple3,
              ),
            ),
            // Middle ripple
            Container(
              width: AppDimens.splashLogoMid,
              height: AppDimens.splashLogoMid,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.ripple2,
              ),
            ),
            // Core circle
            Container(
              width: AppDimens.splashLogoInner,
              height: AppDimens.splashLogoInner,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Center(
                child: _BloodDropIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Blood drop SVG-style icon painted with CustomPainter
class _BloodDropIcon extends StatelessWidget {
  const _BloodDropIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.water_drop,
      color: Colors.white,
      size: AppDimens.splashDropSize,
    );
  }
}
