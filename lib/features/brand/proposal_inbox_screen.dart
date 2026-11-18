import '../../widgets/barter_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_network_image.dart';

class ProposalInboxScreen extends ConsumerWidget {
  const ProposalInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final inboxAsync = ref.watch(brandInboxProvider(null));

    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const BarterLogo(height: 28),
        actions: [
          IconButton(
            icon: Icon(Symbols.notifications, color: bc.onBackground.withValues(alpha: 0.6)),
            onPressed: () => context.push('/notifications/center'),
          ),
        ],
      ),
      body: inboxAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (proposals) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
              sliver: SliverToBoxAdapter(child: _EditorialHeader()),
            ),
            if (proposals.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('No proposals yet')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList.separated(
                  itemCount: proposals.length,
                  itemBuilder: (context, index) {
                    final p = proposals[index];
                    final status = p['status'] as String? ?? 'pending';
                    final name = p['creator_name'] as String? ??
                        p['creator_username'] as String? ?? 'Creator';
                    final imageUrl = p['creator_avatar_url'] as String? ?? '';
                    final proposalId = p['id']?.toString() ?? '';
                    final barterScore = p['barter_score']?.toString() ?? '--';
                    final igFollowers = p['ig_followers']?.toString() ?? '--';
                    final tiktokFollowers = p['tiktok_followers']?.toString() ?? '--';
                    final engagement = p['engagement_rate']?.toString() ?? '--';
                    final verified = p['is_verified'] as bool? ?? false;

                    if (status == 'declined') {
                      return _DeclinedCard(
                        name: name,
                        declinedAgo: p['declined_at'] as String? ?? 'Declined',
                        imageUrl: imageUrl,
                      );
                    }
                    return _ProposalCard(
                      proposalId: proposalId,
                      name: name,
                      verified: verified,
                      badge: status == 'pending' ? 'New Application' : status.toUpperCase(),
                      badgePrimary: status == 'accepted',
                      imageUrl: imageUrl,
                      stats: [
                        _StatItem(label: 'IG Followers', value: igFollowers, highlight: false),
                        _StatItem(label: 'TikTok', value: tiktokFollowers, highlight: false),
                        _StatItem(label: 'Engagement', value: engagement, highlight: false),
                        _StatItem(label: 'Barter Score', value: barterScore, highlight: true),
                      ],
                      rotate: index.isEven ? 6.0 : -3.0,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 48),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

class _EditorialHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2,
                  height: 1.05,
                  color: bc.onBackground,
                ),
            children: [
              const TextSpan(text: 'PROPOSAL\n'),
              TextSpan(
                text: 'INBOX',
                style: TextStyle(color: bc.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Review incoming creator partnerships for your Fall campaign.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _StatItem {
  const _StatItem({required this.label, required this.value, required this.highlight});
  final String label;
  final String value;
  final bool highlight;
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({
    required this.proposalId,
    required this.name,
    required this.verified,
    required this.badge,
    required this.badgePrimary,
    required this.imageUrl,
    required this.stats,
    required this.rotate,
  });

  final String proposalId;
  final String name;
  final bool verified;
  final String badge;
  final bool badgePrimary;
  final String imageUrl;
  final List<_StatItem> stats;
  final double rotate;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -16,
            right: -16,
            child: Transform.rotate(
              angle: rotate * 3.14159 / 180,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: bc.surfaceContainerLowest, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: bc.onBackground.withValues(alpha: 0.15),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BarterNetworkImage(url: imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (verified) ...[
                      const SizedBox(width: 8),
                      Icon(Symbols.verified, color: bc.tertiary, size: 20, fill: 1),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgePrimary ? bc.tertiaryContainer : bc.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: badgePrimary ? bc.onTertiaryContainer : bc.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 10,
                        ),
                  ),
                ),
                const SizedBox(height: 32),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: stats.map((s) => _StatTile(stat: s)).toList(),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/deal/$proposalId/review'),
                    icon: const Icon(Symbols.handshake, size: 20),
                    label: const Text('Accept Proposal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bc.primary,
                      foregroundColor: bc.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 4,
                      shadowColor: bc.primary.withValues(alpha: 0.2),
                      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.push('/deal/$proposalId/counter-offer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bc.surfaceContainerHigh,
                          foregroundColor: bc.onBackground,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          textStyle: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Counter'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Proposal declined')),
                          );
                          context.pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: bc.onSurfaceVariant,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: BorderSide(
                            color: bc.outlineVariant.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          textStyle: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Decline'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});
  final _StatItem stat;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: stat.highlight
            ? bc.primary.withValues(alpha: 0.05)
            : bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: stat.highlight
            ? Border.all(color: bc.primary.withValues(alpha: 0.1))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: stat.highlight ? bc.primary : bc.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 9,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: stat.highlight ? bc.primary : bc.onBackground,
                ),
          ),
        ],
      ),
    );
  }
}

class _DeclinedCard extends StatelessWidget {
  const _DeclinedCard({
    required this.name,
    required this.declinedAgo,
    required this.imageUrl,
  });

  final String name;
  final String declinedAgo;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Opacity(
      opacity: 0.8,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLow,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: BarterNetworkImage(url: imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    declinedAgo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: bc.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Icon(Symbols.close, color: bc.outline),
          ],
        ),
      ),
    );
  }
}
