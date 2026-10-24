import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_transition.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/kreeda_bottom_nav.dart';
import '../../../core/widgets/kreeda_toast.dart';
import '../../home/presentation/screens/home_screen.dart';
import '../../matches/presentation/screens/match_details_screen.dart';
import '../../profile/presentation/screens/player_profile_screen.dart';
import '../../scoring/presentation/screens/scoring_console_screen.dart';
import '../../series/presentation/screens/tournament_details_screen.dart';

/// Main container screen managing IndexedStack tabs, KreedaBottomNav,
/// and robust Android system back navigation flow (PopScope).
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  DateTime? _lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // 1. If currently on a secondary tab (Matches, Scorer, Tournaments, More),
        // smoothly route back to the Home tab (Tab 0) instead of closing the app.
        if (_currentIndex != 0) {
          HapticFeedback.lightImpact();
          setState(() => _currentIndex = 0);
          return;
        }

        // 2. If already on Home tab (0), require double back-tap within 2s to exit safely.
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          HapticFeedback.lightImpact();
          KreedaToast.showInfo(context, 'Press back again to exit Kreeda');
          return;
        }

        // 3. User confirmed intent to exit
        SystemNavigator.pop();
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: ThemeTransition.isNavDarkNotifier,
        builder: (context, isNavDark, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  AppColors.isDark(context) ? Brightness.light : Brightness.dark,
              statusBarBrightness:
                  AppColors.isDark(context) ? Brightness.dark : Brightness.light,
              systemNavigationBarColor:
                  isNavDark ? Colors.black : Colors.white,
              systemNavigationBarIconBrightness:
                  isNavDark ? Brightness.light : Brightness.dark,
              systemNavigationBarDividerColor: Colors.transparent,
              systemNavigationBarContrastEnforced: false,
            ),
            child: child!,
          );
        },
        child: Scaffold(
          backgroundColor: AppColors.background(context),
          appBar: _currentIndex == 0
              ? AppHeader(
                  onProfileTap: () {
                    setState(() => _currentIndex = 4);
                  },
                )
              : null,
          body: Stack(
            children: [
              IndexedStack(
                index: _currentIndex,
                children: const [
                  HomeScreen(),
                  MatchDetailsScreen(),
                  ScoringConsoleScreen(),
                  TournamentDetailsScreen(),
                  PlayerProfileScreen(),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: KreedaBottomNav(
                  selectedIndex: _currentIndex,
                  onTabSelected: (index) {
                    setState(() => _currentIndex = index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
