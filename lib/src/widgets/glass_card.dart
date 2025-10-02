import 'dart:ui';
import 'package:flutter/material.dart';
import '../app/tokens.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(12), this.tint, this.elevation = 1, this.tonal = false});
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? tint;
  final int elevation; // 0-3 subtle shadow levels
  final bool tonal; // stronger tint/background for emphasis

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassTokens>()!;
    final border = BorderRadius.circular(glass.radius);
    final Color overlay = (tint ?? Colors.white).withOpacity(tonal ? .18 : .12);
    final double blur = tonal ? glass.blurSigma + 4 : glass.blurSigma;
    final double bgAlpha = tonal ? (glass.bgAlpha + .06).clamp(0, 1) : glass.bgAlpha;
    final double borderAlpha = tonal ? (glass.borderAlpha).clamp(0, 1) : glass.borderAlpha;
    final double shadowBlur = switch (elevation) { 0 => 18, 1 => 24, 2 => 28, _ => 32 };
    final double shadowY = switch (elevation) { 0 => 8, 1 => 10, 2 => 12, _ => 14 };
    return ClipRRect(
      borderRadius: border,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: border,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(tonal ? .55 : .45),
                Colors.white.withOpacity(tonal ? .35 : .25),
              ],
            ),
            color: Colors.white.withOpacity(bgAlpha),
            border: Border.all(color: Colors.white.withOpacity(borderAlpha)),
            boxShadow: [
              BoxShadow(color: (glass.shadowColor ?? Colors.black.withOpacity(.08)), blurRadius: shadowBlur, offset: Offset(0, shadowY)),
              BoxShadow(color: Colors.white.withOpacity(.1), blurRadius: 2, offset: const Offset(0, 1)),
            ],
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: border,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [overlay, Colors.transparent],
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: border,
                splashColor: Colors.white.withOpacity(.25),
                highlightColor: Colors.white.withOpacity(.08),
                child: Padding(padding: padding, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


