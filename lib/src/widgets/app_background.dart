import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withOpacity(.12),
            scheme.secondary.withOpacity(.10),
            Colors.white.withOpacity(.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}
