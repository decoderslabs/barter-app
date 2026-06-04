import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/barter_colors.dart';
import 'barter_buttons.dart';
import 'barter_chips.dart';
import 'barter_network_image.dart';

class BarterOfferCard extends StatelessWidget {
  const BarterOfferCard({
    super.key,
    required this.brandName,
    required this.brandLogoUrl,
    required this.title,
    required this.estimatedValueLabel,
    required this.offerTypeLabel,
    required this.requirementTags,
    this.verifiedLabel = 'Global Brand',
    this.matchTag,
    this.onApply,
    this.invertedCta = false,
  });

  final String brandName;
  final String brandLogoUrl;
  final String title;
  final String estimatedValueLabel;
  final String offerTypeLabel;
  final List<String> requirementTags;
  final String verifiedLabel;
  final String? matchTag;
  final VoidCallback? onApply;
  final bool invertedCta;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return RepaintBoundary(
      child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            color: bc.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: bc.onBackground.withValues(alpha: 0.04),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.1)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: BarterNetworkImage(
                      url: brandLogoUrl,
                      borderRadius: BorderRadius.circular(14),
                      memCacheWidth: 112,
                      memCacheHeight: 112,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          brandName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Symbols.verified,
                              size: 16,
                              color: bc.tertiary,
                              fill: 1,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              verifiedLabel,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: offerTypeLabel.contains('SaaS')
                          ? bc.tertiary.withValues(alpha: 0.1)
                          : bc.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      offerTypeLabel.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 10,
                            letterSpacing: 1.5,
                            color: offerTypeLabel.contains('SaaS')
                                ? bc.tertiary
                                : bc.primary,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Symbols.payments, size: 18, color: bc.primary),
                    const SizedBox(width: 8),
                    Text(
                      estimatedValueLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'EST.',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 10,
                            color: bc.onSurfaceVariant,
                            letterSpacing: 1,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'WHAT THEY WANT',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: requirementTags
                    .map(
                      (t) => BarterChip(
                        label: t,
                        variant: BarterChipVariant.mini,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              BarterPrimaryButton(
                label: 'Apply to Barter',
                onPressed: onApply,
                inverted: invertedCta,
              ),
            ],
          ),
        ),
        if (matchTag != null)
          Positioned(
            top: -12,
            left: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: bc.tertiary,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: bc.onBackground.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Symbols.auto_awesome, size: 14, color: bc.onTertiary),
                  const SizedBox(width: 6),
                  Text(
                    matchTag!.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 10,
                          color: bc.onTertiary,
                          letterSpacing: 1.2,
                        ),
                  ),
                ],
              ),
            ),
          ),
      ],
      ),
    );
  }
}
