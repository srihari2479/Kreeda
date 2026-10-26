import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kreeda/core/theme/app_colors.dart';
import 'package:kreeda/core/theme/app_theme.dart';
import 'package:kreeda/core/theme/theme_notifier.dart';
import 'package:kreeda/core/theme/theme_transition.dart';
import 'package:kreeda/core/widgets/app_logo.dart';
import 'package:kreeda/core/widgets/hero_match_card.dart';
import 'package:kreeda/core/widgets/kreeda_bottom_nav.dart';
import 'package:kreeda/core/widgets/kreeda_toast.dart';
import 'package:kreeda/core/widgets/section_divider_title.dart';
import 'package:kreeda/features/auth/presentation/screens/login_screen.dart';
import 'package:kreeda/features/auth/presentation/screens/signup_screen.dart';
import 'package:kreeda/features/auth/presentation/widgets/otp_verification_sheet.dart';
import 'package:kreeda/features/home/presentation/screens/home_screen.dart';
import 'package:kreeda/features/matches/presentation/screens/match_details_screen.dart';
import 'package:kreeda/features/navigation/presentation/main_navigation_screen.dart';
import 'package:kreeda/features/profile/presentation/screens/player_profile_screen.dart';
import 'package:kreeda/features/series/presentation/screens/tournament_details_screen.dart';
import 'package:kreeda/main.dart';

