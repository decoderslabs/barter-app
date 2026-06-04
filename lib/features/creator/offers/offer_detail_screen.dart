import 'package:flutter/material.dart';
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
    final offersAsync = ref.watch(offersProvider);
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: offersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (OffersPayload payload) {
          OfferModel? o;
          for (final x in payload.offers) {
            if (x.id == offerId) o = x;
          }
          o ??= payload.offers.isNotEmpty ? payload.offers.first : null;
          if (o == null) {
            return const Center(child: Text('Offer not found'));
          }
          final offer = o;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BrandIdentitySection(offer: offer, bc: bc),
                const SizedBox(height: 48),
                _MatchScoreWidget(bc: bc),
                const SizedBox(height: 48),
                _GallerySection(bc: bc),
                const SizedBox(height: 48),
                _DescriptionSection(bc: bc),
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
                const SizedBox(height: 8),
                Text(
                  'High-end sustainable skincare focused on botanical innovation and Parisian luxury aesthetics. Seeking creators for our Golden Hour campaign.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: bc.onSurfaceVariant,
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MatchScoreWidget extends StatelessWidget {
  const _MatchScoreWidget({required this.bc});

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
            'YOUR MATCH SCORE',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: bc.onSurfaceVariant,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '92%',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: bc.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Strong Strategic Alignment',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: bc.secondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bc.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"Your audience’s high engagement with premium wellness content matches our core demographic perfectly."',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: bc.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final images = [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuARrwcwkXOlRng4RrGXMFrnZymuCEvmimuPvfMCJbi79Av6DzTO9ArAzqtJDPhFKplkaTf9SqA2VzRTWrH8lQQ-haqY6hrkxETFv2UAUAeHoc5BtZYvYghMR9lI7OUw4x4m6T1qLxsF6TU0DXhdxhAGeIyOxNoVJ6Iw8We9v9Fd2dNppv-L4ba5NmWwTNVU06Ziz2SrtCfaqhThaKLqy02E1SqmoDX67ToN0htyh5rqNyQOhyedJxduIJBpN1Sqz99W3vjEPyad06I',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAvJy-cSV8idnIdCZLvpQlQdvSK7hhAQ8JEk9AbGh0DsZ2wV-Y6_49hJWdywX36FlXS1ayZDCUs5qIeEp0B49EgUuhSFQsZOJ0RlIBhSJ9J2BEdm8I-UlLC-FUfNvHN_d_NdQO_Ti9wvPrTAa8TmReTHkrxDf4ZYapaBuDzBPpGef9ZlFwjyXXH60C-PUONZkwycVVmBK9CkYGiGxYX0y16h7tWBxV857TCv_njCMVxSURrmitRI9DeYgDPYkcmwzW3J7bFUYjKv3k',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCJLC5Cs7N5Ax4d9ula20F8WZvRAXbIgmMZEP1VlzJLPGV3o1cZ7keY8ewHmVKvwzQzsXPgINhJmqKr6__-meW-BeQu1b3MydRlyEH_n5PML7yqG-XFpt712R-CGg4WsGnb4yCtmuqj22YC14HWtuDouzUPEq6mwH4Lm5eXgWrJuVttMRJD4KLmpygK_A0XaLe5d0NVFByvv0PdlOBjWlUn5PH2xZnoLvv4It4mJKFrt1coMN0CdX7UcqaXyKg0_23-wik5Pwq7m4k',
    ];
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
          child: Row(
            children: [
              Expanded(flex: 2, child: _GalleryImage(url: images[0], bc: bc)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: _GalleryImage(url: images[1], bc: bc)),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _GalleryImage(url: images[2], bc: bc),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                '+3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.url, required this.bc});

  final String url;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: bc.surfaceContainerHighest,
        child: BarterNetworkImage(url: url),
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
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
          'We are launching our signature Vérité Serum and looking for creators who embody effortless elegance. The goal is to create organic, editorial-style content focused on morning routines and glow from within.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
                height: 1.7,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Successful applicants receive the full Botanical Glow set and ongoing partnership opportunities for the Q4 holiday season.',
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
