import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_card.dart';

class DropsDashboardScreen extends ConsumerWidget {
  const DropsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;

    return Scaffold(
      backgroundColor: bc.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/brand/drops/create'),
        backgroundColor: bc.primary,
        foregroundColor: bc.onPrimary,
        icon: const Icon(Symbols.add),
        label: const Text('New Drop'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 48 : 16, wide ? 40 : 16, wide ? 48 : 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'US-B03 Active Mode',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: bc.primary,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Summer Drops ',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            TextSpan(
                              text: 'Campaign',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: bc.primaryContainer,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Real-time operational health for the Premium Skincare launch sequence.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: bc.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                if (wide) ...[
                  const SizedBox(width: 24),
                  FilledButton.icon(
                    onPressed: () => context.go('/brand/review'),
                    style: FilledButton.styleFrom(
                      backgroundColor: bc.primary,
                      foregroundColor: bc.onPrimary,
                      shape: const StadiumBorder(),
                    ),
                    icon: const Icon(Symbols.group, size: 18),
                    label: const Text('Manage Applications'),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(leading: const Icon(Icons.edit), title: const Text('Edit Drop'), onTap: () => Navigator.pop(context)),
                              ListTile(leading: const Icon(Icons.share), title: const Text('Share Drop'), onTap: () => Navigator.pop(context)),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: Icon(Symbols.more_vert, color: bc.onSurface),
                    style: IconButton.styleFrom(
                      backgroundColor: bc.surfaceContainerHigh,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 32),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _SlotProgressCard(bc: bc),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _PerformanceMetricsCard(bc: bc),
                  ),
                ],
              )
            else ...[
              _SlotProgressCard(bc: bc),
              const SizedBox(height: 16),
              _PerformanceMetricsCard(bc: bc),
            ],
            const SizedBox(height: 24),
            _CreatorPipelineCard(bc: bc),
            const SizedBox(height: 24),
            _RecentActivityCard(bc: bc),
          ],
        ),
      ),
    );
  }
}

class _SlotProgressCard extends StatelessWidget {
  const _SlotProgressCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    return BarterCard(
      borderRadius: 24,
      padding: EdgeInsets.all(wide ? 28 : 20),
      borderColor: bc.outlineVariant.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operational Capacity',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '43 of 100 creators onboarded',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: bc.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          if (wide)
            Row(
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: _DonutChart(bc: bc),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _StatTile(label: 'Available', value: '57', bc: bc),
                      const SizedBox(height: 12),
                      _StatTile(label: 'In Review', value: '12', bc: bc, valueColor: bc.tertiary),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: _DonutChart(bc: bc),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _StatTile(label: 'Available', value: '57', bc: bc)),
                    const SizedBox(width: 12),
                    Expanded(child: _StatTile(label: 'In Review', value: '12', bc: bc, valueColor: bc.tertiary)),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({required this.bc});
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: CircularProgressIndicator(
            value: 0.43,
            strokeWidth: 14,
            backgroundColor: bc.surfaceContainerLow,
            color: bc.primary,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '43%',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            Text(
              'Slots Filled',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 10,
                    color: bc.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.bc,
    this.valueColor,
  });

  final String label;
  final String value;
  final BarterColors bc;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 10,
                  color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: valueColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceMetricsCard extends StatelessWidget {
  const _PerformanceMetricsCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    return BarterCard(
      borderRadius: 24,
      padding: EdgeInsets.all(wide ? 28 : 20),
      borderColor: bc.outlineVariant.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          _MetricRow(label: 'Total Reach', value: '1.2M', bc: bc),
          const SizedBox(height: 16),
          _MetricRow(label: 'Engagement', value: '8.4%', bc: bc),
          const SizedBox(height: 16),
          _MetricRow(label: 'Conversions', value: '324', bc: bc),
          const SizedBox(height: 16),
          _MetricRow(label: 'ROI', value: '4.2x', bc: bc, valueColor: bc.success),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.bc,
    this.valueColor,
  });

  final String label;
  final String value;
  final BarterColors bc;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: valueColor ?? bc.onSurface,
              ),
        ),
      ],
    );
  }
}

class _CreatorPipelineCard extends StatelessWidget {
  const _CreatorPipelineCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    return BarterCard(
      borderRadius: 24,
      padding: EdgeInsets.all(wide ? 28 : 20),
      borderColor: bc.outlineVariant.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Creator Pipeline',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              TextButton(
                onPressed: () => context.push('/brand/pipeline'),
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: bc.primary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _PipelineRow(label: 'Applications', count: 124, color: bc.primary),
          const SizedBox(height: 12),
          _PipelineRow(label: 'In Review', count: 45, color: bc.tertiary),
          const SizedBox(height: 12),
          _PipelineRow(label: 'Approved', count: 38, color: bc.success),
          const SizedBox(height: 12),
          _PipelineRow(label: 'Published', count: 43, color: bc.secondary),
        ],
      ),
    );
  }
}

class _PipelineRow extends StatelessWidget {
  const _PipelineRow({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bc.onSurfaceVariant,
                ),
          ),
        ),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    return BarterCard(
      borderRadius: 24,
      padding: EdgeInsets.all(wide ? 28 : 20),
      borderColor: bc.outlineVariant.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 20),
          _ActivityItem(
            icon: Symbols.person_add,
            title: 'Sarah Chen applied to Summer Drops',
            time: '2 min ago',
            bc: bc,
          ),
          const SizedBox(height: 16),
          _ActivityItem(
            icon: Symbols.check_circle,
            title: 'Marcus Johnson approved for campaign',
            time: '15 min ago',
            bc: bc,
          ),
          const SizedBox(height: 16),
          _ActivityItem(
            icon: Symbols.publish,
            title: 'New content published by Priya Sharma',
            time: '1 hour ago',
            bc: bc,
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.bc,
  });

  final IconData icon;
  final String title;
  final String time;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bc.primaryContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: bc.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
