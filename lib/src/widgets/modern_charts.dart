import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom donut chart implemented for flexibility not available in common packages
/// Includes an entrance animation for smoother perceived loading
class ModernDonutChart extends StatelessWidget {
  const ModernDonutChart({
    super.key,
    required this.data,
    this.size = 120,
    this.strokeWidth = 12,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  final List<ChartSegment> data;
  final double size;
  final double strokeWidth;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: animationDuration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return CustomPaint(
          size: Size(size, size),
          painter: DonutChartPainter(
            data: data,
            strokeWidth: strokeWidth,
            animationValue: value,
          ),
        );
      },
    );
  }
}

class ChartSegment {
  const ChartSegment({
    required this.value,
    required this.color,
    required this.label,
  });

  final double value;
  final Color color;
  final String label;
}

/// Custom painter for the donut chart
class DonutChartPainter extends CustomPainter {
  const DonutChartPainter({
    required this.data,
    required this.strokeWidth,
    required this.animationValue,
  });

  final List<ChartSegment> data;
  final double strokeWidth;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final total = data.fold(0.0, (sum, segment) => sum + segment.value);
    if (total == 0) return; // Don't draw anything if no data

    double startAngle = -math.pi / 2; // Start from the top for typical gauge orientation

    // Draw each segment with smooth animation
    for (final segment in data) {
      final sweepAngle = (segment.value / total) * 2 * math.pi * animationValue;
      
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round; // Rounded caps for improved legibility

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Animated line chart for showing trends over time
/// Optional area fill improves readability of trends
class ModernLineChart extends StatefulWidget {
  const ModernLineChart({
    super.key,
    required this.data,
    this.height = 120,
    this.animationDuration = const Duration(milliseconds: 1200),
    this.showDots = true,
    this.showArea = true,
  });

  final List<ChartPoint> data;
  final double height;
  final Duration animationDuration;
  final bool showDots;
  final bool showArea;

  @override
  State<ModernLineChart> createState() => _ModernLineChartState();
}

class _ModernLineChartState extends State<ModernLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, widget.height),
          painter: LineChartPainter(
            data: widget.data,
            animationValue: _animation.value,
            showDots: widget.showDots,
            showArea: widget.showArea,
          ),
        );
      },
    );
  }
}

class ChartPoint {
  const ChartPoint({
    required this.x,
    required this.y,
    this.label,
  });

  final double x;
  final double y;
  final String? label;
}

class LineChartPainter extends CustomPainter {
  const LineChartPainter({
    required this.data,
    required this.animationValue,
    required this.showDots,
    required this.showArea,
  });

  final List<ChartPoint> data;
  final double animationValue;
  final bool showDots;
  final bool showArea;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minX = data.map((p) => p.x).reduce(math.min);
    final maxX = data.map((p) => p.x).reduce(math.max);
    final minY = data.map((p) => p.y).reduce(math.min);
    final maxY = data.map((p) => p.y).reduce(math.max);

    final xRange = maxX - minX;
    final yRange = maxY - minY;

    if (xRange == 0 || yRange == 0) return;

    final points = data.map((point) {
      final x = ((point.x - minX) / xRange) * size.width;
      final y = size.height - ((point.y - minY) / yRange) * size.height;
      return Offset(x, y);
    }).toList();

    // Draw area under the curve
    if (showArea && points.length > 1) {
      final areaPath = Path();
      areaPath.moveTo(points.first.dx, size.height);
      areaPath.lineTo(points.first.dx, points.first.dy);
      
      for (int i = 1; i < points.length; i++) {
        final currentPoint = points[i];
        final animatedY = size.height - (size.height - currentPoint.dy) * animationValue;
        areaPath.lineTo(currentPoint.dx, animatedY);
      }
      
      areaPath.lineTo(points.last.dx, size.height);
      areaPath.close();

      final areaPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.withOpacity(0.3),
            Colors.blue.withOpacity(0.05),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      canvas.drawPath(areaPath, areaPaint);
    }

    // Draw line
    if (points.length > 1) {
      final linePath = Path();
      linePath.moveTo(points.first.dx, points.first.dy);

      for (int i = 1; i < points.length; i++) {
        final currentPoint = points[i];
        final animatedY = size.height - (size.height - currentPoint.dy) * animationValue;
        linePath.lineTo(currentPoint.dx, animatedY);
      }

      final linePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(linePath, linePaint);
    }

    // Draw dots
    if (showDots) {
      for (int i = 0; i < points.length; i++) {
        final point = points[i];
        final animatedY = size.height - (size.height - point.dy) * animationValue;
        
        final dotPaint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(point.dx, animatedY),
          4,
          dotPaint,
        );

        // Outer glow
        final glowPaint = Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(point.dx, animatedY),
          8,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.size,
    this.strokeWidth = 8,
    this.animationDuration = const Duration(milliseconds: 800),
    this.backgroundColor,
    this.progressColor,
    this.child,
  });

  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Duration animationDuration;
  final Color? backgroundColor;
  final Color? progressColor;
  final Widget? child;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.outlineVariant;
    final progressColor = widget.progressColor ?? theme.colorScheme.primary;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: ProgressRingPainter(
            progress: _animation.value,
            strokeWidth: widget.strokeWidth,
            backgroundColor: backgroundColor,
            progressColor: progressColor,
          ),
          child: Center(child: widget.child),
        );
      },
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  const ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
