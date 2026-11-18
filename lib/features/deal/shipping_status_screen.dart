import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/routing/deal_route.dart';
import '../../data/models/deal_room_model.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_logo.dart';
import '../../widgets/barter_network_image.dart';

class ShippingStatusScreen extends ConsumerWidget {
  const ShippingStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final dealId = dealIdFromRoute(context);
    final dealAsync = ref.watch(dealRoomProvider(dealId));
    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: bc.onBackground),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'DEAL ROOM',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: BarterLogo(height: 24),
          ),
        ],
      ),
      body: dealAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (deal) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: bc.tertiaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      deal.status.toUpperCase().replaceAll('_', ' '),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onTertiaryContainer,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            fontSize: 10,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ID: #${deal.dealId}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.outline,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.05,
                      ),
                  children: [
                    const TextSpan(text: 'Track your '),
                    TextSpan(text: 'Delivery.', style: TextStyle(color: bc.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tracking the shipment for "${deal.offerTitle}".',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: bc.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
              ),
              const SizedBox(height: 32),
              _StatusCard(bc: bc, deal: deal),
              const SizedBox(height: 32),
              _ActionButtons(bc: bc, dealId: deal.dealId),
              const SizedBox(height: 32),
              _BrandContextCard(bc: bc, deal: deal),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.bc, required this.deal});

  final BarterColors bc;
  final DealRoomModel deal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Status',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 10,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deal.shippedAt != null ? 'Marked as Shipped' : 'Awaiting Shipment',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bc.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Symbols.local_shipping, color: bc.primary, size: 28, fill: 1),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bc.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FedEx Tracking',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 10,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deal.shippedAt ?? 'Not yet shipped',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Symbols.content_copy, color: bc.primary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tracking number copied')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: bc.outlineVariant.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Symbols.location_on, color: bc.outline, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 10,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deal.creatorName.isNotEmpty ? deal.creatorName : 'Creator',
                      // real shipping address via /deals/{id}/shipping-address
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: bc.onSurface,
                            height: 1.4,
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
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.bc, required this.dealId});

  final BarterColors bc;
  final String dealId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push('/deal/$dealId/rate-close'),
            style: ElevatedButton.styleFrom(
              backgroundColor: bc.primary,
              foregroundColor: bc.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              elevation: 0,
              shadowColor: bc.primary.withValues(alpha: 0.25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Symbols.check_circle, color: bc.onPrimary),
                const SizedBox(width: 12),
                const Text('Confirm Receipt'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: bc.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.lock, color: bc.onSurfaceVariant),
              const SizedBox(width: 12),
              Text(
                'Submit Deliverables',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: bc.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Unlock after confirming receipt of items',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.outline,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}

class _BrandContextCard extends StatelessWidget {
  const _BrandContextCard({required this.bc, required this.deal});

  final BarterColors bc;
  final DealRoomModel deal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: bc.onBackground.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BarterNetworkImage(
                    url: deal.brandLogoUrl,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bc.tertiaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: bc.surfaceContainerLow, width: 2),
                ),
                child: Icon(Symbols.verified, color: bc.onTertiaryContainer, size: 12, fill: 1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            deal.brandName.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            deal.offerTitle.isNotEmpty ? deal.offerTitle : 'Official Brand Partner',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Messaging coming soon')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: bc.onSurface,
                    side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Symbols.chat, size: 20),
                      const SizedBox(width: 8),
                      const Text('Message'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Support coming soon')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: bc.onSurface,
                    side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Symbols.help, size: 20),
                      const SizedBox(width: 8),
                      const Text('Support'),
                    ],
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
