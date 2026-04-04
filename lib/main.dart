import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/home/screens/home_dashboard_screen.dart';
import 'package:jibon_daian_app/features/search/screens/search_results_screen.dart';
import 'package:jibon_daian_app/shared/navigation/app_bottom_nav_bar.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'features/blood_request/bloc/blood_request_bloc.dart';
import 'features/blood_request/screens/blood_request_screen.dart';
import 'features/donation_history/bloc/donation_history_bloc.dart';
import 'features/donation_history/screens/donation_history_screen.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/search/bloc/search_bloc.dart';
import 'features/user_profile/bloc/user_profile_bloc.dart';
import 'features/user_profile/screens/user_profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const JibonDaianApp());
}

class JibonDaianApp extends StatelessWidget {
  const JibonDaianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jibon Daian',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  void _goHome() {
    setState(() => _currentIndex = 0);
  }

  // void _onTabTap(int index) {
  //   setState(() => _currentIndex = index);
  // }
  //
  // final List<Widget> _screens = [
  //   const HomeDashboardScreen(), // Index 0: Home
  //   const SearchResultsScreen(), // Index 1: Search
  //   const Center(child: Text("Add Request")), // Index 2: FAB (middle button)
  //   const Center(child: Text("History")), // Index 3: History
  //   const Center(child: Text("Profile")), // Index 4: Profile
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Index 0: Home
          BlocProvider(
            create: (_) => HomeBloc(),
            child: const HomeDashboardScreen(),
          ),

          // Index 1: Search
          BlocProvider(
            create: (_) => SearchBloc(),
            child: SearchResultsScreen(onBackPressed: _goHome),
          ),

          // Index 2: FAB placeholder
          BlocProvider(
            create: (_) => BloodRequestBloc(),
            child: BloodRequestScreen(onBackPressed: _goHome),
          ),

          // Index 3: History placeholder
          BlocProvider(
            create: (_) => DonationHistoryBloc(),
            child: DonationHistoryScreen(onBackPressed: _goHome),
          ),

          // Index 4: Profile placeholder
          BlocProvider(
            create: (_) => UserProfileBloc(),
            child: UserProfileScreen(onBackPressed: _goHome),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
