import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_card.dart';
import '../../widgets/barter_network_image.dart';

class BrandReviewContentScreen extends ConsumerWidget {
  const BrandReviewContentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;

    return Scaffold(
      backgroundColor: bc.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 48 : 20, wide ? 40 : 24, wide ? 48 : 20, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review Content',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Review and approve content submitted by creators.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            _ContentCard(
              creatorName: 'Sarah Chen',
              creatorHandle: '@sarahcreates',
              campaign: 'Summer Drops 2024',
              contentType: 'IG Reel',
              caption: 'Check out my new skincare routine with @premiumbrand! These products have transformed my skin in just 2 weeks. Swipe up to shop!',
              imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&h=500&fit=crop',
              avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&crop=face',
              bc: bc,
            ),
            const SizedBox(height: 16),
            _ContentCard(
              creatorName: 'Marcus Johnson',
              creatorHandle: '@marcusj',
              campaign: 'Back to School Collab',
              contentType: 'YouTube Video',
              caption: 'Unboxing the latest tech gadgets from @techbrand. These are game changers for students heading back to school!',
              imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=300&fit=crop',
              avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
              bc: bc,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.creatorName,
    required this.creatorHandle,
    required this.campaign,
    required this.contentType,
    required this.caption,
    required this.imageUrl,
    required this.avatarUrl,
    required this.bc,
  });

  final String creatorName;
  final String creatorHandle;
  final String campaign;
  final String contentType;
  final String caption;
  final String imageUrl;
  final String avatarUrl;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: BarterNetworkImage(url: avatarUrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creatorName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contentType,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: bc.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'PENDING',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: bc.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            caption,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bc.onSurface,
                ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              height: 180,
              child: BarterNetworkImage(url: imageUrl),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/deal/sample/revision'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: bc.onSurfaceVariant,
                    side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Symbols.edit, size: 18),
                  label: const Text('REQUEST REVISION'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push('/deal/sample/rate-close'),
                  style: FilledButton.styleFrom(
                    backgroundColor: bc.primary,
                    foregroundColor: bc.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Symbols.check, size: 18),
                  label: const Text('APPROVE'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
