import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/dto/drops_dto.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_card.dart';

class DropsDashboardScreen extends ConsumerWidget {
  const DropsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;
    final dropsAsync = ref.watch(dropsProvider);

    return dropsAsync.when(
      loading: () => Scaffold(backgroundColor: bc.background, body: const Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(backgroundColor: bc.background, body: Center(child: Text('$e'))),
      data: (drops) {
        final campaign = drops.isNotEmpty ? drops.first : null;
        final filledSlots = campaign?.filledSlots ?? 0;
        final totalSlots = campaign?.totalSlots ?? 1;
        final fillPct = totalSlots > 0 ? filledSlots / totalSlots : 0.0;
        final remaining = campaign?.slotsRemaining ?? (totalSlots - filledSlots);
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
                        campaign != null ? 'DROP #${campaign.id}' : 'NO ACTIVE DROP',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: bc.primary,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        campaign?.name ?? 'Drops Dashboard',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        campaign?.description ?? campaign?.goal ?? 'No active campaign',
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
                    child: _SlotProgressCard(
                      bc: bc,
                      filledSlots: filledSlots,
                      totalSlots: totalSlots,
                      fillPct: fillPct,
                      remaining: remaining,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _PerformanceMetricsCard(
                      bc: bc,
                      applicationCount: campaign?.applicationCount ?? 0,
                      estimatedValue: campaign?.estimatedValue,
                      currency: campaign?.currency ?? 'INR',
                    ),
                  ),
                ],
              )
            else ...[
              _SlotProgressCard(
                bc: bc,
                filledSlots: filledSlots,
                totalSlots: totalSlots,
                fillPct: fillPct,
                remaining: remaining,
              ),
              const SizedBox(height: 16),
              _PerformanceMetricsCard(
                bc: bc,
                applicationCount: campaign?.applicationCount ?? 0,
                estimatedValue: campaign?.estimatedValue,
                currency: campaign?.currency ?? 'INR',
              ),
            ],
            const SizedBox(height: 24),
            _CreatorPipelineCard(bc: bc, drops: drops),
            const SizedBox(height: 24),
            _RecentActivityCard(bc: bc, drops: drops),
          ],
        ),
      ),
        );
      },
    );
  }
}

class _SlotProgressCard extends StatelessWidget {
  const _SlotProgressCard({
    required this.bc,
    required this.filledSlots,
    required this.totalSlots,
    required this.fillPct,
    required this.remaining,
  });

  final BarterColors bc;
  final int filledSlots;
  final int totalSlots;
  final double fillPct;
  final int remaining;

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
            '$filledSlots of $totalSlots creators onboarded',
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
                  child: _DonutChart(bc: bc, fillPct: fillPct, filledSlots: filledSlots),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _StatTile(label: 'Available', value: '$remaining', bc: bc),
                      const SizedBox(height: 12),
                      _StatTile(label: 'Filled', value: '$filledSlots', bc: bc, valueColor: bc.tertiary),
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
                    child: _DonutChart(bc: bc, fillPct: fillPct, filledSlots: filledSlots),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _StatTile(label: 'Available', value: '$remaining', bc: bc)),
                    const SizedBox(width: 12),
                    Expanded(child: _StatTile(label: 'Filled', value: '$filledSlots', bc: bc, valueColor: bc.tertiary)),
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
  const _DonutChart({required this.bc, required this.fillPct, required this.filledSlots});
  final BarterColors bc;
  final double fillPct;
  final int filledSlots;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: CircularProgressIndicator(
            value: fillPct.clamp(0.0, 1.0),
            strokeWidth: 14,
            backgroundColor: bc.surfaceContainerLow,
            color: bc.primary,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(fillPct * 100).round()}%',
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
  const _PerformanceMetricsCard({
    required this.bc,
    required this.applicationCount,
    required this.estimatedValue,
    required this.currency,
  });

  final BarterColors bc;
  final int applicationCount;
  final double? estimatedValue;
  final String currency;

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
          _MetricRow(label: 'Applications', value: '$applicationCount', bc: bc),
          const SizedBox(height: 16),
          _MetricRow(label: 'Est. Value', value: estimatedValue != null ? '$currency ${estimatedValue!.toStringAsFixed(0)}' : '—', bc: bc),
          const SizedBox(height: 16),
          _MetricRow(label: 'Reach', value: '—', bc: bc),
          const SizedBox(height: 16),
          _MetricRow(label: 'Engagement', value: '—', bc: bc, valueColor: bc.success),
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
  const _CreatorPipelineCard({required this.bc, required this.drops});

  final BarterColors bc;
  final List<DropsCampaignDto> drops;

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
          ...drops.take(4).map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _PipelineRow(
              label: d.name,
              count: d.applicationCount,
              color: d.status == 'live' ? bc.success : d.status == 'draft' ? bc.warning : bc.primary,
            ),
          )),
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
  const _RecentActivityCard({required this.bc, required this.drops});

  final BarterColors bc;
  final List<DropsCampaignDto> drops;

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
          if (drops.isEmpty)
            Text('No recent activity', style: Theme.of(context).textTheme.bodyMedium)
          else
            ...drops.take(3).map((d) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ActivityItem(
                icon: d.status == 'live' ? Symbols.campaign : Symbols.draft,
                title: '${d.name} — ${d.filledSlots}/${d.totalSlots} slots filled',
                time: d.status.toUpperCase(),
                bc: bc,
              ),
            )),
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
