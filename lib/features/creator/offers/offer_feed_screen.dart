import '../../../widgets/barter_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/dto/drops_dto.dart';
import '../../../data/models/offer_model.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_network_image.dart';

class OfferFeedScreen extends ConsumerWidget {
  const OfferFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final offersAsync = ref.watch(offersProvider);
    final dropsAsync = ref.watch(dropsProvider);

    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: CircleAvatar(backgroundColor: bc.surfaceContainerHighest),
        title: const BarterLogo(height: 28),
        actions: [
          IconButton(
            icon: Icon(Symbols.notifications, color: bc.onBackground),
            onPressed: () => context.push('/notifications/center'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderSection(bc: bc),
                  const SizedBox(height: 32),
                  _SearchSection(bc: bc),
                  const SizedBox(height: 32),
                  _FilterChips(bc: bc),
                  const SizedBox(height: 48),
                  dropsAsync.when(
                    loading: () => const SizedBox(
                      height: 180,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (drops) => drops.isEmpty
                        ? const SizedBox.shrink()
                        : _DropsSection(bc: bc, drops: drops),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
          offersAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Center(child: Text('Failed to load offers: $e')),
            ),
            data: (payload) => _FeaturedExchangesSection(
              bc: bc,
              offers: payload.offers,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1,
            ),
        children: [
          const TextSpan(text: 'The '),
          TextSpan(
            text: 'Feed',
            style: TextStyle(color: bc.primary),
          ),
        ],
      ),
    );
  }
}

class _SearchSection extends StatelessWidget {
  const _SearchSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search brands, niches, or keywords...',
          hintStyle: TextStyle(color: bc.outline.withValues(alpha: 0.6)),
          prefixIcon: Icon(Symbols.search, color: bc.outline),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _BarterChip(
            label: 'Type: SaaS',
            bc: bc,
            icon: Symbols.filter_list,
            isPrimary: true,
          ),
          const SizedBox(width: 12),
          _BarterChip(label: 'Value: \$500+', bc: bc),
          const SizedBox(width: 12),
          _BarterChip(label: 'Niche: Tech', bc: bc),
          const SizedBox(width: 12),
          _BarterChip(label: 'Platform: IG', bc: bc),
        ],
      ),
    );
  }
}

class _BarterChip extends StatelessWidget {
  const _BarterChip({
    required this.label,
    required this.bc,
    this.icon,
    this.isPrimary = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  });

