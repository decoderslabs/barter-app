import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';

class RatingConfirmationScreen extends StatelessWidget {
  const RatingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;

    return Scaffold(
      backgroundColor: bc.surface,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: IconButton(
          icon: Icon(Symbols.close, color: bc.primary),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'RATE EXCHANGE',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: bc.primary,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
        ),
        actions: const [SizedBox(width: 24)],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeroSection(bc: bc),
              const SizedBox(height: 48),
              _TypographySection(bc: bc),
              const SizedBox(height: 48),
              _NumericalStat(bc: bc),
              const SizedBox(height: 64),
              _ActionsSection(bc: bc),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 256,
            height: 256,
            decoration: BoxDecoration(
              color: bc.primaryFixed.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: bc.surfaceContainerLowest,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: bc.primary.withValues(alpha: 0.12),
                  blurRadius: 60,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Icon(
              Symbols.verified,
              color: bc.primary,
              size: 64,
              fill: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypographySection extends StatelessWidget {
  const _TypographySection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thank',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    letterSpacing: -2,
                  ),
            ),
            const SizedBox(height: 4),
            Transform.translate(
              offset: const Offset(0, -8),
              child: Text(
                'You.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: bc.onBackground,
                      fontWeight: FontWeight.bold,
                      height: 1,
                      letterSpacing: -2,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: bc.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: bc.primary, width: 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your contribution helps keep the BARTER ecosystem transparent and high-quality.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: bc.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Symbols.update,
                      color: bc.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Score Calculation',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: bc.onBackground,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: 12,
                              ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: bc.onSurfaceVariant,
                                ),
                            children: [
                              const TextSpan(text: 'The creator\'s Barter Score will be recalculated and updated across the platform within '),
                              TextSpan(
                                text: '24 hours',
                                style: TextStyle(
                                  color: bc.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NumericalStat extends StatelessWidget {
  const _NumericalStat({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Exchange Verified',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 10,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '100%',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    letterSpacing: -2,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionsSection extends StatelessWidget {
  const _ActionsSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => context.go('/brand/dashboard'),
          icon: Icon(Symbols.arrow_forward, color: bc.onPrimary),
          label: Text(
            'Back to Dashboard',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: bc.primary,
            foregroundColor: bc.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
            elevation: 10,
            shadowColor: bc.primary.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.go('/creator/profile'),
          child: Text(
            'View My Profile',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.tertiary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ),
      ],
    );
  }
}
