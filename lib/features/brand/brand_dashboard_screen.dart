import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/models/brand_dashboard_model.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_card.dart';
import '../../widgets/barter_network_image.dart';

class BrandDashboardScreen extends ConsumerWidget {
  const BrandDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;
    final async = ref.watch(brandDashboardProvider);

    return Scaffold(
      backgroundColor: bc.background,
      body: async.when(
        loading: () => Center(child: CircularProgressIndicator(color: bc.primary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(wide ? 48 : 20, wide ? 40 : 24, wide ? 48 : 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GreetingHeader(data: data, bc: bc),
              const SizedBox(height: 32),
              _KpiBar(kpis: data.kpis, bc: bc, wide: wide),
              const SizedBox(height: 40),
              _QuickActions(bc: bc, wide: wide),
              const SizedBox(height: 40),
              _JourneyGrid(bc: bc, wide: wide),
              const SizedBox(height: 40),
              _RecentActivity(items: data.recentActivity, bc: bc),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Greeting ─────────────────────────────────────────────────────────────────

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.data, required this.bc});
  final BrandDashboardData data;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data.greeting,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(
          'Here\'s what\'s happening with your campaigns today.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: bc.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ─── KPI Bar ──────────────────────────────────────────────────────────────────

class _KpiBar extends StatelessWidget {
  const _KpiBar({required this.kpis, required this.bc, required this.wide});
  final DashboardKpis kpis;
  final BarterColors bc;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Symbols.campaign, '${kpis.activeCampaigns}', 'Campaigns', null as String?),
      (Symbols.inbox, '${kpis.pendingProposals}', 'Proposals', '/brand/review'),
      (Symbols.view_kanban, '${kpis.dealsInProgress}', 'In Pipeline', '/brand/pipeline'),
      (Symbols.trending_up, '${(kpis.totalReachThisMonth / 1000000).toStringAsFixed(1)}M', 'Reach', '/brand/analytics'),
      (Symbols.percent, '${kpis.avgEngagementRate}%', 'Avg Eng.', '/brand/analytics'),
      (Symbols.payments, '₹${(kpis.barterValueDelivered / 1000).toStringAsFixed(0)}K', 'Value Delivered', '/brand/analytics'),
    ];

    if (wide) {
      return Row(
        children: items
            .map((it) => Expanded(child: _KpiChip(icon: it.$1, value: it.$2, label: it.$3, route: it.$4, bc: bc)))
            .expand((w) => [w, const SizedBox(width: 12)])
            .toList()
          ..removeLast(),
      );
    }

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((it) => _KpiChip(icon: it.$1, value: it.$2, label: it.$3, route: it.$4, bc: bc)).toList(),
    );
  }
}

class _KpiChip extends StatelessWidget {
  const _KpiChip({required this.icon, required this.value, required this.label, required this.bc, this.route});
  final IconData icon;
  final String value;
  final String label;
  final BarterColors bc;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      onTap: route != null ? () => context.go(route!) : null,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bc.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: bc.primary, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              Text(label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant, height: 1.3)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.bc, required this.wide});
  final BarterColors bc;
  final bool wide;

  static const _actions = [
    (Symbols.add_circle, 'New Campaign', '/brand/campaigns/create', true),
    (Symbols.person_search, 'Find Creators', '/brand/discover', false),
    (Symbols.chat_bubble, 'Inbox', '/brand/inbox', false),
    (Symbols.bolt, 'Value Engine', '/brand/value-engine', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: _actions
              .map((a) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _QuickActionBtn(icon: a.$1, label: a.$2, route: a.$3, primary: a.$4, bc: bc),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  const _QuickActionBtn({required this.icon, required this.label, required this.route, required this.primary, required this.bc});
  final IconData icon;
  final String label;
  final String route;
  final bool primary;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: primary ? bc.primary : bc.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: primary ? null : Border.all(color: bc.outlineVariant.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: primary ? bc.onPrimary : bc.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: primary ? bc.onPrimary : bc.onSurface,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Journey Grid ─────────────────────────────────────────────────────────────

class _JourneyGrid extends StatelessWidget {
  const _JourneyGrid({required this.bc, required this.wide});
  final BarterColors bc;
  final bool wide;

  static const _journeys = [
    (Symbols.campaign, 'Campaigns', '4 active · 2 drafts', '/brand/campaigns', null as int?),
    (Symbols.rate_review, 'Review Hub', '12 proposals · 3 content', '/brand/review', 15),
    (Symbols.view_kanban, 'Deal Pipeline', '5 deals in progress', '/brand/pipeline', null),
    (Symbols.person_search, 'Discover Creators', '1,200+ verified creators', '/brand/discover', null),
    (Symbols.water_drop, 'Drops', '1 live drop campaign', '/brand/drops', null),
    (Symbols.analytics, 'Analytics', '3.2M reach this month', '/brand/analytics', null),
    (Symbols.chat_bubble, 'Inbox', '3 unread messages', '/brand/inbox', 3),
    (Symbols.bolt, 'Value Engine', 'Calculate barter ROI', '/brand/value-engine', null),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('All Journeys',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: wide ? 4 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: wide ? 1.4 : 1.3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _journeys
              .map((j) => _JourneyTile(
                    icon: j.$1,
                    title: j.$2,
                    subtitle: j.$3,
                    route: j.$4,
                    badge: j.$5,
                    bc: bc,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _JourneyTile extends StatelessWidget {
  const _JourneyTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.bc,
    this.badge,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final BarterColors bc;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      onTap: () => context.go(route),
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: bc.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: bc.primary, size: 18),
              ),
              const Spacer(),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: bc.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badge',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: bc.onError, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: bc.onSurfaceVariant, height: 1.3)),
        ],
      ),
    );
  }
}

// ─── Recent Activity ──────────────────────────────────────────────────────────

class _RecentActivity extends StatelessWidget {
  const _RecentActivity({required this.items, required this.bc});
  final List<ActivityItem> items;
  final BarterColors bc;

  static IconData _iconFor(String type) {
    switch (type) {
      case 'proposal': return Symbols.description;
      case 'content':  return Symbols.play_circle;
      case 'deal':     return Symbols.handshake;
      case 'message':  return Symbols.chat_bubble;
      case 'campaign': return Symbols.campaign;
      default:         return Symbols.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: BarterCard(
                onTap: () => context.go(item.route),
                borderRadius: 16,
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Avatar or icon
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bc.surfaceContainer,
                          ),
                          child: item.avatarUrl != null
                              ? ClipOval(
                                  child: BarterNetworkImage(
                                    url: item.avatarUrl!,
                                    fit: BoxFit.cover,
                                    memCacheWidth: 88,
                                    memCacheHeight: 88,
                                  ),
                                )
                              : Icon(_iconFor(item.type), color: bc.primary, size: 20),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: bc.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: bc.background, width: 2),
                            ),
                            child: Icon(_iconFor(item.type), color: bc.onPrimary, size: 9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(item.title,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: item.urgent ? bc.error : null,
                                        )),
                              ),
                              if (item.urgent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: bc.error.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text('Urgent',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: bc.error, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(item.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: bc.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(item.timestamp,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: bc.onSurfaceVariant)),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
