import '../../widgets/barter_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/models/offer_model.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_chips.dart';
import '../../widgets/barter_network_image.dart';
import '../../widgets/barter_offer_card.dart';
import '../../widgets/barter_text_field.dart';

class CreatorHomeFeedScreen extends ConsumerStatefulWidget {
  const CreatorHomeFeedScreen({super.key});

  @override
  ConsumerState<CreatorHomeFeedScreen> createState() =>
      _CreatorHomeFeedScreenState();
}

class _CreatorHomeFeedScreenState extends ConsumerState<CreatorHomeFeedScreen> {
  int _sortIndex = 0;
  final _sortLabels = ['Recommended', 'Newest', 'Highest Value', 'Drops'];
  bool _dropsOn = true;
  String? _offerTypeFilter;
  String? _minValueFilter;
  String? _platformFilter;

  List<OfferModel> _applySort(List<OfferModel> offers) {
    final sorted = List<OfferModel>.from(offers);
    switch (_sortIndex) {
      case 1: // Newest — no createdAt in model, keep original order
        break;
      case 2: // Highest Value — sort by numeric value if parseable
        sorted.sort((a, b) {
          final aVal = _parseValue(a.estimatedValueLabel);
          final bVal = _parseValue(b.estimatedValueLabel);
          return bVal.compareTo(aVal);
        });
        break;
      case 3: // Drops — offers with matchTag first
        sorted.sort((a, b) {
          if (a.matchTag != null && b.matchTag == null) return -1;
          if (a.matchTag == null && b.matchTag != null) return 1;
          return 0;
        });
        break;
      default: // Recommended — keep original order
        break;
    }
    return sorted;
  }

