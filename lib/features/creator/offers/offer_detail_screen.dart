import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/models/offer_model.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_network_image.dart';
import '../membership/membership_gate.dart';

class OfferDetailScreen extends ConsumerWidget {
  const OfferDetailScreen({super.key, required this.offerId});

  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final offerAsync = ref.watch(offerDetailProvider(offerId));
    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        leading: const BarterBackButton(),
        actions: [
          IconButton(
            icon: Icon(Symbols.bookmark, color: bc.onBackground),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved to bookmarks')),
              );
            },
          ),
          IconButton(
            icon: Icon(Symbols.share, color: bc.onBackground),
            onPressed: () {
              Share.share(
                'Check out this barter offer on Barter App!\nhttps://barter-app-wp.netlify.app/creator/offers/$offerId',
              );
            },
          ),
        ],
      ),
      body: offerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (OfferModel offer) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BrandIdentitySection(offer: offer, bc: bc),
                const SizedBox(height: 48),
                _MatchScoreWidget(offerId: offerId, bc: bc),
                const SizedBox(height: 48),
                if (offer.heroImageUrl != null) ...[
                  _GallerySection(heroImageUrl: offer.heroImageUrl!, bc: bc),
                  const SizedBox(height: 48),
                ],
                _DescriptionSection(description: offer.heroSubtitle ?? offer.title, bc: bc),
                const SizedBox(height: 48),
                _TechnicalListsSection(offer: offer, bc: bc),
                const SizedBox(height: 48),
                _RightsAndFeesSection(offer: offer, bc: bc),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        decoration: BoxDecoration(
          color: bc.surface.withValues(alpha: 0.8),
        ),
        child: ElevatedButton(
          onPressed: () async {
            final membership = await ref.read(membershipProvider.future);
            if (membership.status.proActive || membership.status.pendingVerification) {
              if (context.mounted) {
                context.push('/creator/offers/$offerId/proposal');
              }
              return;
            }
            if (context.mounted) {
              await showMembershipGate(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: bc.primary,
            foregroundColor: bc.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            elevation: 0,
            shadowColor: bc.primary.withValues(alpha: 0.2),
          ),
          child: Text(
            'Apply Now',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}

class _BrandIdentitySection extends StatelessWidget {
  const _BrandIdentitySection({required this.offer, required this.bc});

  final OfferModel offer;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 80,
            height: 80,
            child: BarterNetworkImage(url: offer.brandLogoUrl),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        offer.brandName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                      ),
                    ),
                    Icon(Symbols.verified, color: bc.tertiary, size: 18, fill: 1),
                  ],
                ),
                if (offer.heroSubtitle != null && offer.heroSubtitle!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    offer.heroSubtitle!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: bc.onSurfaceVariant,
                          height: 1.45,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MatchScoreWidget extends ConsumerWidget {
  const _MatchScoreWidget({required this.offerId, required this.bc});

  final String offerId;
  final BarterColors bc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineAsync = ref.watch(valueEngineProvider(offerId));
    return engineAsync.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
      data: (engine) {
        final scoreRaw = engine['match_score'] ?? engine['score'];
        final scoreLabel = scoreRaw?.toString() ?? '--';
        final message = engine['message'] as String? ?? '';
        final tier = engine['recommended_tier'] as String?;
        final Color scoreColor = scoreRaw == 'strong'
            ? bc.primary
            : scoreRaw == 'good'
                ? bc.tertiary
                : bc.outline;
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOUR MATCH SCORE',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: bc.onSurfaceVariant,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                scoreLabel,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -2,
                    ),
              ),
              if (tier != null) ...[
                const SizedBox(height: 4),
                Text(
                  tier,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: bc.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
              if (message.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bc.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '"$message"',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: bc.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.heroImageUrl, required this.bc});

  final String heroImageUrl;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            children: [
              const TextSpan(text: 'The Product '),
              TextSpan(text: 'Lineup', style: TextStyle(color: bc.primary)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 280,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BarterNetworkImage(url: heroImageUrl, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description, required this.bc});

  final String description;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    if (description.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Exchange',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
                height: 1.7,
              ),
        ),
      ],
    );
  }
}

class _TechnicalListsSection extends StatelessWidget {
  const _TechnicalListsSection({required this.offer, required this.bc});

  final OfferModel offer;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 560) {
          return Column(
            children: [
              _WantsCard(offer: offer, bc: bc),
              const SizedBox(height: 24),
              _KpiPreferencesCard(bc: bc),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _WantsCard(offer: offer, bc: bc)),
            const SizedBox(width: 24),
            Expanded(child: _KpiPreferencesCard(bc: bc)),
          ],
        );
      },
    );
  }
}

class _WantsCard extends StatelessWidget {
  const _WantsCard({required this.offer, required this.bc});

  final OfferModel offer;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHAT THEY WANT',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: bc.primary,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          ...offer.requirementTags.map(
            (tag) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Symbols.check, color: bc.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(tag)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiPreferencesCard extends StatelessWidget {
  const _KpiPreferencesCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KPI PREFERENCES',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: bc.primary,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          _PreferenceRow(label: 'Followers', value: '5K+', bc: bc),
          const SizedBox(height: 16),
          _PreferenceRow(label: 'Engagement Rate', value: '2.5% Min', bc: bc),
          const SizedBox(height: 16),
          _PreferenceRow(label: 'Primary Audience', value: 'EU / US', bc: bc),
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.label,
    required this.value,
    required this.bc,
  });

  final String label;
  final String value;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: bc.onSurfaceVariant,
                ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bc.tertiaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: bc.onTertiaryContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}

class _RightsAndFeesSection extends StatelessWidget {
  const _RightsAndFeesSection({required this.offer, required this.bc});

  final OfferModel offer;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONTENT RIGHTS',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: bc.secondary,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Symbols.gavel, color: bc.secondary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Standard License',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Usage for social media & website for 12 months',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: bc.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'DEAL FEE',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: bc.secondary,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Symbols.payments, color: bc.primary, fill: 1),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  offer.estimatedValueLabel,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.w900,
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