  final String label;
  final BarterColors bc;
  final IconData? icon;
  final bool isPrimary;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isPrimary ? bc.primary : bc.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: isPrimary ? bc.onPrimary : bc.onSurface, size: 18),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isPrimary ? bc.onPrimary : bc.onSurface,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _DropsSection extends StatelessWidget {
  const _DropsSection({required this.bc, required this.drops});

  final BarterColors bc;
  final List<DropsCampaignDto> drops;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                children: [
                  const TextSpan(text: 'Barter '),
                  TextSpan(
                    text: 'Drops',
                    style: TextStyle(
                      color: bc.primary,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'View All',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: bc.tertiary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: drops.length,
            separatorBuilder: (_, __) => const SizedBox(width: 24),
            itemBuilder: (context, i) {
              final d = drops[i];
              final slotsLeft = d.totalSlots - d.filledSlots;
              final isEndingSoon = d.status == 'ending_soon' || d.status == 'closing';
              return _DropCard(
                title: d.name,
                subtitle: d.brandName ?? d.goal,
                value: '${d.totalSlots} Slots',
                badge: isEndingSoon ? 'Ending Soon' : '$slotsLeft Slots Left',
                badgeColor: isEndingSoon ? bc.error : bc.primary,
                icon: Symbols.auto_awesome,
                iconColor: bc.tertiary,
                bc: bc,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DropCard extends StatelessWidget {
  const _DropCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.badge,
    required this.badgeColor,
    required this.icon,
    required this.iconColor,
    required this.bc,
  });

  final String title;
  final String subtitle;
  final String value;
  final String badge;
  final Color badgeColor;
  final IconData icon;
  final Color iconColor;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
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
                  color: bc.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              _BarterBadge(label: badge, bc: bc, color: badgeColor),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: bc.secondary,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                'Value Drop',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.outline,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontSize: 10,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeaturedExchangesSection extends StatelessWidget {
  const _FeaturedExchangesSection({required this.bc, required this.offers});

  final BarterColors bc;
  final List<OfferModel> offers;

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('No offers available right now.')),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                children: [
                  const TextSpan(text: 'Featured '),
                  TextSpan(
                    text: 'Exchanges',
                    style: TextStyle(color: bc.secondary.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverList.separated(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final o = offers[index];
              return _OfferCard(
                offerId: o.id,
                brandLogo: o.brandLogoUrl,
                brandName: o.brandName,
                brandType: o.offerTypeLabel,
                brandTypeColor: bc.tertiaryContainer,
                brandDescription: o.verifiedLabel,
                title: o.title,
                description: o.heroSubtitle ?? '',
                value: o.estimatedValueLabel,
                deliverable: o.requirementTags.isNotEmpty
                    ? o.requirementTags.first
                    : 'See offer',
                deliverableIcon: Symbols.videocam,
                isFeatured: index == 0,
                bc: bc,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.offerId,
    required this.brandLogo,
    required this.brandName,
    required this.brandType,
    required this.brandTypeColor,
    required this.brandDescription,
    required this.title,
    required this.description,
    required this.value,
    required this.deliverable,
    required this.deliverableIcon,
    required this.isFeatured,
    required this.bc,
  });

  final String offerId;
  final String brandLogo;
  final String brandName;
  final String brandType;
  final Color brandTypeColor;
  final String brandDescription;
  final String title;
  final String description;
  final String value;
  final String deliverable;
  final IconData deliverableIcon;
  final bool isFeatured;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isFeatured ? bc.surfaceContainerLowest : bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(40),
        border: isFeatured
            ? Border.all(color: bc.outlineVariant.withValues(alpha: 0.05))
            : Border.all(color: bc.outlineVariant.withValues(alpha: 0.1)),
        boxShadow: isFeatured
            ? [
                BoxShadow(
                  color: bc.onBackground.withValues(alpha: 0.03),
                  blurRadius: 50,
                  offset: const Offset(0, 20),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isFeatured ? bc.surfaceContainer : bc.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BarterNetworkImage(
                        url: brandLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            brandName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 8),
                          _BarterBadge(label: brandType, bc: bc, color: brandTypeColor, radius: 4),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        brandDescription,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: bc.secondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isFeatured)
                _BarterBadge(
                  label: 'Good match',
                  bc: bc,
                  color: bc.primary,
                  icon: Symbols.verified,
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: bc.secondary,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _BarterChip(
                label: value,
                bc: bc,
                icon: Symbols.payments,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              const SizedBox(width: 12),
              _BarterChip(
                label: deliverable,
                bc: bc,
                icon: deliverableIcon,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _PlatformAvatar(label: 'IG', bc: bc, bgColor: bc.surfaceVariant),
                  const SizedBox(width: 8),
                  _PlatformAvatar(label: 'TT', bc: bc, bgColor: bc.onBackground),
                ],
              ),
              ElevatedButton(
                onPressed: () => context.push('/creator/offers/$offerId'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  elevation: 8,
                  shadowColor: bc.primary.withValues(alpha: 0.2),
                ),
                child: Text(
                  'View Offer',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarterBadge extends StatelessWidget {
  const _BarterBadge({
    required this.label,
    required this.bc,
    required this.color,
    this.icon,
    this.radius = 999,
  });

  final String label;
  final BarterColors bc;
  final Color color;
  final IconData? icon;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

class _PlatformAvatar extends StatelessWidget {
  const _PlatformAvatar({
    required this.label,
    required this.bc,
    required this.bgColor,
  });

  final String label;
  final BarterColors bc;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: bc.surface, width: 2),
      ),
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.surface,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
        ),
      ),
    );
  }
}

