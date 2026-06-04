import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_network_image.dart';

class OfferFeedScreen extends StatelessWidget {
  const OfferFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bc.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: BarterNetworkImage(
              url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBISmviadGA4tpxvl0mmaCC53za3ZXBCiy_ij9Cynr6qbodiT9ABmKsDNP7lkxODRBfh3QWXaAskuN19WEmtovgFai6xUL3OgZdVjDitV8WKs1cyxtWsd_RMR6Mq-4-YieCG_fExQP3bpwnkDkLg_xqWhX5poHGddZrBcekMMMxD8pLWeilbRbAocWhBplqOJMn4Z0ufP9bYi_cyijRREWOohcAz-rEiMoj1KO7QdTk5ZsaWDKeG8sNynbIXiah3_aI7VJvjrMwlhQ',
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          'BARTER',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: bc.primary,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: -1,
              ),
        ),
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
                  _DropsSection(bc: bc),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
          // Lazy-loaded featured exchange cards
          _FeaturedExchangesSection(bc: bc),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: bc.primary,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                Icon(Symbols.filter_list, color: bc.onPrimary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Type: SaaS',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: bc.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _Chip(label: 'Value: \$500+', bc: bc),
          const SizedBox(width: 12),
          _Chip(label: 'Niche: Tech', bc: bc),
          const SizedBox(width: 12),
          _Chip(label: 'Platform: IG', bc: bc),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.bc});

  final String label;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: bc.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: bc.onSurface,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

class _DropsSection extends StatelessWidget {
  const _DropsSection({required this.bc});

  final BarterColors bc;

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
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _DropCard(
                title: 'Alpha Wear Pro',
                subtitle: 'Exclusive Gym Launch',
                value: '\$1,200',
                badge: '4 Slots Left',
                badgeColor: bc.primary,
                icon: Symbols.auto_awesome,
                iconColor: bc.tertiary,
                bc: bc,
              ),
              const SizedBox(width: 24),
              _DropCard(
                title: 'Skyline Resorts',
                subtitle: 'Bali Explorer Drop',
                value: '\$4,500',
                badge: 'Ending Soon',
                badgeColor: bc.error,
                icon: Symbols.flight_takeoff,
                iconColor: bc.primary,
                bc: bc,
              ),
            ],
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 10,
                      ),
                ),
              ),
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
  const _FeaturedExchangesSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final offers = [
      (
        brandLogo:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCquinfoPTqPDiR6oc-limfncVK9lRZq1p5nRup5kRBuS0lczo3dV2BWRIko3djLsXLXVs2DDKqG5OAw4aLgkeXA41PHx3RtBBLbiiPITBZNuNfuq-k9fMx4lBwpA2BcPaSekzPW9uY8B_2GuIa-qkaKWKzmPCYbnagTEUDzmITVxOA-MTYZJ1ZdfwuMhv95npObqyaNNbOIS_Te3qxDGPc5QuPgP-HmnbPHB6NbMgRU3ONSwHr-VUrcuk1QxhModHKVSJtkZ2afhM',
        brandName: 'StreamFlow AI',
        brandType: 'SaaS',
        brandTypeColor: bc.tertiaryContainer,
        brandDescription: 'Content Automation Suite',
        title: 'Scale your content creation with lifetime pro access.',
        description:
            'We\'re looking for high-quality video creators to showcase our new AI video editor. You get lifetime access and 3 feature spots.',
        value: '\$2,400',
        deliverable: '3x Reels / TikTok',
        deliverableIcon: Symbols.videocam,
        isFeatured: true,
      ),
      (
        brandLogo:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDjSjEgkQfsBNIvUqLlhVl2sar4YdAOZuuV_NCc56AR90Yzv6s3FD3yxM-V-RDQY4InxwWexj3Qq9pLu6eWlUjv3ktUfFszub1PxLtorAsA40uDqcS65rBd0b5PU3xk5O1HbV8w5xgvBFIAHAPoR9czWDiEx0eJ_VOS_h3UbHgN9MGmLCC1XgLNRWavL56SsG0ed0Sz8ElH0vWHaWcK04wbIlxQNJOE87adKQ_ex_A-h_nkMIAJWhw2rYFGikrHLcHAXY2wMV2vAEw',
        brandName: 'Luna Horology',
        brandType: 'Luxury',
        brandTypeColor: bc.secondary,
        brandDescription: 'Luxury Timepieces',
        title: 'The "Stellar" Collection launch partnership.',
        description:
            'High-end lifestyle photography for our upcoming collection. Product shipping worldwide. Looking for aesthetic-driven creators.',
        value: '\$850',
        deliverable: '5x Hi-Res Photos',
        deliverableIcon: Symbols.photo_camera,
        isFeatured: false,
      ),
    ];

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
                brandLogo: o.brandLogo,
                brandName: o.brandName,
                brandType: o.brandType,
                brandTypeColor: o.brandTypeColor,
                brandDescription: o.brandDescription,
                title: o.title,
                description: o.description,
                value: o.value,
                deliverable: o.deliverable,
                deliverableIcon: o.deliverableIcon,
                isFeatured: o.isFeatured,
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: brandTypeColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              brandType,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: bc.onSecondary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: bc.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Symbols.verified,
                        color: bc.primary,
                        size: 16,
                        fill: 1,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Good match',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
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
              _StatChip(
                icon: Symbols.payments,
                label: '$value Est. Value',
                bc: bc,
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: deliverableIcon,
                label: deliverable,
                bc: bc,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: bc.surfaceVariant,
                      shape: BoxShape.circle,
                      border: Border.all(color: bc.surface, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'IG',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.surface,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: bc.onBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: bc.surface, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'TT',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.surface,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => context.push('/creator/offers/offer_001'),
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

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label, required this.bc});

  final IconData icon;
  final String label;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: bc.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
