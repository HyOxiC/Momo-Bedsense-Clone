import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

/// Main theme configuration for the BedSense app
/// Uses a color scheme similar to the actual app
ThemeData buildAppTheme(Brightness brightness, {ColorScheme? dynamicScheme}) {
  final bool isDark = brightness == Brightness.dark;

  // Base colors
  const brandPrimary = Color(0xFF3EC1CC); // teal, clinical/clean
  const brandSecondary = Color(0xFFB877D9); // purple, complementary accent

  final seeded = ColorScheme.fromSeed(
    seedColor: brandPrimary,
    brightness: brightness,
  );

  // Helper function for smooth color blending used in container theming
  Color mix(Color a, Color b, double t) => Color.fromARGB(
    255,
    (a.red + (b.red - a.red) * t).round(),
    (a.green + (b.green - a.green) * t).round(),
    (a.blue + (b.blue - a.blue) * t).round(),
  );

  final secondaryContainer = isDark
      ? mix(brandSecondary, const Color(0xFF1A1C1E), .6)
      : mix(brandSecondary, Colors.white, .8);

  final colorScheme = (dynamicScheme ?? seeded).copyWith(
    primary: brandPrimary,
    onPrimary: Colors.white,
    secondary: brandSecondary,
    onSecondary: Colors.white,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: isDark ? Colors.white : const Color(0xFF261930),
  );

  final textTheme = GoogleFonts.interTextTheme(
    isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
  );

  final type = TypeTokens(
    titleM: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
    bodyM: textTheme.bodyMedium!,
    labelS: textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w500),
  );

  final glass = GlassTokens(
    radius: 20,
    blurSigma: 25,
    bgAlpha: .15,
    borderAlpha: .3,
    shadowColor: Colors.black.withOpacity(.12),
  );

  final spacing = const SpacingTokens();
  final motion = const MotionTokens();
  final charts = ChartTokens(
    primary: colorScheme.secondary,
    secondary: colorScheme.primary,
    neutral: colorScheme.outlineVariant,
    strokeWidth: 2,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: isDark ? const Color(0xFF0A0B0D) : const Color(0xFFF5F7FA),
    shadowColor: Colors.black12,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
    }),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.secondaryContainer,
      elevation: 8,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(color: selected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(color: selected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant);
      }),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: colorScheme.onSurface,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      indicator: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.secondary, width: 1),
      ),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
    cardTheme: CardTheme(
      color: colorScheme.surface,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    dividerTheme: const DividerThemeData(space: 1, thickness: 1),
    extensions: [type, glass, spacing, motion, charts],
  );
}


