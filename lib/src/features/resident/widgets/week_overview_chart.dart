import 'package:flutter/material.dart';

class WeekOverviewChart extends StatelessWidget {
  const WeekOverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
    final days = const ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
    return Column(
      children: [
        for (final d in days)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(width: 28, child: Text(d, textAlign: TextAlign.right)),
                const SizedBox(width: 8),
                Expanded(
                  child: _BarRow(
                    segments: const [
                      _Seg(0.10, Color(0xFFB0BEC5)),
                      _Seg(0.20, Color(0xFF80DEEA)),
                      _Seg(0.10, Color(0xFFB0BEC5)),
                      _Seg(0.30, Color(0xFF80DEEA)),
                      _Seg(0.30, Color(0xFFB0BEC5)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(width: 28, child: Text(d)),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: const [
              SizedBox(width: 36),
              Expanded(child: _Axis()),
            ],
          ),
        ),
      ],
    );
  }
}

class _Seg {
  const _Seg(this.fraction, this.color);
  final double fraction;
  final Color color;
}

class _BarRow extends StatelessWidget {
  const _BarRow({required this.segments});
  final List<_Seg> segments;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Row(
        children: [
          for (final s in segments)
            Expanded(
              flex: (s.fraction * 1000).round(),
              child: Container(height: 16, color: s.color),
            ),
        ],
      ),
    );
  }
}

class _Axis extends StatelessWidget {
  const _Axis();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(height: 1, color: Colors.black38),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('10:00P', style: TextStyle(fontSize: 12)),
            Text('10:00A', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}


