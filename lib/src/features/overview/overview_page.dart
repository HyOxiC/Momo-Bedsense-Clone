import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_chip.dart';
import '../../core/constants.dart';
import '../resident/data/fake_resident_repository.dart';
import '../../widgets/app_background.dart';
import '../../widgets/tap_scale.dart';
import '../../core/loading_provider.dart';
import '../../widgets/glass_skeleton.dart';
import 'modern_dashboard.dart';

/// Main overview page with dashboard and resident list
/// This is the first screen users see - wanted to make a good impression
class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(loadingProvider);
    final residents = ref.watch(fakeResidentsProvider);
    
    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(), // Gradient background for visual hierarchy
          if (loading.isLoading) ...[
            // Display skeleton placeholders while data is loading
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 72, 16, 140),
              itemCount: 6,
              itemBuilder: (_, __) => const Padding(padding: EdgeInsets.only(bottom: 12), child: GlassSkeleton()),
            )
          ] else ...[
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('Overview'),
                  actions: const [Padding(padding: EdgeInsets.only(right: 12), child: GlassChip.label('Memory Care Unit'))],
                  pinned: true,
                  toolbarHeight: 60,
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: _FilterBar(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: const ModernDashboard(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: Row(
                      children: [
                        Text(
                          'Residents',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final r = residents[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TapScale(
                            onTap: () => context.push(AppRoutes.resident(r.id)),
                            child: _ResidentListTile(
                              id: r.id,
                              name: r.name,
                              room: r.room,
                              status: r.statusLabel,
                              accent: r.statusColor,
                              immobileFor: r.immobileForLabel,
                              onTap: () => context.push(AppRoutes.resident(r.id)),
                            ),
                          ),
                        );
                      },
                      childCount: residents.length,
                    ),
                  ),
                )
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Filter chips for resident status to aid quick scanning and filtering
class _FilterBar extends StatefulWidget {
  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar> {
  String selected = 'All';
  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Resting', 'Restless', 'Exit soon', 'Out of bed']; // Status options
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      tint: Theme.of(context).colorScheme.secondary,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final f in filters) Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(f),
                selected: selected == f,
                onSelected: (_) => setState(() => selected = f),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual resident card - shows all the important info at a glance
class _ResidentListTile extends StatelessWidget {
  const _ResidentListTile({
    required this.id,
    required this.name,
    required this.room,
    required this.status,
    required this.accent,
    required this.immobileFor,
    required this.onTap,
  });

  final String id;
  final String name;
  final String room;
  final String status;
  final Color accent;
  final String immobileFor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface.withOpacity(0.9),
                  theme.colorScheme.surface.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ModernStatusIcon(color: accent),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              room,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          _ModernQuickActions(),
                        ],
                      ),
                      const Gap(12),
                      Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        status,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                _ModernRightSummary(timeLabel: immobileFor, state: status),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernStatusIcon extends StatelessWidget {
  const _ModernStatusIcon({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }
}

class _ModernQuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget modernButton(IconData icon, String label) => Semantics(
          button: true,
          label: label,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 16,
              color: theme.colorScheme.primary,
            ),
          ),
        );
    
    return Row(mainAxisSize: MainAxisSize.min, children: [
      modernButton(Icons.bed, 'Bed'),
      const Gap(6),
      modernButton(Icons.notifications_none, 'Notifications'),
      const Gap(6),
      modernButton(Icons.sensors, 'Sensor'),
    ]);
  }
}

class _ModernRightSummary extends StatelessWidget {
  const _ModernRightSummary({required this.timeLabel, required this.state});
  final String timeLabel;
  final String state;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.secondary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            timeLabel.replaceFirst('Immobile: ', ''),
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Gap(6),
        Text(
          state,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// Legacy _RoomBar and header delegate replaced by SliverAppBar.large and _FilterBar


