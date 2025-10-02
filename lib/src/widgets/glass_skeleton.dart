import 'package:flutter/material.dart';
import 'glass_card.dart';

class GlassSkeleton extends StatefulWidget {
  const GlassSkeleton({super.key});
  @override
  State<GlassSkeleton> createState() => _GlassSkeletonState();
}

class _GlassSkeletonState extends State<GlassSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return GlassCard(
          child: SizedBox(
            height: 96,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment(-1 + 2 * t, 0),
                    widthFactor: .2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.white.withOpacity(.1), Colors.white.withOpacity(.3), Colors.white.withOpacity(.1)],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
