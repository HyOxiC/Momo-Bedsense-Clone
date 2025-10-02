import 'package:flutter/material.dart';

/// Design tokens for consistent spacing throughout the app
/// Prefer centralized tokens over hardcoded values for consistency
@immutable
class SpacingTokens extends ThemeExtension<SpacingTokens> {
  const SpacingTokens({this.xs = 4, this.sm = 8, this.md = 12, this.lg = 16, this.xl = 24});
  final double xs; final double sm; final double md; final double lg; final double xl;
  @override
  SpacingTokens copyWith({double? xs, double? sm, double? md, double? lg, double? xl}) => SpacingTokens(
    xs: xs ?? this.xs, sm: sm ?? this.sm, md: md ?? this.md, lg: lg ?? this.lg, xl: xl ?? this.xl,
  );
  @override
  ThemeExtension<SpacingTokens> lerp(ThemeExtension<SpacingTokens>? other, double t) => this;
}

/// Glass morphism effect tokens - these values took some tweaking to get right
@immutable
class GlassTokens extends ThemeExtension<GlassTokens> {
  const GlassTokens({
    this.radius = 18,
    this.blurSigma = 18,
    this.bgAlpha = .32,
    this.borderAlpha = .65,
    this.shadowColor,
  });
  final double radius; final double blurSigma; final double bgAlpha; final double borderAlpha; final Color? shadowColor;
  @override
  GlassTokens copyWith({double? radius, double? blurSigma, double? bgAlpha, double? borderAlpha, Color? shadowColor}) => GlassTokens(
    radius: radius ?? this.radius,
    blurSigma: blurSigma ?? this.blurSigma,
    bgAlpha: bgAlpha ?? this.bgAlpha,
    borderAlpha: borderAlpha ?? this.borderAlpha,
    shadowColor: shadowColor ?? this.shadowColor,
  );
  @override
  ThemeExtension<GlassTokens> lerp(ThemeExtension<GlassTokens>? other, double t) => this;
}

@immutable
class TypeTokens extends ThemeExtension<TypeTokens> {
  const TypeTokens({required this.titleM, required this.bodyM, required this.labelS});
  final TextStyle titleM; final TextStyle bodyM; final TextStyle labelS;
  @override
  ThemeExtension<TypeTokens> lerp(ThemeExtension<TypeTokens>? other, double t) => this;
  @override
  TypeTokens copyWith({TextStyle? titleM, TextStyle? bodyM, TextStyle? labelS}) => TypeTokens(
    titleM: titleM ?? this.titleM,
    bodyM: bodyM ?? this.bodyM,
    labelS: labelS ?? this.labelS,
  );
}

@immutable
class MotionTokens extends ThemeExtension<MotionTokens> {
  const MotionTokens({
    this.fast = const Duration(milliseconds: 120),
    this.regular = const Duration(milliseconds: 220),
    this.slow = const Duration(milliseconds: 360),
    this.emphasized = Curves.easeInOutCubicEmphasized,
  });
  final Duration fast; final Duration regular; final Duration slow; final Curve emphasized;
  @override
  ThemeExtension<MotionTokens> lerp(ThemeExtension<MotionTokens>? other, double t) => this;
  @override
  MotionTokens copyWith({Duration? fast, Duration? regular, Duration? slow, Curve? emphasized}) => MotionTokens(
    fast: fast ?? this.fast,
    regular: regular ?? this.regular,
    slow: slow ?? this.slow,
    emphasized: emphasized ?? this.emphasized,
  );
}

@immutable
class ChartTokens extends ThemeExtension<ChartTokens> {
  const ChartTokens({
    required this.primary,
    required this.secondary,
    required this.neutral,
    this.strokeWidth = 2.0,
  });
  final Color primary; final Color secondary; final Color neutral; final double strokeWidth;
  @override
  ThemeExtension<ChartTokens> lerp(ThemeExtension<ChartTokens>? other, double t) => this;
  @override
  ChartTokens copyWith({Color? primary, Color? secondary, Color? neutral, double? strokeWidth}) => ChartTokens(
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    neutral: neutral ?? this.neutral,
    strokeWidth: strokeWidth ?? this.strokeWidth,
  );
}