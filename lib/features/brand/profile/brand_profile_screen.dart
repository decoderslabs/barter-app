import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/models/brand_profile_model.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../theme/responsive_extension.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_card.dart';
import '../../../widgets/barter_network_image.dart';

class BrandProfileScreen extends ConsumerWidget {
  const BrandProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;
    final async = ref.watch(brandProfileProvider);

    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        leading: context.canPop() ? BarterBackButton(onPressed: () => context.pop()) : null,
        actions: [
          IconButton(
            icon: Icon(Symbols.edit, color: bc.onBackground),
            onPressed: () {},
            tooltip: 'Edit Profile',
          ),
          IconButton(
            icon: Icon(Symbols.notifications, color: bc.onBackground),
            onPressed: () => context.push('/notifications/center'),
          ),
        ],
      ),
      body: async.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: bc.primary),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (brand) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            wide ? 48 : 20,
            0,
            wide ? 48 : 20,
            120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CoverHero(brand: brand, bc: bc, wide: wide),
              const SizedBox(height: 32),
              _StatsRow(brand: brand, bc: bc, wide: wide),
              const SizedBox(height: 40),
              _BarterScoreSection(brand: brand, bc: bc, wide: wide),
              const SizedBox(height: 40),
              _AboutSection(brand: brand, bc: bc),
              const SizedBox(height: 40),
              _ActiveCampaignsSection(brand: brand, bc: bc),
              const SizedBox(height: 40),
              _RecentCollaborationsSection(brand: brand, bc: bc),
              const SizedBox(height: 40),
              _TeamSection(brand: brand, bc: bc, wide: wide),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Cover + Identity Hero ────────────────────────────────────────────────────

class _CoverHero extends StatelessWidget {
  const _CoverHero({required this.brand, required this.bc, required this.wide});
  final BrandProfile brand;
  final BarterColors bc;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cover image
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: wide ? 240 : 160,
            width: double.infinity,
            child: BarterNetworkImage(
              url: brand.coverUrl,
              fit: BoxFit.cover,
              memCacheWidth: 1200,
              memCacheHeight: 480,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LogoAvatar(brand: brand, bc: bc),
              const SizedBox(width: 24),
              Expanded(child: _IdentityText(brand: brand, bc: bc)),
              _ActionButtons(brand: brand, bc: bc),
            ],
          )
        else ...[
          _LogoAvatar(brand: brand, bc: bc),
          const SizedBox(height: 16),
          _IdentityText(brand: brand, bc: bc),
          const SizedBox(height: 16),
          _ActionButtons(brand: brand, bc: bc),
        ],
      ],
    );
  }
}

class _LogoAvatar extends StatelessWidget {
  const _LogoAvatar({required this.brand, required this.bc});
  final BrandProfile brand;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.12),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BarterNetworkImage(
          url: brand.logoUrl,
          fit: BoxFit.contain,
          memCacheWidth: 176,
          memCacheHeight: 176,
        ),
      ),
    );
  }
}

class _IdentityText extends StatelessWidget {
  const _IdentityText({required this.brand, required this.bc});
  final BrandProfile brand;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              brand.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (brand.verified) ...[
              const SizedBox(width: 8),
              Icon(Symbols.verified, color: bc.primary, size: 22, fill: 1),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          brand.tagline,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MetaChip(icon: Symbols.location_on, label: brand.location, bc: bc),
            _MetaChip(icon: Symbols.business, label: brand.industry, bc: bc),
            _MetaChip(icon: Symbols.calendar_today, label: 'Since ${brand.founded}', bc: bc),
            _MetaChip(icon: Symbols.language, label: brand.website.replaceFirst('https://', ''), bc: bc),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: brand.niches
              .map((n) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: bc.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      n,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.brand, required this.bc});
  final BrandProfile brand;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: () => context.push('/brand/campaigns/create'),
          icon: const Icon(Symbols.add, size: 18),
          label: const Text('New Campaign'),
          style: ElevatedButton.styleFrom(
            backgroundColor: bc.primary,
            foregroundColor: bc.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => context.push('/brand/analytics'),
          icon: Icon(Symbols.analytics, size: 18, color: bc.onSurface),
          label: const Text('Analytics'),
          style: OutlinedButton.styleFrom(
            foregroundColor: bc.onSurface,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: bc.outlineVariant),
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, required this.bc});
  final IconData icon;
  final String label;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: bc.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: bc.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

