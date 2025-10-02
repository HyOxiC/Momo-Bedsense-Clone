import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'data/fake_resident_repository.dart';
import 'widgets/week_overview_chart.dart';
import 'widgets/averages_donut.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_chip.dart';
import '../../widgets/tap_scale.dart';

class ResidentDetailPage extends ConsumerWidget {
  const ResidentDetailPage({super.key, required this.residentId});
  final String residentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final residents = ref.watch(fakeResidentsProvider);
    final resident = residents.firstWhere((r) => r.id == residentId);

    final tabBarTheme = Theme.of(context).tabBarTheme.copyWith(
      indicator: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 1),
      ),
    );

    return DefaultTabController(
      length: 3,
      child: Theme(
        data: Theme.of(context).copyWith(tabBarTheme: tabBarTheme),
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Hero(tag: 'room-${resident.id}', child: GlassChip.label(resident.room)),
                const Gap(8),
                Expanded(child: Text(' •  ${resident.name}', maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('In/out of bed'))),
                Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('Posture'))),
                Tab(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('Rest state'))),
              ],
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: TabBarView(
              key: ValueKey(Theme.of(context).brightness),
              children: [
                _InOutOfBedTab(residentId: resident.id),
                const _PostureTab(),
                const _RestStateTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InOutOfBedTab extends StatelessWidget {
  const _InOutOfBedTab({required this.residentId});
  final String residentId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassCard(
          tint: Theme.of(context).colorScheme.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Week Overview', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87)),
              const Gap(12),
              TapScale(child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(.6)),
                ),
                child: const WeekOverviewChart(),
              )),
            ],
          ),
        ),
        const Gap(16),
        GlassCard(
          tint: Theme.of(context).colorScheme.secondary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Averages', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87)),
              const Gap(12),
              const AveragesDonut(),
            ],
          ),
        ),
        const Gap(16),
        GlassCard(
          tint: Theme.of(context).colorScheme.secondary,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.insights_outlined, color: Colors.black87),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Insight', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87)),
                    const Gap(6),
                    const Text('Exit risk is higher between 10–11 PM. Consider adjusting alerts and rounds during this window.'),
                    const Gap(12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TapScale(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Adjust alerts'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostureTab extends StatelessWidget {
  const _PostureTab();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Posture timeline placeholder',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _RestStateTab extends StatelessWidget {
  const _RestStateTab();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Rest state summary placeholder',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}


