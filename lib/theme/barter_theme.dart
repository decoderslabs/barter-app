import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'barter_colors.dart';

ThemeData buildBarterLightTheme() {
  const bc = BarterColors.light;
  final baseText = GoogleFonts.interTextTheme();
  final textTheme = baseText.copyWith(
    // Display Large — 48px w900, Hero editorial headlines
    displayLarge: GoogleFonts.inter(
      fontSize: 48,
      fontWeight: FontWeight.w900,
      height: 1.1,
      letterSpacing: -0.02 * 48,
      color: bc.onBackground,
    ),
    // Display Medium — Headline Bold — 32px w700, Section headers
    displayMedium: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.01 * 32,
      color: bc.onSurface,
    ),
    // Display Small — KPI Large — 36px w800, Barter Score / big metrics
    displaySmall: GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      height: 1.0,
      letterSpacing: -0.02 * 36,
      color: bc.onSurface,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.01 * 32,
      color: bc.onSurface,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: bc.onSurface,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.3,
      color: bc.onSurface,
    ),
    // Title Large — 20px w600, Sub-sections, card titles
    titleLarge: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: bc.onSurface,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: bc.onSurface,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: bc.onSurface,
    ),
    // Body Medium — 16px w400, Standard body copy
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: bc.onSurface,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: bc.onSurface,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: bc.onSurfaceVariant,
    ),
    // Label Bold — 12px w700 ls:0.05em, All-caps labels, stats
    labelLarge: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.6,
      color: bc.onSurfaceVariant,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: bc.onSurfaceVariant,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.6,
      color: bc.onSurfaceVariant,
    ),
  );

  final colorScheme = ColorScheme.light(
    primary: bc.primary,
    onPrimary: bc.onPrimary,
    primaryContainer: bc.primaryContainer,
    onPrimaryContainer: bc.onPrimary,
    secondary: bc.secondary,
    onSecondary: bc.onSecondary,
    secondaryContainer: bc.secondaryContainer,
    onSecondaryContainer: bc.onSurface,
    tertiary: bc.tertiary,
    onTertiary: bc.onTertiary,
    tertiaryContainer: bc.tertiaryContainer,
    onTertiaryContainer: bc.onTertiaryContainer,
    error: bc.error,
    onError: bc.onError,
    surface: bc.surface,
    onSurface: bc.onSurface,
    surfaceContainerHighest: bc.surfaceContainerHighest,
    surfaceContainerHigh: bc.surfaceContainerHigh,
    surfaceContainer: bc.surfaceContainer,
    surfaceContainerLow: bc.surfaceContainerLow,
    surfaceContainerLowest: bc.surfaceContainerLowest,
    onSurfaceVariant: bc.onSurfaceVariant,
    outline: bc.outline,
    outlineVariant: bc.outlineVariant,
  );

  const _r12 = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)));
  const _r24 = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24)));

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: bc.background,
    extensions: const [BarterColors.light],
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: bc.background.withValues(alpha: 0.92),
      foregroundColor: bc.onSurface,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        color: bc.primary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bc.primary,
        foregroundColor: bc.onPrimary,
        elevation: 0,
        shape: _r12,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: bc.primary,
        foregroundColor: bc.onPrimary,
        elevation: 0,
        shape: _r12,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.4),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: bc.primary,
        side: BorderSide(color: bc.primary, width: 1),
        shape: _r12,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: bc.primary,
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: bc.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      color: bc.surfaceContainerLow,
      elevation: 0,
      shape: _r24,
      margin: EdgeInsets.zero,
      shadowColor: bc.onBackground.withValues(alpha: 0.04),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bc.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: bc.primary.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: bc.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: bc.outlineVariant.withValues(alpha: 0.15),
      thickness: 1,
    ),
  );
}
