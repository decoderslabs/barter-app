import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/dto/offer_dto.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';

class BrandCampaignsScreen extends ConsumerWidget {
  const BrandCampaignsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;

    return Scaffold(
      backgroundColor: bc.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/brand/campaigns/create'),
        backgroundColor: bc.primary,
        foregroundColor: bc.onPrimary,
        icon: const Icon(Symbols.add),
        label: const Text('NEW CAMPAIGN'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(wide ? 48 : 20, wide ? 40 : 24, wide ? 48 : 20, 32),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Campaigns',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(title: const Text('Filter by Status'), onTap: () => Navigator.pop(context)),
                                  ListTile(title: const Text('Filter by Date'), onTap: () => Navigator.pop(context)),
                                  ListTile(title: const Text('Filter by Budget'), onTap: () => Navigator.pop(context)),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: Icon(Symbols.tune, color: bc.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your active and draft campaigns.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: bc.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
          ref.watch(myOffersProvider).when(
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (e, _) => SliverFillRemaining(child: Center(child: Text('$e'))),
            data: (offers) => offers.isEmpty
                ? const SliverFillRemaining(child: Center(child: Text('No campaigns yet')))
                : SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: wide ? 48 : 20),
                    sliver: SliverList.separated(
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        final o = offers[index];
                        return _CampaignCard(
                          offer: o,
                          bc: bc,
                          onTap: () => context.go('/brand/drops'),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.offer, required this.bc, this.onTap});

  final OfferListItemDto offer;
  final BarterColors bc;
  final VoidCallback? onTap;

  Color _statusColor() {
    switch (offer.status) {
      case 'live':    return bc.success;
      case 'draft':   return bc.warning;
      case 'paused':  return bc.error;
      default:        return bc.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();
    return Material(
      color: bc.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      offer.status.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10, color: statusColor),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    offer.brandName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                offer.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Symbols.inventory_2, size: 16, color: bc.onSurfaceVariant.withValues(alpha: 0.6)),
                  const SizedBox(width: 6),
                  Text(
                    '${offer.quantityRemaining} slots remaining',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant),
                  ),
                  const SizedBox(width: 20),
                  Icon(Symbols.payments, size: 16, color: bc.onSurfaceVariant.withValues(alpha: 0.6)),
                  const SizedBox(width: 6),
                  Text(
                    '${offer.currency} ${offer.estimatedValue}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
