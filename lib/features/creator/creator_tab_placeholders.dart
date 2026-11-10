import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/dto/deal_dto.dart';
import '../../data/dto/drops_dto.dart';
import '../../data/models/offer_model.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_network_image.dart';

class CreatorDropsTabScreen extends ConsumerWidget {
  const CreatorDropsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final theme = Theme.of(context);
    final dropsAsync = ref.watch(dropsProvider);
    final offersAsync = ref.watch(offersProvider);

    return Scaffold(
      backgroundColor: bc.background,
      body: CustomScrollView(
        slivers: [
          const _CreatorTabAppBar(),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editorial Header
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.onSurface,
                        height: 1.1,
                      ),
                      children: [
                        const TextSpan(text: 'The '),
                        TextSpan(
                          text: 'Feed',
                          style: TextStyle(color: bc.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Curated brand exchanges for elite storytellers.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: bc.secondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search brands, niches, or keywords...',
                        hintStyle: TextStyle(color: bc.outline.withValues(alpha: 0.6)),
                        prefixIcon: Icon(Icons.search, color: bc.outline),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Barter Drops Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: bc.onBackground,
                          ),
                          children: [
                            const TextSpan(text: 'Barter '),
                            TextSpan(
                              text: 'Drops',
                              style: TextStyle(
                                color: bc.primary,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/creator/feed'),
                        child: Text(
                          'View All',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: bc.tertiary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Drop Cards Horizontal — live data
                  dropsAsync.when(
                    loading: () => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Text('$e',
                        style: TextStyle(color: bc.error)),
                    data: (drops) => drops.isEmpty
                        ? Text('No drops available',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: bc.onSurfaceVariant))
                        : SizedBox(
                            height: 200,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: drops.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 24),
                              itemBuilder: (context, i) =>
                                  _DropCard(bc: bc, theme: theme, drop: drops[i]),
                            ),
                          ),
                  ),
                  const SizedBox(height: 40),

                  // Featured Exchanges Section
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: bc.onBackground,
                      ),
                      children: [
                        const TextSpan(text: 'Featured '),
                        TextSpan(
                          text: 'Exchanges',
                          style: TextStyle(
                              color: bc.secondary.withValues(alpha: 0.5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Offer Cards — live data
                  offersAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('$e',
                        style: TextStyle(color: bc.error)),
                    data: (payload) {
                      final offers = payload.offers;
                      if (offers.isEmpty) {
                        return Text('No offers available',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: bc.onSurfaceVariant));
                      }
                      return Column(
                        children: [
                          for (int i = 0; i < offers.length; i++) ...[
                            if (i > 0) const SizedBox(height: 24),
                            _OfferCard(bc: bc, theme: theme, offer: offers[i]),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropCard extends StatelessWidget {
  const _DropCard({
    required this.bc,
    required this.theme,
    required this.drop,
  });

  final BarterColors bc;
  final ThemeData theme;
  final DropsCampaignDto drop;

  @override
  Widget build(BuildContext context) {
    final slots = drop.slotsRemaining ?? (drop.totalSlots - drop.filledSlots);
    final isEndingSoon = slots <= 5;
    final badge = slots > 0 ? '$slots Slots Left' : 'Full';
    final value = drop.estimatedValue != null && drop.estimatedValue! > 0
        ? '${drop.currency ?? 'INR'} ${drop.estimatedValue!.toStringAsFixed(0)}'
        : drop.currency ?? 'INR';

    return GestureDetector(
      onTap: () => context.push('/creator/feed'),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: bc.onSurface.withValues(alpha: 0.06),
              blurRadius: 40,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isEndingSoon
                        ? bc.error.withValues(alpha: 0.15)
                        : bc.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: isEndingSoon ? bc.onError : bc.onPrimary,
                    size: 24,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isEndingSoon
                        ? bc.error.withValues(alpha: 0.1)
                        : bc.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isEndingSoon ? bc.error : bc.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              drop.brandName ?? drop.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: bc.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              drop.title ?? drop.name,
              style: theme.textTheme.bodySmall?.copyWith(color: bc.secondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Value Drop',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: bc.outline,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.bc,
    required this.theme,
    required this.offer,
  });

  final BarterColors bc;
  final ThemeData theme;
  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/creator/offer/${offer.id}'),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: bc.onSurface.withValues(alpha: 0.03),
              blurRadius: 50,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: bc.surfaceContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: offer.brandLogoUrl.isNotEmpty
                              ? BarterNetworkImage(
                                  url: offer.brandLogoUrl,
                                  fit: BoxFit.cover,
                                  memCacheWidth: 112,
                                  memCacheHeight: 112,
                                )
                              : Center(
                                  child: Text(
                                    offer.brandName.isNotEmpty
                                        ? offer.brandName[0].toUpperCase()
                                        : '?',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: bc.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    offer.brandName,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: bc.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: bc.tertiaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    offer.offerTypeLabel.toUpperCase(),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: bc.onTertiaryContainer,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              offer.verifiedLabel,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: bc.secondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: bc.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified, size: 16, color: bc.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Live',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: bc.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Offer Title
            Text(
              offer.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: bc.onSurface,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            // Value & Requirement Tags
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: bc.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.payments, color: bc.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        offer.estimatedValueLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: bc.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (offer.requirementTags.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.videocam, color: bc.tertiary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          offer.requirementTags.first,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: bc.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // View Offer Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/creator/offer/${offer.id}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: offer.invertedCta ? bc.onBackground : bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'View Offer',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreatorDealsTabScreen extends ConsumerWidget {
  const CreatorDealsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final theme = Theme.of(context);
    final dealsAsync = ref.watch(myDealsProvider);
    
    return Scaffold(
      backgroundColor: bc.background,
      body: CustomScrollView(
        slivers: [
          const _CreatorTabAppBar(),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editorial Header
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.onSurface,
                        height: 1.1,
                      ),
                      children: [
                        const TextSpan(text: 'Your '),
                        TextSpan(
                          text: 'Deals',
                          style: TextStyle(color: bc.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track and manage your active partnerships.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: bc.secondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Stats Overview — live counts
                  dealsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('$e'),
                    data: (deals) {
                      final active    = deals.where((d) => d.status == 'active').length;
                      final pending   = deals.where((d) => d.status == 'pending_membership' || d.status == 'delivered').length;
                      final completed = deals.where((d) => d.status == 'complete').length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildStatCard(context, bc, theme, label: 'Active',    value: '$active',    color: bc.primary)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard(context, bc, theme, label: 'Pending',   value: '$pending',   color: bc.tertiary)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard(context, bc, theme, label: 'Completed', value: '$completed', color: bc.secondary)),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Active Deals', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: bc.onBackground)),
                              TextButton(
                                onPressed: () => context.push('/creator/feed'),
                                child: Text('View All', style: theme.textTheme.labelMedium?.copyWith(color: bc.tertiary, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          if (deals.isEmpty)
                            Center(child: Text('No deals yet', style: theme.textTheme.bodyMedium?.copyWith(color: bc.onSurfaceVariant)))
                          else
                            ...deals.map((deal) => Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _buildDealCard(context, bc, theme,
                                brandName: deal.brandUsername,
                                brandLogo: '',
                                title: deal.offerTitle,
                                status: deal.status.replaceAll('_', ' ').toUpperCase(),
                                statusColor: _statusColor(deal.status, bc),
                                statusTextColor: bc.onPrimary,
                                value: deal.dealFee != null ? '${deal.currency ?? ''} ${deal.dealFee}' : '—',
                                dueDate: deal.deadline ?? deal.createdAt ?? '',
                                onTap: () => context.push('/deal/${deal.id}'),
                              ),
                            )),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: bc.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status, BarterColors bc) {
    switch (status) {
      case 'active':              return bc.primaryContainer;
      case 'complete':            return bc.secondary;
      case 'delivered':           return bc.tertiaryContainer;
      case 'revision_requested':  return bc.error;
      default:                    return bc.surfaceContainerHigh;
    }
  }

  Widget _buildDealCard(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String brandName,
    required String brandLogo,
    required String title,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String value,
    required String dueDate,
    double progress = 0.5,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: bc.onSurface.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: bc.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BarterNetworkImage(
                    url: brandLogo,
                    fit: BoxFit.cover,
                    memCacheWidth: 112,
                    memCacheHeight: 112,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brandName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.onBackground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusTextColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: bc.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: bc.surfaceContainer,
                  valueColor: AlwaysStoppedAnimation<Color>(bc.primary),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Due Date',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dueDate,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: bc.onBackground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Value',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                backgroundColor: bc.surfaceContainerHigh,
                foregroundColor: bc.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                side: BorderSide.none,
              ),
              child: Text(
                'View Deal Room',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class _ProposalData {
  const _ProposalData({
    required this.name,
    required this.isVerified,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.igFollowers,
    required this.tikTok,
    required this.engagement,
    required this.barterScore,
    required this.imageRotation,
    required this.imageUrl,
  });

  final String name;
  final bool isVerified;
  final String badge;
  final Color Function(BarterColors) badgeColor;
  final Color Function(BarterColors) badgeTextColor;
  final String igFollowers;
  final String tikTok;
  final String engagement;
  final String barterScore;
  final double imageRotation;
  final String imageUrl;
}

const _kProposals = [
  _ProposalData(
    name: 'Sienna Rivers',
    isVerified: true,
    badge: 'Pro Creator',
    badgeColor: _bcTertiaryContainer,
    badgeTextColor: _bcOnTertiaryContainer,
    igFollowers: '245K',
    tikTok: '1.2M',
    engagement: '8.4%',
    barterScore: '98',
    imageRotation: 6,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDY6m5l8N-SiaAtzA03YxeMfciCKeLWy31oNacGMdSk1Cl5YgZUSv8cMwrbsOocRctHGi1iusEa5Xy1CSzyzL96oUurmqw3r0Ae-Jxu5bE9pZO9is6VvLTlpHzrNPj0oP4WPcmAzn-jveJtB1Ij28zmgOcelU5u8nHziUMA6RhA7miEGuD_mO9N0m_3zllAp2fehA4bK5YmttG4dWQlMVzzqR91qSYWqOHOkQ17FOdO2d3xzwxbWTlARiWMUV7QCayHTLRT8mDLWEs',
  ),
  _ProposalData(
    name: 'Marcus Tech',
    isVerified: false,
    badge: 'New Application',
    badgeColor: _bcSurfaceContainerHigh,
    badgeTextColor: _bcSecondary,
    igFollowers: '12K',
    tikTok: '89K',
    engagement: '12.1%',
    barterScore: '82',
    imageRotation: -3,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCWpYgBrARt-KWyMxVQzX12IoEjDZBhMtl8-0oJrqbqI8UxchD7jj9Ey9YziiLJgpoBuYPdl_0RZ_mzV4Tfpi80gGnJb8yV9dEE37NCR3KomIGWgwG3bxeRD1Kovn_pNCv9z8UmuUqgo0P8syq1y_zKzgvv9PI6ae79SjR9esgOvT8GGNWz4mkaxB48_qFktdDoegyCB_r6hw2OVTktoBAtVxf1XdKg7hVxKoqYZJrbABjqrioC-A81YuOQgasJ3c4pw1bZfcOChEk',
  ),
];

Color _bcTertiaryContainer(BarterColors bc) => bc.tertiaryContainer;
Color _bcOnTertiaryContainer(BarterColors bc) => bc.onTertiaryContainer;
Color _bcSurfaceContainerHigh(BarterColors bc) => bc.surfaceContainerHigh;
Color _bcSecondary(BarterColors bc) => bc.secondary;

class CreatorInboxTabScreen extends ConsumerWidget {
  const CreatorInboxTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final theme = Theme.of(context);
    final proposalsAsync = ref.watch(proposalsListProvider);
    
    return Scaffold(
      backgroundColor: bc.background,
      body: CustomScrollView(
        slivers: [
          const _CreatorTabAppBar(),

          // Editorial Header
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.onBackground,
                        height: 1.1,
                      ),
                      children: [
                        const TextSpan(text: 'PROPOSAL '),
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          proposalsAsync.when(
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (e, _) => SliverFillRemaining(child: Center(child: Text('$e'))),
            data: (proposals) => proposals.isEmpty
                ? const SliverFillRemaining(child: Center(child: Text('No proposals yet')))
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList.separated(
                      separatorBuilder: (_, __) => const SizedBox(height: 24),
                      itemCount: proposals.length,
                      itemBuilder: (context, i) {
                        final p = proposals[i];
                        return _buildProposalCard(context, bc, theme,
                          name: p.creatorUsername,
                          isVerified: false,
                          badge: p.status.toUpperCase(),
                          badgeColor: bc.tertiaryContainer,
                          badgeTextColor: bc.onTertiaryContainer,
                          igFollowers: '—',
                          tikTok: '—',
                          engagement: '—',
                          barterScore: '—',
                          imageRotation: 0,
                          imageUrl: '',
                          proposalId: p.id,
                          offerTitle: p.offerTitle,
                        );
                      },
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildProposalCard(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String name,
    required bool isVerified,
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
    required String igFollowers,
    required String tikTok,
    required String engagement,
    required String barterScore,
    required double imageRotation,
    required String imageUrl,
    String? proposalId,
    String? offerTitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: bc.onSurface.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator Image Breaking Boundary
          Align(
            alignment: Alignment.topRight,
            child: Transform.rotate(
              angle: imageRotation * 3.14159 / 180,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: bc.surfaceContainerLowest, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: bc.onSurface.withValues(alpha: 0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BarterNetworkImage(
                    url: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 400,
                    memCacheHeight: 400,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Creator Info
          Row(
            children: [
              Text(
                name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: bc.onBackground,
                ),
              ),
              if (isVerified) ...[
                const SizedBox(width: 8),
                Icon(Icons.verified, color: bc.tertiary, size: 20),
              ],
            ],
          ),
          if (offerTitle != null && offerTitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              offerTitle,
              style: theme.textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: theme.textTheme.labelSmall?.copyWith(
                color: badgeTextColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Stats Bento
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildStatBox(context, bc, theme, label: 'IG Followers', value: igFollowers),
              _buildStatBox(context, bc, theme, label: 'TikTok', value: tikTok),
              _buildStatBox(context, bc, theme, label: 'Engagement', value: engagement, isPrimary: true),
              _buildBarterScoreBox(context, bc, theme, value: barterScore),
            ],
          ),
          const SizedBox(height: 32),
          // Actions
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: proposalId != null ? () => context.push('/deal/$proposalId/review') : null,
                icon: const Icon(Icons.handshake),
                label: Text(
                  'Accept Proposal',
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                  shadowColor: bc.primary.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: proposalId != null ? () => context.push('/deal/$proposalId/counter-offer') : null,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: bc.surfaceContainerHigh,
                        foregroundColor: bc.onBackground,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        side: BorderSide.none,
                      ),
                      child: Text(
                        'Counter',
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Proposal declined')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: bc.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Decline',
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String label,
    required String value,
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: bc.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: isPrimary ? bc.primary : bc.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarterScoreBox(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bc.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Barter Score',
            style: theme.textTheme.labelSmall?.copyWith(
              color: bc.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: bc.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class CreatorProfileTabScreen extends StatelessWidget {
  const CreatorProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: bc.background,
      body: CustomScrollView(
        slivers: [
          const _CreatorTabAppBar(),

          // Hero Profile Section
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(child: _buildHeroSection(context, bc, theme)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          // KPI Bento Grid — lazy-loaded cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList.separated(
              itemCount: 3,
              itemBuilder: (context, index) {
                final kpis = [
                  (
                    icon: Icons.camera_alt_outlined,
                    platform: 'Instagram',
                    followers: '1.2M',
                    engagement: '4.8%',
                    reach: '850K',
                    engagementLabel: 'Engagement',
                    reachLabel: 'Avg. Reach',
                  ),
                  (
                    icon: Icons.bolt_outlined,
                    platform: 'TikTok',
                    followers: '2.5M',
                    engagement: '12.4%',
                    reach: '3.1M',
                    engagementLabel: 'Engagement',
                    reachLabel: 'Avg. Reach',
                  ),
                  (
                    icon: Icons.play_circle_outline,
                    platform: 'YouTube',
                    followers: '450K',
                    engagement: '9.1%',
                    reach: '125K',
                    engagementLabel: 'CTR',
                    reachLabel: 'Views/Vid',
                  ),
                ];
                final k = kpis[index];
                return _buildKPICard(
                  context, bc, theme,
                  icon: k.icon,
                  platform: k.platform,
                  followers: k.followers,
                  engagement: k.engagement,
                  reach: k.reach,
                  engagementLabel: k.engagementLabel,
                  reachLabel: k.reachLabel,
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 16),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          // Membership Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(child: _buildMembershipSection(context, bc, theme)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          // Deal History Section (already uses horizontal ListView.builder internally)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(child: _buildDealHistorySection(context, bc, theme)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, BarterColors bc, ThemeData theme) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: bc.surfaceContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: bc.onSurface.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: BarterNetworkImage(
                      url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCHeYJCGsJh92o1tQtWI4nkcknCt5-VYNTTfjhOi32iLHDj65Z3VQwMrAXLQb_Dv2RH9khpvUR5m4eFoaruWst4A0P6PA0duZ8Znm4Cz9CQOL9V_YKYDgRtk0KZfkGSWaWFOMUezlgxy39fyr0Guy8aYDyntSvxh9dkhu2nZJdiFFH8T-pRGId4xhJnWjKl8vdZ9p2VGxBzCR_YLeusHALMQqs8zzaoYkk_CSVJ7NdHDGdKTHU3enX8OwnNwM5gNvq1wcqkcJ9DXno',
                      fit: BoxFit.cover,
                      memCacheWidth: 240,
                      memCacheHeight: 240,
                    ),
                  ),
                ),
                // Verified Badge
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: bc.tertiaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: bc.onSurface.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, size: 14, color: bc.onTertiaryContainer),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: bc.onTertiaryContainer,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.onBackground,
                      ),
                      children: [
                        const TextSpan(text: 'Maya '),
                        TextSpan(
                          text: 'Sterling',
                          style: TextStyle(color: bc.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Digital Storyteller & Tech Enthusiast',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: bc.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Crafting high-end editorial content for brands that value authenticity and visual excellence. Specializing in lifestyle tech and sustainable fashion.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: bc.onSurfaceVariant,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.push('/creator/feed'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bc.primary,
                          foregroundColor: bc.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                          shadowColor: bc.primary.withValues(alpha: 0.2),
                        ),
                        child: Text(
                          'Request Barter',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Messaging coming soon')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: bc.surfaceContainerHigh,
                          foregroundColor: bc.onSurface,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          side: BorderSide.none,
                        ),
                        child: Text(
                          'Message',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Barter Score Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: bc.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: bc.onSurface.withValues(alpha: 0.06),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Barter Score',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: bc.secondary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '98',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Top 1% Creator',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: bc.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembershipSection(BuildContext context, BarterColors bc, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: bc.onSurface.withValues(alpha: 0.06),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bc.primaryFixed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.workspace_premium, color: bc.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Membership',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Free • 30 points earned',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'FREE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 8,
              backgroundColor: bc.surfaceContainerHigh,
              color: bc.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You're 20 pts away from 1 month Pro.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: bc.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/creator/membership/earn'),
              style: ElevatedButton.styleFrom(
                backgroundColor: bc.primary,
                foregroundColor: bc.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: const Text('Earn more months'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required IconData icon,
    required String platform,
    required String followers,
    required String engagement,
    required String reach,
    required String engagementLabel,
    required String reachLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: bc.primary, size: 24),
              ),
              Text(
                platform,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            followers,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Followers',
            style: theme.textTheme.bodyMedium?.copyWith(color: bc.secondary),
          ),
          const SizedBox(height: 16),
          Divider(color: bc.outlineVariant.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      engagement,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      engagementLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reach,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: bc.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      reachLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        letterSpacing: 0.5,
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

  Widget _buildDealHistorySection(BuildContext context, BarterColors bc, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Deal History',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '142 Successful Exchanges',
              style: theme.textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              final deals = [
                {
                  'brand': 'LuxeTech',
                  'category': 'Tech & Gadgets',
                  'title': 'Quantum Series Launch Campaign',
                  'description': 'High-performance video series demonstrating daily integration of the Quantum 5 ecosystem.',
                  'rating': '5.0',
                  'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDyPYZKUfpQ9kvvPt1qcS0iOUEtQzFCxpUDp_Ouoj2xKx8dNsJoOwQJRIwv6GVuz-m4ghJZJq07hGxvAtWdiiOFxBiFv3gHjIeov8izvkxTTrP7Qa0A8VOIf4yBLiwRY71GuTRlOb8lv_TGG6J81grAkllxpV6pxkdnslSAOHFC5Ce6qIi4dKE72H-d1rtd1HPWUixHEbHXeE4-qzJLv5u7RGW_ZWUTe0B4zxSXags4RbELgcFfuDs9tsbsyiZZ8ws6FRZNUm9Xff8',
                },
                {
                  'brand': 'Aether',
                  'category': 'Fashion',
                  'title': 'Aesthetic Footwear Editorial',
                  'description': 'Creative lookbook and lifestyle shots for the Sustainable Step collection.',
                  'rating': '4.9',
                  'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBToh0F-MrjKT1r1O_lmTOA_0mHB6n_TJdJ3a9zRoaX7Yp9QuHOH-I2jl47IL3Q6Wjhb180wCBh159LeKM4eGsI4ALnpVXD44uLtt4ywDGSTh5L6IlRf1HKLY4-VLx2PCTYo0ORsMLeJLjtb5mmnVuPHfcEAWGeaV6xXXq4q-XrnBFTgEsBmmdcLDLCo1_JsFvlMx4-k0VdO9V3gGmDZdQ9T7NYowyDA1BJmuZ-vOscA2fVz6HTmHlgsUgabVRSV7aKRYuTxFJVk_0',
                },
                {
                  'brand': 'Nook',
                  'category': 'Home Decor',
                  'title': 'Minimalist Home Integration',
                  'description': 'Strategic placement of Nook essentials in a modern creator studio environment.',
                  'rating': '5.0',
                  'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuChF02KUs3rz3G7B1crSCnTKkjD7if1u5TpplyO6mG5VdpPMirzM4JVaabhCZ4sjKi0dekqMT_Qy6-tPXcUxq_Z-OzMe7kIXYGUjH2UyECvsdzvmgVz8UmW9-KY1_G4yoHbcdMUsW0_SOJBP2Fb7k1byV1DbkvEge3-3SbB5A9wihtgCFrTTA0oTMUQUbq9fMVg9VPVZ5l03Ap0q-60shQkkfG5BR_IDuMuh8oKPpnOzb22qav6F5Evr7eKbUKtm24Bsk2VU9DH8pg',
                },
              ];
              final deal = deals[index];
              
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          child: BarterNetworkImage(
                            url: deal['image'] as String,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            memCacheWidth: 640,
                            memCacheHeight: 320,
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: bc.background.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              deal['brand'] as String,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                deal['category'] as String,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: bc.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 16, color: bc.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    deal['rating'] as String,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            deal['title'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            deal['description'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: bc.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CreatorTabAppBar extends StatelessWidget {
  const _CreatorTabAppBar();

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Container(
        color: bc.surface,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'BARTER',
              style: theme.textTheme.titleLarge?.copyWith(
                color: bc.primary,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: bc.onSurface),
              onPressed: () => GoRouter.of(context).push('/notifications/center'),
            ),
          ],
        ),
      ),
    );
  }
}
