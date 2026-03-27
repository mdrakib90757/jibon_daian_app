import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/core/constants/app_routes.dart';
import 'package:jibon_daian_app/features/auth/bloc/auth_bloc.dart';
import 'package:jibon_daian_app/features/auth/screens/forgot_password_screen.dart';
import 'package:jibon_daian_app/features/auth/screens/login_screen.dart';
import 'package:jibon_daian_app/features/auth/screens/register_screen.dart';
import 'package:jibon_daian_app/features/home/bloc/home_bloc.dart';
import 'package:jibon_daian_app/features/home/screens/home_dashboard_screen.dart';
import 'package:jibon_daian_app/features/home/screens/home_screen.dart';
import 'package:jibon_daian_app/features/notifications/bloc/notifications_bloc.dart';
import 'package:jibon_daian_app/features/notifications/screens/notifications_screen.dart';
import 'package:jibon_daian_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:jibon_daian_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:jibon_daian_app/features/search/screens/search_results_screen.dart';
import 'package:jibon_daian_app/features/splash/bloc/splash_bloc.dart';
import 'package:jibon_daian_app/features/splash/screens/splash_screen.dart';
import 'package:jibon_daian_app/main.dart';

import '../../features/search/bloc/search_bloc.dart';

/// AppRouter - Centralized route generation
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SplashBloc(),
            child: const SplashScreen(),
          ),
        );

      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OnboardingBloc(totalPages: 3),
            child: const OnboardingScreen(),
          ),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AuthBloc(),
            child: const LoginScreen(),
          ),
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AuthBloc(),
            child: const RegisterScreen(),
          ),
        );

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AuthBloc(),
            child: const ForgotPasswordScreen(),
          ),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => HomeBloc(),
            child: const MainScreen(),
          ),
        );

      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => NotificationsBloc(),
            child: const NotificationsScreen(),
          ),
        );

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SearchBloc(),
            child: const SearchResultsScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
