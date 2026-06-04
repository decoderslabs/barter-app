import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/models/analytics_model.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_chips.dart';

class AnalyticsDashboardScreen extends ConsumerWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;
    final data = ref.watch(analyticsProvider);
    return Scaffold(
      backgroundColor: bc.background,
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (AnalyticsPayload payload) {
          final body = _AnalyticsBody(payload: payload);
          if (!wide) {
            return Column(
              children: [
                _AnalyticsAppBar(wide: wide),
                Expanded(child: body),
              ],
            );
          }
          return Column(
            children: [
              _AnalyticsAppBar(wide: wide),
              Expanded(child: body),
            ],
          );
        },
      ),
    );
  }
}

class _AnalyticsAppBar extends StatelessWidget {
  const _AnalyticsAppBar({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Material(
      color: bc.background,
      child: Padding(
        padding: EdgeInsets.fromLTRB(wide ? 48 : 20, 20, wide ? 48 : 20, 12),
        child: Row(
          children: [
            Icon(Symbols.analytics, color: bc.primary, size: 32),
            const SizedBox(width: 12),
            Text(
              'Editorial Analytics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            if (wide)
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Analytics export coming soon')),
                  );
                },
                icon: const Icon(Symbols.download, size: 18),
                label: const Text('Export Analytics'),
              ),
            if (wide) const SizedBox(width: 16),
            CircleAvatar(
              backgroundColor: bc.surfaceContainerHigh,
              child: Icon(Symbols.notifications, color: bc.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsBody extends StatelessWidget {
  const _AnalyticsBody({required this.payload});

  final AnalyticsPayload payload;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final wide = context.isWide;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(wide ? 48 : 20, 8, wide ? 48 : 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, c) {
              final cross = wide ? 5 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: payload.kpis.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cross,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: wide ? 1.0 : 0.95,
                ),
                itemBuilder: (context, i) {
                  final k = payload.kpis[i];
                  return _KpiTile(kpi: k);
                },
              );
            },
          ),
          if (payload.reachChart.isNotEmpty) ...[  
            const SizedBox(height: 28),
            _ReachChartCard(payload: payload, bc: bc),
          ],
          if (payload.platformBreakdown.isNotEmpty) ...[  
            const SizedBox(height: 20),
            _PlatformBreakdownCard(payload: payload, bc: bc),
          ],
          if (payload.contentPerformance.isNotEmpty) ...[  
            const SizedBox(height: 20),
            _ContentPerformanceCard(payload: payload, bc: bc),
          ],
          if (payload.topCreators.isNotEmpty) ...[  
            const SizedBox(height: 20),
            _TopCreatorsCard(payload: payload, bc: bc),
          ],
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({required this.kpi});

  final AnalyticsKpiModel kpi;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kpi.label.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 10,
                  color: bc.onSurfaceVariant.withValues(alpha: 0.55),
                ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: kpi.value,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                if (kpi.valueSuffix != null)
                  TextSpan(
                    text: ' ${kpi.valueSuffix}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: bc.onSurfaceVariant.withValues(alpha: 0.45),
                        ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (kpi.trendLabel != null)
            Row(
              children: [
                Icon(
                  kpi.trendUp == true
                      ? Symbols.trending_up
                      : kpi.trendUp == false
                          ? Symbols.keyboard_arrow_down
                          : Symbols.sync,
                  size: 16,
                  color: kpi.trendUp == true
                      ? bc.success
                      : bc.primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    kpi.trendLabel!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 11,
                          color: kpi.trendUp == true
                              ? bc.success
                              : bc.primary,
                        ),
                  ),
                ),
              ],
            ),
          if (kpi.progress != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: kpi.progress,
                minHeight: 6,
                backgroundColor: bc.surfaceContainerLow,
                color: bc.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReachChartCard extends StatelessWidget {
  const _ReachChartCard({required this.payload, required this.bc});
  final AnalyticsPayload payload;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final points = payload.reachChart;
    final maxVal = points.isEmpty ? 1.0 : points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payload.reachChartTitle.isNotEmpty ? payload.reachChartTitle : 'Monthly Reach',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...points.map((p) {
            final frac = maxVal > 0 ? (p.value / maxVal).clamp(0.0, 1.0) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    child: Text(p.label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant)),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: frac,
                        minHeight: 18,
                        backgroundColor: bc.surfaceContainerHigh,
                        color: bc.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    p.value >= 1000000 ? '${(p.value / 1000000).toStringAsFixed(1)}M' : p.value >= 1000 ? '${(p.value / 1000).toStringAsFixed(0)}K' : '${p.value.toInt()}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PlatformBreakdownCard extends StatelessWidget {
  const _PlatformBreakdownCard({required this.payload, required this.bc});
  final AnalyticsPayload payload;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final slices = payload.platformBreakdown;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: bc.surfaceContainerLow, borderRadius: BorderRadius.circular(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform Breakdown', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: slices.map((s) {
                final color = parseHexColor(s.colorHex);
                return Flexible(
                  flex: s.percentage.toInt().clamp(1, 100),
                  child: Container(height: 18, color: color),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: slices.map((s) {
              final color = parseHexColor(s.colorHex);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('${s.platform} ${s.percentage.toStringAsFixed(0)}%', style: Theme.of(context).textTheme.labelMedium),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ContentPerformanceCard extends StatelessWidget {
  const _ContentPerformanceCard({required this.payload, required this.bc});
  final AnalyticsPayload payload;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final rows = payload.contentPerformance;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: bc.surfaceContainerLow, borderRadius: BorderRadius.circular(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payload.contentPerformanceTitle.isNotEmpty ? payload.contentPerformanceTitle : 'Content Performance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text('CONTENT', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant, letterSpacing: 1.2))),
              SizedBox(width: 64, child: Text('REACH', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant, letterSpacing: 1.2), textAlign: TextAlign.center)),
              SizedBox(width: 64, child: Text('ENG.', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant, letterSpacing: 1.2), textAlign: TextAlign.center)),
              SizedBox(width: 48, child: Text('DEALS', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant, letterSpacing: 1.2), textAlign: TextAlign.center)),
            ],
          ),
          const SizedBox(height: 8),
          ...rows.map((r) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(child: Text(r.title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                SizedBox(width: 64, child: Text(r.reach, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center)),
                SizedBox(width: 64, child: Text(r.engagement, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center)),
                SizedBox(width: 48, child: Text('${r.deals}', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _TopCreatorsCard extends StatelessWidget {
  const _TopCreatorsCard({required this.payload, required this.bc});
  final AnalyticsPayload payload;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final creators = payload.topCreators;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: bc.surfaceContainerLow, borderRadius: BorderRadius.circular(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Creators', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: creators.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, i) {
                final c = creators[i];
                return SizedBox(
                  width: 88,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: bc.surfaceContainerHigh,
                        backgroundImage: c.avatarUrl.isNotEmpty ? NetworkImage(c.avatarUrl) : null,
                        child: c.avatarUrl.isEmpty ? Text(c.name.isNotEmpty ? c.name[0] : '?', style: Theme.of(context).textTheme.titleMedium) : null,
                      ),
                      const SizedBox(height: 6),
                      Text(c.name.split(' ').first, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                      Text('${c.score} pts', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.active, required this.bc});

  final String label;
  final bool active;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterChip(
      label: label.toUpperCase(),
      variant: BarterChipVariant.mini,
      bgColor: active ? bc.surfaceContainerHighest : Colors.transparent,
      fgColor: active ? bc.onSurface : bc.onSurfaceVariant.withValues(alpha: 0.35),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}
