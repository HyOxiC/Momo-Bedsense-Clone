import 'dart:math' as math;
import 'package:flutter/material.dart';

class AveragesDonut extends StatelessWidget {
  const AveragesDonut({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(120),
            painter: _DonutPainter(
              segments: [
                _DonutSeg(.6, Theme.of(context).colorScheme.secondary), // slept
                _DonutSeg(.4, Colors.grey.shade300), // other
              ],
            ),
          ),
          const Text('9 hr\n34 min', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _DonutSeg {
  const _DonutSeg(this.fraction, this.color);
  final double fraction;
  final Color color;
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.segments});
  final List<_DonutSeg> segments;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    double start = -math.pi / 2;
    for (final s in segments) {
      stroke.color = s.color;
      final sweep = s.fraction * 2 * math.pi;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep, false, stroke);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => true;
}


