import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../widgets/modern_card.dart';
import '../../widgets/tap_scale.dart';

/// Alerts page with filtering and priority system
/// Aims to mirror operational workflows used in healthcare monitoring
class ModernAlertsPage extends StatefulWidget {
  const ModernAlertsPage({super.key});

  @override
  State<ModernAlertsPage> createState() => _ModernAlertsPageState();
}

class _ModernAlertsPageState extends State<ModernAlertsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'High Priority', 'Medium', 'Low', 'Resolved']; // Filter options for alerts

  @override
  void initState() {
    super.initState();
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Center'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 60,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Add bottom padding for navigation
            child: Column(
              children: [
                // Header with stats
                _buildHeader(),
                
                // Filter chips
                _buildFilterChips(),
                
                // Alerts list
                _buildAlertsList(),
                
                // Additional content to make it scrollable
                _buildAdditionalContent(),
                
                // Bottom spacing
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    
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
                      Colors.red,
                      Colors.orange,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.warning,
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
                      'Monitor resident safety',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Real-time alerts and notifications',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '3 Active',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Alerts',
                  '12',
                  '+2 today',
                  Icons.notifications,
                  Colors.blue,
                ),
              ),
              const Gap(12),
              Expanded(
                child: _buildStatCard(
                  'Resolved',
                  '9',
                  '75% rate',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return ModernCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap(4),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TapScale(
                onTap: () => setState(() => _selectedFilter = filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          )
                        : null,
                    color: isSelected ? null : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : theme.colorScheme.outlineVariant.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAlertsList() {
    final alerts = _getFilteredAlerts();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Alerts',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          ...alerts.map((alert) => _buildAlertCard(alert)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final theme = Theme.of(context);
    final priority = alert['priority'] as AlertPriority;
    final color = _getPriorityColor(priority);
    
    return TapScale(
      onTap: () => _handleAlertTap(alert),
      child: ModernCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                alert['icon'] as IconData,
                color: color,
                size: 20,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert['title'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          priority.name.toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Text(
                    alert['subtitle'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const Gap(4),
                      Text(
                        alert['time'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      if (alert['isResolved'] == false)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(AlertPriority priority) {
    switch (priority) {
      case AlertPriority.high:
        return Colors.red;
      case AlertPriority.medium:
        return Colors.orange;
      case AlertPriority.low:
        return Colors.blue;
    }
  }

  List<Map<String, dynamic>> _getFilteredAlerts() {
    final allAlerts = [
      {
        'title': 'Sarah Johnson got up',
        'subtitle': 'Room 204 • Movement detected',
        'time': '2 minutes ago',
        'priority': AlertPriority.high,
        'icon': Icons.person,
        'isResolved': false,
      },
      {
        'title': 'John Smith is restless',
        'subtitle': 'Room 201 • Unusual movement pattern',
        'time': '5 minutes ago',
        'priority': AlertPriority.medium,
        'icon': Icons.warning,
        'isResolved': false,
      },
      {
        'title': 'Mary Davis sensor offline',
        'subtitle': 'Room 203 • Connection lost',
        'time': '12 minutes ago',
        'priority': AlertPriority.high,
        'icon': Icons.sensors_off,
        'isResolved': false,
      },
      {
        'title': 'Robert Wilson bed exit',
        'subtitle': 'Room 205 • Left bed at 3:42 AM',
        'time': '1 hour ago',
        'priority': AlertPriority.medium,
        'icon': Icons.exit_to_app,
        'isResolved': true,
      },
      {
        'title': 'Emma Brown low battery',
        'subtitle': 'Room 202 • Sensor battery at 15%',
        'time': '2 hours ago',
        'priority': AlertPriority.low,
        'icon': Icons.battery_alert,
        'isResolved': true,
      },
    ];

    if (_selectedFilter == 'All') return allAlerts;
    if (_selectedFilter == 'Resolved') {
      return allAlerts.where((alert) => alert['isResolved'] == true).toList();
    }
    
    final priority = AlertPriority.values.firstWhere(
      (p) => p.name.toLowerCase() == _selectedFilter.toLowerCase().replaceAll(' ', '_'),
    );
    return allAlerts.where((alert) => alert['priority'] == priority).toList();
  }

  void _handleAlertTap(Map<String, dynamic> alert) {
    // Handle alert tap - could show details, mark as resolved, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert: ${alert['title']}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildAdditionalContent() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Alert Statistics',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'This Week',
                  '24',
                  '+5 vs last week',
                  Icons.trending_up,
                  Colors.purple,
                ),
              ),
              const Gap(12),
              Expanded(
                child: _buildStatCard(
                  'Avg Response',
                  '3.2m',
                  'Response time',
                  Icons.timer,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const Gap(20),
          Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Mark All Read',
                  Icons.mark_email_read,
                  Colors.blue,
                  () => _showComingSoon('Mark All Read'),
                ),
              ),
              const Gap(12),
              Expanded(
                child: _buildActionCard(
                  'Export Alerts',
                  Icons.download,
                  Colors.green,
                  () => _showComingSoon('Export Alerts'),
                ),
              ),
            ],
          ),
          const Gap(20),
          Text(
            'Alert History',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          ..._getHistoricalAlerts().map((alert) => _buildAlertCard(alert)),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    
    return TapScale(
      onTap: onTap,
      child: ModernCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const Gap(12),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getHistoricalAlerts() {
    return [
      {
        'title': 'Lisa Anderson bed exit',
        'subtitle': 'Room 206 • Left bed at 11:30 PM',
        'time': 'Yesterday',
        'priority': AlertPriority.medium,
        'icon': Icons.exit_to_app,
        'isResolved': true,
      },
      {
        'title': 'David Wilson sensor offline',
        'subtitle': 'Room 207 • Connection restored',
        'time': '2 days ago',
        'priority': AlertPriority.high,
        'icon': Icons.sensors_off,
        'isResolved': true,
      },
      {
        'title': 'Anna Garcia low battery',
        'subtitle': 'Room 208 • Battery replaced',
        'time': '3 days ago',
        'priority': AlertPriority.low,
        'icon': Icons.battery_alert,
        'isResolved': true,
      },
    ];
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

enum AlertPriority { high, medium, low }
