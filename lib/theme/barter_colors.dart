import 'package:flutter/material.dart';

/// Material / Stitch token palette from HTML exports (e.g. creator_home_feed).
@immutable
class BarterColors extends ThemeExtension<BarterColors> {
  const BarterColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixed,
    required this.onPrimaryFixedVariant,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.surfaceDim,
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color surfaceDim;
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;

  static const BarterColors light = BarterColors(
    primary: Color(0xFFB3193D),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD63653),
    primaryFixed: Color(0xFFFFDADB),
    primaryFixedDim: Color(0xFFFFB2B7),
    onPrimaryFixed: Color(0xFF40000E),
    onPrimaryFixedVariant: Color(0xFF91002B),
    background: Color(0xFFFCF8FF),
    onBackground: Color(0xFF1A1A2E),
    surface: Color(0xFFFCF8FF),
    onSurface: Color(0xFF1A1A2E),
    onSurfaceVariant: Color(0xFF5A4042),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF5F2FF),
    surfaceContainer: Color(0xFFEFECFF),
    surfaceContainerHigh: Color(0xFFE8E5FF),
    surfaceContainerHighest: Color(0xFFE2E0FC),
    surfaceVariant: Color(0xFFE2E0FC),
    outline: Color(0xFF8E7071),
    outlineVariant: Color(0xFFE2BEBF),
    secondary: Color(0xFF0F3460),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE2E0FC),
    tertiary: Color(0xFF3E5D8B),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF5776A5),
    onTertiaryContainer: Color(0xFFFEFCFF),
    error: Color(0xFFB3193D),
    onError: Color(0xFFFFFFFF),
    inverseSurface: Color(0xFF2F2E43),
    inverseOnSurface: Color(0xFFF2EFFF),
    surfaceDim: Color(0xFFDAD7F3),
    success: Color(0xFF1A5E3A),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFF92400E),
    onWarning: Color(0xFFFFFFFF),
  );

  /// Splash / marketing accent (Stitch splash uses brand red).
  static const Color splashBrandRed = Color(0xFFE94560);

  Color editorialShadowTint([double opacity = 0.06]) =>
      onBackground.withValues(alpha: opacity);

  BoxShadow editorialShadow({
    double opacity = 0.04,
    double blur = 20,
    double offset = 4,
  }) =>
      BoxShadow(
        color: onBackground.withValues(alpha: opacity),
        blurRadius: blur,
        offset: Offset(0, offset),
      );

  @override
  BarterColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? surfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? error,
    Color? onError,
    Color? inverseSurface,
    Color? inverseOnSurface,
    Color? surfaceDim,
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
  }) {
    return BarterColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      primaryFixed: primaryFixed ?? this.primaryFixed,
      primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      onPrimaryFixedVariant:
          onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh:
          surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      inverseOnSurface: inverseOnSurface ?? this.inverseOnSurface,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
    );
  }

  @override
  BarterColors lerp(ThemeExtension<BarterColors>? other, double t) {
    if (other is! BarterColors) return this;
    return BarterColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      primaryFixed: Color.lerp(primaryFixed, other.primaryFixed, t)!,
      primaryFixedDim:
          Color.lerp(primaryFixedDim, other.primaryFixedDim, t)!,
      onPrimaryFixed:
          Color.lerp(onPrimaryFixed, other.onPrimaryFixed, t)!,
      onPrimaryFixedVariant:
          Color.lerp(onPrimaryFixedVariant, other.onPrimaryFixedVariant, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant:
          Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      surfaceContainerLowest:
          Color.lerp(surfaceContainerLowest, other.surfaceContainerLowest, t)!,
      surfaceContainerLow:
          Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainer:
          Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh:
          Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest:
          Color.lerp(surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      secondaryContainer:
          Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      tertiaryContainer:
          Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
      onTertiaryContainer:
          Color.lerp(onTertiaryContainer, other.onTertiaryContainer, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      inverseOnSurface:
          Color.lerp(inverseOnSurface, other.inverseOnSurface, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
    );
  }
}

extension BarterColorsX on BuildContext {
  BarterColors get barter => Theme.of(this).extension<BarterColors>()!;
}
