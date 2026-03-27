import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jibon_daian_app/features/home/screens/home_dashboard_screen.dart';
import 'package:jibon_daian_app/features/search/screens/search_results_screen.dart';
import 'package:jibon_daian_app/shared/navigation/app_bottom_nav_bar.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/search/bloc/search_bloc.dart';

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

  final List<Widget> _screens = [
    const HomeDashboardScreen(), // Index 0: Home
    const SearchResultsScreen(), // Index 1: Search
    const Center(child: Text("Add Request")), // Index 2: FAB (middle button)
    const Center(child: Text("History")), // Index 3: History
    const Center(child: Text("Profile")), // Index 4: Profile
  ];

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
            child: const SearchResultsScreen(),
          ),

          // Index 2: FAB placeholder
          const Center(child: Text('Add Request')),

          // Index 3: History placeholder
          const Center(child: Text('History')),

          // Index 4: Profile placeholder
          const Center(child: Text('Profile')),
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
