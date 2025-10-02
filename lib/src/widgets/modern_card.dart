import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Reusable card component with modern styling
/// Consolidates common card presentation to reduce duplication
class ModernCard extends StatelessWidget {
  const ModernCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.gradient,
    this.onTap,
    this.elevation = 0,
    this.borderRadius = 16,
    this.borderColor,
    this.borderWidth = 0,
    this.shadowColor,
    this.blurRadius = 8,
    this.spreadRadius = 0,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double elevation;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final Color? shadowColor;
  final double blurRadius;
  final double spreadRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Default gradient with subtle contrast for depth
    final defaultGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.colorScheme.surface.withOpacity(0.9),
        theme.colorScheme.surface.withOpacity(0.7),
      ],
    );

    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient ?? defaultGradient,
              borderRadius: BorderRadius.circular(borderRadius),
              border: borderWidth > 0 && borderColor != null
                  ? Border.all(color: borderColor!, width: borderWidth)
                  : null,
              boxShadow: elevation > 0
                  ? [
                      BoxShadow(
                        color: (shadowColor ?? Colors.black).withOpacity(0.1),
                        blurRadius: blurRadius,
                        spreadRadius: spreadRadius,
                        offset: Offset(0, elevation),
                      ),
                    ]
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

  /// Card with gradient background for highlighted content
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.gradient,
    this.onTap,
    this.borderRadius = 20,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Gradient based on brand colors with restrained intensity
    final defaultGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.colorScheme.primary.withOpacity(0.1),
        theme.colorScheme.secondary.withOpacity(0.05),
      ],
    );

    return ModernCard(
      padding: padding,
      margin: margin,
      gradient: gradient ?? defaultGradient,
      onTap: onTap,
      borderRadius: borderRadius,
      borderColor: theme.colorScheme.primary.withOpacity(0.2),
      borderWidth: 1,
      elevation: 2,
      blurRadius: 12,
      child: child,
    );
  }
}

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.title,
    required this.value,
    required this.status,
    this.subtitle,
    this.icon,
    this.color,
    this.onTap,
  });

  final String title;
  final String value;
  final String status;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = color ?? theme.colorScheme.primary;

    return GradientCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: statusColor, size: 20),
                const Gap(8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const Gap(4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    this.changeType = MetricChangeType.positive,
    this.icon,
    this.onTap,
  });

  final String title;
  final String value;
  final String change;
  final MetricChangeType changeType;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final changeColor = changeType == MetricChangeType.positive
        ? Colors.green
        : changeType == MetricChangeType.negative
            ? Colors.red
            : theme.colorScheme.onSurfaceVariant;

    return ModernCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: theme.colorScheme.primary),
                const Gap(8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
          Row(
            children: [
              Icon(
                changeType == MetricChangeType.positive
                    ? Icons.trending_up
                    : changeType == MetricChangeType.negative
                        ? Icons.trending_down
                        : Icons.trending_flat,
                size: 14,
                color: changeColor,
              ),
              const Gap(4),
              Text(
                change,
                style: TextStyle(
                  color: changeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum MetricChangeType { positive, negative, neutral }