// ─── Stats Row ───────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.brand, required this.bc, required this.wide});
  final BrandProfile brand;
  final BarterColors bc;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final stats = brand.stats;
    final items = [
      ('${stats.activeCampaigns}', 'Active\nCampaigns', Symbols.campaign),
      ('${stats.totalCollaborations}', 'Total\nCollabs', Symbols.handshake),
      ('${stats.creatorsWorkedWith}', 'Creators\nPartnered', Symbols.group),
      ('₹${(stats.avgBarterValue / 1000).toStringAsFixed(1)}K', 'Avg Barter\nValue', Symbols.payments),
      ('${(stats.totalReach / 1000000).toStringAsFixed(1)}M', 'Total\nReach', Symbols.visibility),
      ('${stats.avgEngagementRate}%', 'Avg\nEngagement', Symbols.trending_up),
    ];

    if (wide) {
      return Row(
        children: items
            .map((item) => Expanded(child: _StatCard(value: item.$1, label: item.$2, icon: item.$3, bc: bc)))
            .expand((w) => [w, const SizedBox(width: 16)])
            .toList()
          ..removeLast(),
      );
    }

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.95,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) => _StatCard(value: item.$1, label: item.$2, icon: item.$3, bc: bc)).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.icon, required this.bc});
  final String value;
  final String label;
  final IconData icon;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.onSurfaceVariant,
                  height: 1.3,
                ),
          ),
        ],
      ),
    );
  }
}

// ─── Barter Score ────────────────────────────────────────────────────────────

class _BarterScoreSection extends StatelessWidget {
  const _BarterScoreSection({required this.brand, required this.bc, required this.wide});
  final BrandProfile brand;
  final BarterColors bc;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final score = brand.barterScore;
    final metrics = [
      ('Payment Reliability', score.paymentReliability),
      ('Communication', score.communication),
      ('Brief Clarity', score.briefClarity),
      ('Repeat Collab Rate', score.repeatRate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Barter Score',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        BarterCard(
          padding: const EdgeInsets.all(28),
          borderRadius: 24,
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ScoreRing(score: score, bc: bc),
                    const SizedBox(width: 40),
                    Expanded(child: _ScoreMetrics(metrics: metrics, bc: bc, badges: brand.badges)),
                  ],
                )
              : Column(
                  children: [
                    _ScoreRing(score: score, bc: bc),
                    const SizedBox(height: 28),
                    _ScoreMetrics(metrics: metrics, bc: bc, badges: brand.badges),
                  ],
                ),
        ),
      ],
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.score, required this.bc});
  final BrandBarterScore score;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: score.overall / 100,
                  strokeWidth: 10,
                  backgroundColor: bc.outlineVariant.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(bc.primary),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${score.overall}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: bc.primary,
                        ),
                  ),
                  Text(
                    '/ 100',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: bc.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            score.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: bc.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}

class _ScoreMetrics extends StatelessWidget {
  const _ScoreMetrics({required this.metrics, required this.bc, required this.badges});
  final List<(String, int)> metrics;
  final BarterColors bc;
  final List<BrandBadge> badges;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...metrics.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m.$1, style: Theme.of(context).textTheme.bodyMedium),
                      Text(
                        '${m.$2}%',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: bc.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: m.$2 / 100,
                      minHeight: 6,
                      backgroundColor: bc.outlineVariant.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(bc.primary),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: badges
              .map((b) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Symbols.verified, size: 14, color: bc.primary),
                        const SizedBox(width: 6),
                        Text(
                          b.label,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ─── About ───────────────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.brand, required this.bc});
  final BrandProfile brand;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        BarterCard(
          padding: const EdgeInsets.all(24),
          borderRadius: 20,
          child: Text(
            brand.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ),
      ],
    );
  }
}

