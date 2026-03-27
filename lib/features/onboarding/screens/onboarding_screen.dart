
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/widgets.dart';
import '../bloc/onboarding_bloc.dart';
import '../models/onboarding_page_model.dart';
import '../widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  static const List<OnboardingPage> _pages = [
    OnboardingPage(
      title: AppStrings.saveLivesTitle,
      description: AppStrings.saveLivesDescription,
      imagePath: 'assets/images/onboarding_save_lives.png',
    ),

    OnboardingPage(
      title: AppStrings.beHeroTitle,
      description: AppStrings.beHeroDescription,
      imagePath: 'assets/images/onboarding_be_hero.png',
    ),

    OnboardingPage(
      title: AppStrings.findDonorsTitle,
      description: AppStrings.findDonorsDescription,
      imagePath: 'assets/images/onboarding_find_donors.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigatePage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _navigateToLogin() {

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingPageState) {
          _navigatePage(state.currentPage);
        }
        if (state is OnboardingComplete) {
          _navigateToLogin();
        }
      },
      builder: (context, state) {
        final currentPage = state is OnboardingPageState
            ? state.currentPage
            : 0;
        final isLastPage = currentPage == _pages.length - 1;

        final titleStyle = currentPage == 1 ? 'red' : 'dark';

        return Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          appBar: OnboardingNavBar(
            titleStyle: titleStyle,
            showBackButton: currentPage > 0,
            onBack: () => context.read<OnboardingBloc>().add(
              const OnboardingPreviousPage(),
            ),
            onSkip: () =>
                context.read<OnboardingBloc>().add(const OnboardingSkipped()),
          ),
          body: SafeArea(
            child: Column(
              children: [
                //PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      context.read<OnboardingBloc>().add(
                        OnboardingPageChanged(index),
                      );
                    },
                    itemBuilder: (context, index) {
                      return OnboardingSlideCard(
                        page: _pages[index],
                        pageIndex: index,
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppDimens.spaceLG),

                //  Dot Indicator
                AppDotIndicator(
                  totalDots: _pages.length,
                  currentIndex: currentPage,
                ),

                const SizedBox(height: AppDimens.spaceXL),

                // Button
                // index 0 → "Get Started" → next slide
                // index 1 → "Next"        → next slide
                // index 2 → "Next"        → Home
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.pagePaddingH,
                  ),
                  child: AppPrimaryButton(
                    label: currentPage == 0
                        ? AppStrings.getStarted
                        : AppStrings.next,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.textWhite,
                      size: AppDimens.iconMD,
                    ),
                    onPressed: () {
                      if (isLastPage) {
                        context.read<OnboardingBloc>().add(
                          const OnboardingGetStarted(),
                        );
                      } else {
                        context.read<OnboardingBloc>().add(
                          const OnboardingNextPage(),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: AppDimens.spaceXL),
              ],
            ),
          ),
        );
      },
    );
  }
}
