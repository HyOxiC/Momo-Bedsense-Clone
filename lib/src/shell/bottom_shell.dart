import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

/// Main navigation shell with curved bottom bar
/// Retains a curved layout and refines animations for smoother transitions
class BottomShell extends StatefulWidget {
  const BottomShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<BottomShell> createState() => _BottomShellState();
}

class _BottomShellState extends State<BottomShell> with SingleTickerProviderStateMixin {
  int _dir = 0; // -1 left, 1 right - tracks swipe direction for animation
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 360));
  late final Animation<double> _curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubicEmphasized);

  // Calculate slide offset based on navigation direction
  double get _dx => _dir == 0 ? 0 : (_dir > 0 ? 0.12 : -0.12);

  void _playDir(int dir) {
    setState(() => _dir = dir);
    _controller.forward(from: 0); // Reset and play animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shell = widget.navigationShell;
    return WillPopScope(
      onWillPop: () async {
        final router = GoRouter.of(context);
        if (router.canPop()) {
          router.pop();
          return false;
        }
        if (shell.currentIndex != 0) {
          _playDir(-1);
          shell.goBranch(0, initialLocation: false);
          return false;
        }
        return true; // allow app to exit
      },
      child: Scaffold(
        extendBody: true,
        body: AnimatedBuilder(
          animation: _curve,
          builder: (context, _) {
            final t = _curve.value;
            final dx = _dx * (1 - t);
            return Opacity(
              opacity: 0.7 + 0.3 * t,
              child: FractionalTranslation(translation: Offset(dx, 0), child: shell),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Theme.of(context).colorScheme.surface.withOpacity(0.8),
                ],
              ),
            ),
            child: CurvedNavigationBar(
              index: shell.currentIndex,
              height: 75,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              items: [
                _ModernNavItem(
                  icon: Icons.waves_outlined,
                  activeIcon: Icons.waves,
                  label: 'Overview',
                  isActive: shell.currentIndex == 0,
                ),
                _ModernNavItem(
                  icon: Icons.notifications_outlined,
                  activeIcon: Icons.notifications,
                  label: 'Alerts',
                  isActive: shell.currentIndex == 1,
                ),
                _ModernNavItem(
                  icon: Icons.help_outline,
                  activeIcon: Icons.help,
                  label: 'Support',
                  isActive: shell.currentIndex == 2,
                ),
              ],
              onTap: (index) {
                final current = shell.currentIndex;
                _playDir(index > current ? 1 : -1);
                shell.goBranch(index, initialLocation: false);
              },
              animationDuration: const Duration(milliseconds: 500),
              animationCurve: Curves.easeOutCubic,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernNavItem extends StatelessWidget {
  const _ModernNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive 
        ? theme.colorScheme.primary 
        : theme.colorScheme.onSurfaceVariant;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: isActive 
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.secondary.withOpacity(0.05),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        border: isActive 
            ? Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isActive ? activeIcon : icon,
              key: ValueKey(isActive),
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