// ─── Active Campaigns ─────────────────────────────────────────────────────────

class _ActiveCampaignsSection extends StatelessWidget {
  const _ActiveCampaignsSection({required this.brand, required this.bc});
  final BrandProfile brand;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Active Campaigns',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => context.push('/brand/campaigns'),
              child: Text('View All →',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: bc.primary, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: brand.activeCampaignPreviews.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              final c = brand.activeCampaignPreviews[i];
              return _CampaignCard(campaign: c, bc: bc);
            },
          ),
        ),
      ],
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.campaign, required this.bc});
  final CampaignPreview campaign;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final isFilling = campaign.status == 'Filling';
    return SizedBox(
      width: 240,
      child: BarterCard(
        padding: EdgeInsets.zero,
        borderRadius: 20,
        onTap: () => context.push('/brand/campaigns'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: bc.primaryContainer.withValues(alpha: 0.2)),
                    Center(child: Icon(Symbols.campaign, color: bc.primary.withValues(alpha: 0.4), size: 40)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isFilling
                              ? bc.error.withValues(alpha: 0.1)
                              : bc.tertiary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          campaign.status,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: isFilling ? bc.error : bc.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        campaign.barterValue,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: bc.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    campaign.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${campaign.applicants} applicants · ${campaign.spots} spots',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Recent Collaborations ────────────────────────────────────────────────────

class _RecentCollaborationsSection extends StatelessWidget {
  const _RecentCollaborationsSection({required this.brand, required this.bc});
  final BrandProfile brand;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Collaborations',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...brand.recentCollaborations.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CollabTile(collab: c, bc: bc),
            )),
      ],
    );
  }
}

class _CollabTile extends StatelessWidget {
  const _CollabTile({required this.collab, required this.bc});
  final RecentCollaboration collab;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(shape: BoxShape.circle, color: bc.surfaceContainer),
            child: ClipOval(
              child: BarterNetworkImage(
                url: collab.creatorAvatar,
                fit: BoxFit.cover,
                memCacheWidth: 96,
                memCacheHeight: 96,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(collab.creatorName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text(collab.campaignTitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Symbols.star, size: 14, color: bc.tertiary, fill: 1),
                  const SizedBox(width: 4),
                  Text(collab.rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: bc.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  collab.niche,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Team Section ─────────────────────────────────────────────────────────────

class _TeamSection extends StatelessWidget {
  const _TeamSection({required this.brand, required this.bc, required this.wide});
  final BrandProfile brand;
  final BarterColors bc;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Meet the Team',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: brand.team
                .map((m) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _ManagerCard(manager: m, bc: bc),
                      ),
                    ))
                .toList(),
          )
        else
          ...brand.team.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ManagerCard(manager: m, bc: bc),
              )),
      ],
    );
  }
}

class _ManagerCard extends StatelessWidget {
  const _ManagerCard({required this.manager, required this.bc});
  final BrandManager manager;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      onTap: () => context.push('/brand/manager/${manager.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(shape: BoxShape.circle, color: bc.surfaceContainer),
                child: ClipOval(
                  child: BarterNetworkImage(
                    url: manager.avatarUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 112,
                    memCacheHeight: 112,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(manager.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text(manager.role,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Symbols.chevron_right, color: bc.onSurfaceVariant.withValues(alpha: 0.45)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MiniStat(label: 'Deals', value: '${manager.dealsManaged}', bc: bc),
              const SizedBox(width: 16),
              _MiniStat(label: 'Active', value: '${manager.activeCampaigns}', bc: bc),
              const SizedBox(width: 16),
              _MiniStat(label: 'Response', value: manager.responseTime, bc: bc),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.bc});
  final String label;
  final String value;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
        Text(label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant)),
      ],
    );
  }
}
