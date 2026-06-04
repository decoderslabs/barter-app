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
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: bc.surfaceContainerLow,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      payload.contentPerformanceTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Row(
                      children: [
                        _Pill(label: 'Latest', active: true, bc: bc),
                        const SizedBox(width: 8),
                        _Pill(label: 'Top Rated', active: false, bc: bc),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Chart placeholder — wire to real analytics.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
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