void main() {
  testWidgets('Kreeda app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KreedaApp());
    expect(find.byType(MainNavigationScreen), findsOneWidget);
    expect(find.textContaining('ATBPL'), findsWidgets);
  });

  testWidgets('LoginScreen renders and switches modes without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const LoginScreen(),
      ),
    );

    // Verify Title and initial Phone OTP mode
    expect(find.text('WELCOME TO'), findsOneWidget);
    expect(find.byType(AppLogo), findsOneWidget);
    expect(find.text('PHONE OTP'), findsOneWidget);
    expect(find.text('EMAIL & PASSWORD'), findsOneWidget);
    expect(find.text('GET OTP VIA SMS'), findsOneWidget);

    // Tap EMAIL & PASSWORD tab
    await tester.tap(find.text('EMAIL & PASSWORD'));
    await tester.pumpAndSettle();

    // Verify Email mode inputs are rendered
    expect(find.text('LOG IN TO KREEDA'), findsOneWidget);
    expect(find.text('FORGOT PASSWORD?'), findsOneWidget);

    // Switch back to Phone OTP
    await tester.tap(find.text('PHONE OTP'));
    await tester.pumpAndSettle();
    expect(find.text('GET OTP VIA SMS'), findsOneWidget);
  });

  testWidgets('SignupScreen renders role and style selectors cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const SignupScreen(),
      ),
    );

    // Verify Title
    expect(find.text('BUILD CRICKETER RESUME'), findsOneWidget);

    // Verify CricHeroes style roles exist
    expect(find.text('Top-Order Batter'), findsOneWidget);
    expect(find.text('Fast Bowler'), findsOneWidget);
    expect(find.text('Spin Bowler'), findsOneWidget);
    expect(find.text('All-Rounder'), findsOneWidget);

    // Verify Batting style toggle exists
    expect(find.text('RIGHT-HAND BAT 🏏'), findsOneWidget);
    expect(find.text('LEFT-HAND BAT 🏏'), findsOneWidget);

    // Ensure Left Hand Bat is visible and tap
    await tester.ensureVisible(find.text('LEFT-HAND BAT 🏏'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('LEFT-HAND BAT 🏏'));
    await tester.pumpAndSettle();

    // Verify Bowling Styles
    expect(find.text('Right-Arm Fast'), findsOneWidget);
    expect(find.text('Right-Arm Spin'), findsOneWidget);

    // Verify Submit CTA
    expect(find.text('REGISTER & VERIFY VIA OTP'), findsOneWidget);
  });

  testWidgets('HomeScreen renders with zero overflow on smallest width 360dp mobile', (WidgetTester tester) async {
    // Strictly simulate 360dp mobile viewport
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Hero Match Card matches screenshot
    expect(find.text('ATBPL T10 • LEAGUE STAGE'), findsOneWidget);
    expect(find.textContaining('KNIGHT RIDERS'), findsWidgets);
    expect(find.textContaining('STRIKERS'), findsWidgets);
    expect(find.text('Watch Live'), findsOneWidget);

    // Swipe to 2nd Hero banner (Coastal Riders vs Vizag Strikers)
    await tester.drag(find.byType(PageView).first, const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(find.textContaining('COASTAL'), findsWidgets);

    // Swipe to 3rd Hero banner (Godavari Kings vs Rayalaseema Royals)
    await tester.drag(find.byType(PageView).first, const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(find.textContaining('GODAVARI'), findsWidgets);

    // Verify 3 Quick Navigation Cards
    expect(find.text('Live Matches'), findsOneWidget);
    expect(find.text('Tournaments'), findsWidgets);
    expect(find.text('My Team'), findsOneWidget);

    // Verify Section Headers
    expect(find.text('Upcoming Matches'), findsOneWidget);
    expect(find.text('All 8 ATBPL Teams'), findsOneWidget);
    expect(find.text('Latest Highlights'), findsOneWidget);
    expect(find.text('Featured'), findsOneWidget);

    // Tap on Telugu Knight Riders team avatar to test modal
    await tester.tap(find.text('Telugu Knight Riders').first);
    await tester.pumpAndSettle();

    // Verify team modal pops up
    expect(find.text('FRANCHISE DETAILS'), findsOneWidget);
    expect(find.textContaining('Deccan Sports Ventures'), findsOneWidget);

    // Dismiss bottom sheet
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
  });

  testWidgets('TournamentDetailsScreen 6 tabs render cleanly on 360dp mobile', (WidgetTester tester) async {
    // Strictly simulate 360dp mobile viewport
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const TournamentDetailsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Hero Tournament Showcase
    expect(find.text('ATBPL T10 - LEAGUE STAGE'), findsOneWidget);
    expect(find.text('8 TEAMS'), findsOneWidget);
    expect(find.text('28 MATCHES'), findsOneWidget);

    // Verify 6 Tabs exist
    expect(find.text('OVERVIEW'), findsOneWidget);
    expect(find.text('FIXTURES'), findsOneWidget);
    expect(find.text('POINTS TABLE'), findsOneWidget);
    expect(find.text('ALL 8 TEAMS'), findsOneWidget);
    expect(find.text('LEADERBOARD'), findsOneWidget);
    expect(find.text('VENUES & RULES'), findsOneWidget);

    // Switch to POINTS TABLE tab
    await tester.tap(find.text('POINTS TABLE'));
    await tester.pumpAndSettle();

    // Verify CricHeroes style Points Table
    expect(find.text('#'), findsWidgets);
    expect(find.text('TEAM'), findsOneWidget);
    expect(find.text('NRR'), findsOneWidget);
    expect(find.text('PTS'), findsOneWidget);
    expect(find.text('TKR'), findsOneWidget);
    expect(find.text('TS'), findsOneWidget);

    // Switch to ALL 8 TEAMS tab
    await tester.tap(find.text('ALL 8 TEAMS'));
    await tester.pumpAndSettle();

    expect(find.text('Telugu Knight Riders'), findsOneWidget);
    expect(find.text('Telugu Strikers'), findsOneWidget);
    expect(find.text('Coastal Riders'), findsOneWidget);

    // Switch to LEADERBOARD tab
    await tester.tap(find.text('LEADERBOARD'));
    await tester.pumpAndSettle();

    expect(find.text('ORANGE CAP (MOST RUNS)'), findsOneWidget);
    expect(find.text('PURPLE CAP (MOST WICKETS)'), findsOneWidget);
  });

  testWidgets('MainNavigationScreen 5 tabs and Create sheet work on 360dp', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MainNavigationScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify header tournament dropdown and circular action buttons matching Image 1
    expect(find.textContaining('ATBPL'), findsWidgets);
    expect(find.byTooltip('Toggle Theme'), findsOneWidget);
    expect(find.byTooltip('Notifications'), findsOneWidget);
    expect(find.byTooltip('Profile & Cricket Resume'), findsOneWidget);

    // Verify tapping theme toggle in header works smoothly
    await tester.tap(find.byTooltip('Toggle Theme'));
    await tester.pumpAndSettle();

    // Verify KreedaBottomNav tabs
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Matches'), findsOneWidget);
    expect(find.byTooltip('Create'), findsOneWidget);
    expect(find.text('Tournaments'), findsWidgets);
    expect(find.text('My Cricket'), findsOneWidget);

    // Tap center Create button
    await tester.tap(find.byTooltip('Create'));
    await tester.pumpAndSettle();

    // Verify CricHeroes create sheet
    expect(find.text('CREATE & SCORE'), findsOneWidget);
    expect(find.text('Live Scorer Console'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Create Tournament'), findsOneWidget);
    expect(find.text('Register New Team'), findsOneWidget);
  });

  testWidgets('MatchDetailsScreen scrollable tabs and Wagon Wheel render without truncation on 360dp', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MatchDetailsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Match Center App Bar & Scorer button
    expect(find.text('MATCH CENTER'), findsOneWidget);
    expect(find.text('SCORER'), findsOneWidget);

    // Verify 4 Full Tab Titles (not truncated as SUMMA, SCOREC, etc.)
    expect(find.text('SUMMARY'), findsOneWidget);
    expect(find.text('SCORECARD'), findsOneWidget);
    expect(find.text('COMMENTARY'), findsOneWidget);
    expect(find.text('WAGON WHEEL'), findsOneWidget);

    // Switch to WAGON WHEEL tab
    await tester.ensureVisible(find.text('WAGON WHEEL'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('WAGON WHEEL'));
    await tester.pumpAndSettle();

    // Verify Wagon Wheel title & filter chips
    expect(find.text('VIRAT KOHLI — WAGON WHEEL (68 RUNS)'), findsOneWidget);
    expect(find.text('All Shots'), findsOneWidget);
    expect(find.text('Boundaries'), findsOneWidget);
    expect(find.text('Off Side'), findsOneWidget);
    expect(find.text('Leg Side'), findsOneWidget);
  });

  testWidgets('PlayerProfileScreen career metrics and account actions render cleanly on 360dp mobile', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const PlayerProfileScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Hero Header
    expect(find.text('CRICKETER RESUME'), findsOneWidget);
    expect(find.text('VIRAT KOHLI'), findsOneWidget);

    // Verify 4 Career Metric Cards
    expect(find.text('MATCHES'), findsOneWidget);
    expect(find.text('TOTAL RUNS'), findsOneWidget);
    expect(find.text('BATTING AVG'), findsOneWidget);
    expect(find.text('100s / 50s'), findsOneWidget);

    // Verify 3D Awards Section
    expect(find.text('AWARDS & RECOGNITION'), findsOneWidget);
    expect(find.text('ICC Player of the Decade'), findsOneWidget);
    expect(find.text('2x ICC ODI Player of the Year'), findsOneWidget);
    expect(find.text('Most Centuries in ODI Cricket'), findsOneWidget);
    expect(find.text('Padma Shri & Khel Ratna'), findsOneWidget);

    // Verify Account & Authentication action buttons
    expect(find.text('ACCOUNT & AUTHENTICATION'), findsOneWidget);
    expect(find.text('LOG IN / SWITCH'), findsOneWidget);
    expect(find.text('NEW RESUME'), findsOneWidget);
  });

  testWidgets('ThemeTransition synchronizes system navigation bar state without jiggle or overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    themeNotifier.setThemeMode(ThemeMode.light);
    ThemeTransition.isNavDarkNotifier.value = false;

    await tester.pumpWidget(const KreedaApp());
    await tester.pumpAndSettle();

    // Initial theme should be light, isNavDarkNotifier should match
    expect(themeNotifier.value, ThemeMode.light);
    expect(ThemeTransition.isNavDarkNotifier.value, false);

    // Find and tap the theme mode toggle icon in AppHeader
    final toggleFinder = find.byTooltip('Toggle Theme');
    expect(toggleFinder, findsOneWidget);

    await tester.tap(toggleFinder);
    await tester.pump(const Duration(milliseconds: 100));

    // Underlying themeNotifier changes to dark for background render
    expect(themeNotifier.value, ThemeMode.dark);

    // Let animation run to completion (1400ms duration)
    await tester.pumpAndSettle();

    // Final navigation bar state should be dark
    expect(ThemeTransition.isNavDarkNotifier.value, true);

    // Toggle back to light mode
    await tester.tap(toggleFinder);
    await tester.pumpAndSettle();

    expect(themeNotifier.value, ThemeMode.light);
    expect(ThemeTransition.isNavDarkNotifier.value, false);
  });

  testWidgets('KreedaBottomNav dual-island floating bar renders, switches tabs with bounce, and activates Create FAB', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    int selectedTab = 0;
    bool createTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: const Center(child: Text('Content')),
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return KreedaBottomNav(
                selectedIndex: selectedTab,
                onTabSelected: (index) {
                  setState(() => selectedTab = index);
                },
                onCreateTap: () {
                  createTapped = true;
                },
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all 4 capsule dock tabs & 1 standalone FAB exist
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Matches'), findsOneWidget);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('Tournaments'), findsOneWidget);
    expect(find.text('My Cricket'), findsOneWidget);
    expect(find.byTooltip('Create'), findsOneWidget);

    // Switch to Matches tab (index 1)
    await tester.tap(find.text('Matches'));
    await tester.pump();
    // Verify bounce animation is running
    await tester.pump(const Duration(milliseconds: 160));
    await tester.pumpAndSettle();
    expect(selectedTab, 1);

    // Switch to Tournaments tab (index 3)
    await tester.tap(find.text('Tournaments'));
    await tester.pumpAndSettle();
    expect(selectedTab, 3);

    // Switch to My Cricket tab (index 4)
    await tester.tap(find.text('My Cricket'));
    await tester.pumpAndSettle();
    expect(selectedTab, 4);

    // Tap Standalone Floating Create Button
    await tester.tap(find.byTooltip('Create'));
    await tester.pumpAndSettle();
    expect(createTapped, true);
  });

  testWidgets('SectionDividerTitle auto-formats titles in ----- TITLE ----- style', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: Column(
            children: [
              SectionDividerTitle(title: 'tournament specifications'),
              SectionDividerTitle.dashed(title: 't10 tournament playing regulations'),
              SectionDividerTitle(title: 'host venue & stadium'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify auto uppercase formatting and flanking
    expect(find.text('TOURNAMENT SPECIFICATIONS'), findsOneWidget);
    expect(find.text('T10 TOURNAMENT PLAYING REGULATIONS'), findsOneWidget);
    expect(find.text('HOST VENUE & STADIUM'), findsOneWidget);
    expect(find.byType(SectionDividerTitle), findsNWidgets(3));
  });

  testWidgets('KreedaToast renders in light theme with white bg, green border, and no shadow', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              return ElevatedButton(
                onPressed: () => KreedaToast.showSuccess(ctx, 'No new notifications'),
                child: const Text('Show Toast'),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Trigger Toast
    await tester.tap(find.text('Show Toast'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('No new notifications'), findsOneWidget);

    // Verify Container styling in Light Theme: white background, green border, no shadow
    final containerFinder = find.ancestor(
      of: find.text('No new notifications'),
      matching: find.byType(Container),
    ).first;
    final container = tester.widget<Container>(containerFinder);
    final decoration = container.decoration as BoxDecoration;

    expect(decoration.color, Colors.white);
    expect(decoration.boxShadow, isNull);
    expect(decoration.border?.top.color, AppColors.pitchGreen);

    // Pump past dismiss duration
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('KreedaToast preserves dark surface and neumorphic shadow in dark theme', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              return ElevatedButton(
                onPressed: () => KreedaToast.showSuccess(ctx, 'Match starting soon'),
                child: const Text('Show Toast Dark'),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Show Toast Dark'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Match starting soon'), findsOneWidget);

    final containerFinder = find.ancestor(
      of: find.text('Match starting soon'),
      matching: find.byType(Container),
    ).first;
    final container = tester.widget<Container>(containerFinder);
    final decoration = container.decoration as BoxDecoration;

    // Dark Theme: dark surface, has shadows
    expect(decoration.color, AppColors.surfaceDark);
    expect(decoration.boxShadow, isNotNull);
    expect(decoration.boxShadow!.isNotEmpty, isTrue);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('HeroMatchCard adapts typography and colors between light and dark themes', (WidgetTester tester) async {
    // 1. Test Light Theme
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: HeroMatchCard(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ATBPL T10 • LEAGUE STAGE'), findsOneWidget);
    expect(find.text('86/4'), findsOneWidget);
    expect(find.text('102/8'), findsOneWidget);

    final lightScoreText = tester.widget<Text>(find.text('86/4'));
    expect(lightScoreText.style?.color, AppColors.textPrimaryLight);

    // 2. Test Dark Theme
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: HeroMatchCard(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ATBPL T10 • LEAGUE STAGE'), findsOneWidget);
    final darkScoreText = tester.widget<Text>(find.text('86/4'));
    expect(darkScoreText.style?.color, Colors.white);
  });

  testWidgets('OtpVerificationSheet elevates above keyboard without overflow on compact 360dp mobile', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3.0;
    // Simulate keyboard open (300dp keyboard = 900 physical pixels)
    tester.view.viewInsets = const FakeViewPadding(bottom: 300 * 3);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetViewInsets();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => OtpVerificationSheet.show(
                  context,
                  phoneNumber: '+91 999799494499',
                  onVerified: () {},
                ),
                child: const Text('OPEN OTP'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('OPEN OTP'));
    await tester.pumpAndSettle();

    // Verify all contents render and are visible above keyboard
    expect(find.text('VERIFY PHONE NUMBER'), findsOneWidget);
    expect(find.byType(OtpVerificationSheet), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(6));
    expect(find.text('VERIFY & CONTINUE'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

