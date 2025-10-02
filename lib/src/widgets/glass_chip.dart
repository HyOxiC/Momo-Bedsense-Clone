import 'dart:ui';
import 'package:flutter/material.dart';
import '../app/tokens.dart';

class GlassChip extends StatelessWidget {
  const GlassChip.label(this.label, {super.key, this.icon, this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6)});
  const GlassChip.icon(this.icon, {super.key, this.padding = const EdgeInsets.all(8)}) : label = null;

  final String? label;
  final IconData? icon;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final glass = Theme.of(context).extension<GlassTokens>()!;
    final border = BorderRadius.circular(glass.radius - 2);
    return ClipRRect(
      borderRadius: border,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blurSigma - 8, sigmaY: glass.blurSigma - 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: border,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(.55),
                Colors.white.withOpacity(.35),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(.7)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 16, offset: const Offset(0, 8))],
          ),
          child: label != null
              ? Text(label!, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87))
              : Icon(icon, size: 18, color: Colors.black87),
        ),
      ),
    );
  }
}


