import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'core/theme/theme_transition.dart';
import 'features/navigation/presentation/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KreedaApp());
}

class KreedaApp extends StatelessWidget {
  const KreedaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          title: 'Kreeda — Cricket Lives Here',
          debugShowCheckedModeBanner: false,
          themeMode: currentThemeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          builder: (context, child) {
            return ThemeTransitionWrapper(
              key: ThemeTransition.wrapperKey,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
