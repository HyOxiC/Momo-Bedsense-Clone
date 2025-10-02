import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/modern_card.dart';
import '../../widgets/modern_charts.dart';
import '../../widgets/tap_scale.dart';

/// Main dashboard with metrics and charts
/// This is where I spent most of my time getting the animations right
class ModernDashboard extends StatefulWidget {
  const ModernDashboard({super.key});

  @override
  State<ModernDashboard> createState() => _ModernDashboardState();
}

class _ModernDashboardState extends State<ModernDashboard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Separate fade and slide animations for a refined entrance
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Start slightly below
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Start animations immediately when dashboard loads
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // Header with greeting and stats
            _buildHeader(theme),
            
            // Quick stats cards
            _buildQuickStats(theme),
            
            // Main metrics with charts
            _buildMainMetrics(theme),
            
            // Recent activity
            _buildRecentActivity(theme),
            
            // Bottom spacing
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Memory Care Unit',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: MetricCard(
              title: 'Active Residents',
              value: '12',
              change: '+2 this week',
              changeType: MetricChangeType.positive,
              icon: Icons.people,
            ),
          ),
          const Gap(12),
          Expanded(
            child: MetricCard(
              title: 'Alerts Today',
              value: '3',
              change: '-1 from yesterday',
              changeType: MetricChangeType.positive,
              icon: Icons.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMetrics(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resident Status Overview',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildStatusChart(theme),
              ),
              const Gap(16),
              Expanded(
                child: _buildStatusBreakdown(theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChart(ThemeData theme) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Quality Trends',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(16),
          SizedBox(
            height: 120,
            child: ModernLineChart(
              data: [
                const ChartPoint(x: 0, y: 85),
                const ChartPoint(x: 1, y: 78),
                const ChartPoint(x: 2, y: 92),
                const ChartPoint(x: 3, y: 88),
                const ChartPoint(x: 4, y: 95),
                const ChartPoint(x: 5, y: 89),
                const ChartPoint(x: 6, y: 91),
              ],
            ),
          ),
          const Gap(12),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Gap(8),
              Text(
                'Average: 88%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBreakdown(ThemeData theme) {
    final statusData = [
      ChartSegment(
        value: 8,
        color: Colors.green,
        label: 'Resting',
      ),
      ChartSegment(
        value: 3,
        color: Colors.orange,
        label: 'Restless',
      ),
      ChartSegment(
        value: 1,
        color: Colors.red,
        label: 'Alert',
      ),
    ];

    return GradientCard(
      child: Column(
        children: [
          Text(
            'Current Status',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(16),
          ModernDonutChart(
            data: statusData,
            size: 80,
            strokeWidth: 8,
          ),
          const Gap(16),
          ...statusData.map((segment) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: segment.color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    segment.label,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                Text(
                  '${segment.value.toInt()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          ...List.generate(3, (index) => _buildActivityItem(theme, index)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ThemeData theme, int index) {
    final activities = [
      {
        'title': 'Sarah Johnson got up',
        'subtitle': 'Room 204 • 2 minutes ago',
        'icon': Icons.person,
        'color': Colors.orange,
      },
      {
        'title': 'John Smith is restless',
        'subtitle': 'Room 201 • 5 minutes ago',
        'icon': Icons.warning,
        'color': Colors.red,
      },
      {
        'title': 'Mary Davis sleeping well',
        'subtitle': 'Room 203 • 12 minutes ago',
        'icon': Icons.bedtime,
        'color': Colors.green,
      },
    ];

    final activity = activities[index];

    return TapScale(
      onTap: () {},
      child: ModernCard(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (activity['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
                size: 20,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['title'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    activity['subtitle'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
