import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:bedsense_clone/src/app/app_router.dart';
import 'package:bedsense_clone/src/app/theme.dart';

/// Entry point for the BedSense app
/// Using Riverpod for state management and GoRouter for navigation
void main() {
  runApp(const ProviderScope(child: AppRoot()));
}

/// Root widget that sets up the app structure
class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'BedSense (Replica)',
      routerConfig: router,
      debugShowCheckedModeBanner: false, // Cleaner look without debug banner
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: ThemeMode.light, // Default to light mode
      builder: (context, child) => ResponsiveBreakpoints.builder(
        // Responsive design for different screen sizes
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 1024, name: TABLET),
          Breakpoint(start: 1025, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
        child: child!,
      ),
    );
  }
}