  double _parseValue(String label) {
    final cleaned = label.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final offersAsync = ref.watch(offersProvider);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: bc.background.withValues(alpha: 0.92),
          surfaceTintColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              icon: Icon(Symbols.menu, color: bc.onSurface),
              onPressed: () => context.push('/creator/profile'),
            ),
          ),
          title: const BarterLogo(height: 28),
          actions: [
            IconButton(
              icon: Icon(Symbols.notifications, color: bc.onSurface),
              onPressed: () => context.push('/notifications'),
            ),
            const SizedBox(width: 4),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          sliver: SliverToBoxAdapter(
            child: BarterSearchField(
              hint: 'Search brands, products, or drops...',
              prefixIcon: Icon(Symbols.search, color: bc.outline),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
              itemCount: _sortLabels.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: EdgeInsets.only(right: i < _sortLabels.length - 1 ? 12 : 0),
                  child: BarterChip(
                    label: _sortLabels[i],
                    variant: BarterChipVariant.sort,
                    selected: _sortIndex == i,
                    onTap: () => setState(() => _sortIndex = i),
                  ),
                );
              },
            ),
          ),
        ),
        SliverAppBar(
          pinned: true,
          toolbarHeight: 58,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          flexibleSpace: _FilterBar(
            dropsOn: _dropsOn,
            offerTypeFilter: _offerTypeFilter,
            minValueFilter: _minValueFilter,
            platformFilter: _platformFilter,
            onDrops: (v) => setState(() => _dropsOn = v),
            onOfferType: (v) => setState(() => _offerTypeFilter = v),
            onMinValue: (v) => setState(() => _minValueFilter = v),
            onPlatform: (v) => setState(() => _platformFilter = v),
          ),
        ),
        offersAsync.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => SliverFillRemaining(child: Center(child: Text('$e'))),
          data: (OffersPayload payload) {
            final hero =
                payload.offers.isNotEmpty ? payload.offers.first : null;
            final sorted = _applySort(payload.offers);
            return SliverMainAxisGroup(
              slivers: [
                // Hero banner (lazy: only builds when visible)
                if (hero?.heroImageUrl != null)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    sliver: SliverToBoxAdapter(
                      child: RepaintBoundary(child: _HeroBanner(offer: hero!)),
                    ),
                  ),
                // Section header
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          'Live Exchanges',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          '${payload.resultCount} Results',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Lazy-loaded offer cards — only visible items are built
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  sliver: SliverList.separated(
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      final o = sorted[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: BarterOfferCard(
                          brandName: o.brandName,
                          brandLogoUrl: o.brandLogoUrl,
                          title: o.title,
                          estimatedValueLabel: o.estimatedValueLabel,
                          offerTypeLabel: o.offerTypeLabel,
                          verifiedLabel: o.verifiedLabel,
                          requirementTags: o.requirementTags,
                          matchTag: o.matchTag,
                          invertedCta: o.invertedCta,
                          onApply: () => context.push('/creator/offers/${o.id}'),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox.shrink(),
                  ),
                ),
                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.dropsOn,
    required this.onDrops,
    required this.offerTypeFilter,
    required this.minValueFilter,
    required this.platformFilter,
    required this.onOfferType,
    required this.onMinValue,
    required this.onPlatform,
  });

  final bool dropsOn;
  final ValueChanged<bool> onDrops;
  final String? offerTypeFilter;
  final String? minValueFilter;
  final String? platformFilter;
  final ValueChanged<String?> onOfferType;
  final ValueChanged<String?> onMinValue;
  final ValueChanged<String?> onPlatform;

  void _showPicker(
    BuildContext context,
    String title,
    List<String> options,
    String? current,
    ValueChanged<String?> onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (current != null)
                      BarterChip(
                        label: 'Clear',
                        variant: BarterChipVariant.filter,
                        onTap: () {
                          onSelect(null);
                          Navigator.pop(context);
                        },
                      ),
                    ...options.map((o) => BarterChip(
                          label: o,
                          variant: BarterChipVariant.sort,
                          selected: current == o,
                          onTap: () {
                            onSelect(o);
                            Navigator.pop(context);
                          },
                        )),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Material(
      color: bc.background.withValues(alpha: 0.92),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: bc.outlineVariant.withValues(alpha: 0.1),
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    BarterChip(
                      label: offerTypeFilter ?? 'Offer Type',
                      variant: BarterChipVariant.filter,
                      selected: offerTypeFilter != null,
                      onTap: () => _showPicker(
                        context,
                        'Offer Type',
                        ['Physical Product', 'SaaS Offer', 'Digital Service', 'Experience'],
                        offerTypeFilter,
                        onOfferType,
                      ),
                    ),
                    const SizedBox(width: 8),
                    BarterChip(
                      label: minValueFilter ?? 'Min Value',
                      variant: BarterChipVariant.filter,
                      selected: minValueFilter != null,
                      onTap: () => _showPicker(
                        context,
                        'Minimum Value',
                        ['\$500+', '\$1,000+', '\$2,500+', '\$5,000+'],
                        minValueFilter,
                        onMinValue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    BarterChip(
                      label: platformFilter ?? 'Platform',
                      variant: BarterChipVariant.filter,
                      selected: platformFilter != null,
                      onTap: () => _showPicker(
                        context,
                        'Platform',
                        ['Instagram', 'YouTube', 'TikTok', 'Twitter/X', 'LinkedIn'],
                        platformFilter,
                        onPlatform,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 1,
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: bc.outlineVariant.withValues(alpha: 0.2),
            ),
            Text(
              'DROPS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onDrops(!dropsOn),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  color: dropsOn ? bc.primary : bc.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Align(
                  alignment: dropsOn ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
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


class _DropCard extends StatelessWidget {
  const _DropCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.slots,
    required this.bc,
    this.isEndingSoon = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String slots;
  final BarterColors bc;
  final bool isEndingSoon;

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
                  color: isEndingSoon ? bc.primaryFixed : bc.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isEndingSoon ? bc.primary : bc.tertiary,
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
                  slots,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isEndingSoon ? bc.error : bc.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: bc.primary,
                      fontSize: 20,
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

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.offer});

  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            BarterNetworkImage(
              url: offer.heroImageUrl ?? '',
              memCacheWidth: 800,
              memCacheHeight: 450,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: bc.onBackground.withValues(alpha: 0.35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: bc.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'FEATURED DROP',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: bc.onPrimary,
                            fontSize: 10,
                            letterSpacing: 2,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${offer.heroTitle}\n',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                              ),
                        ),
                        TextSpan(
                          text: offer.heroSubtitle ?? '',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: bc.primaryFixedDim,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    offer.heroCaption ?? '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
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
