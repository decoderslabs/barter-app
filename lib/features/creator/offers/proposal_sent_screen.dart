import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';

class ProposalSentScreen extends StatelessWidget {
  const ProposalSentScreen({super.key, required this.offerId});

  final String offerId;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        leading: BarterCloseButton(
          onPressed: () => context.go('/creator/feed'),
          color: bc.primary,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => context.push('/help'),
            child: Text(
              'Help',
              style: TextStyle(
                color: bc.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 56, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 192,
                    height: 192,
                    decoration: BoxDecoration(
                      color: bc.primaryFixedDim.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: bc.secondaryContainer.withValues(alpha: 0.3),
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
                          color: bc.primary.withValues(alpha: 0.08),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Icon(Symbols.rocket_launch, color: bc.primary, size: 64, fill: 1),
                  ),
                  Positioned(
                    top: 24,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: bc.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: bc.onBackground.withValues(alpha: 0.12),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Icon(Symbols.handshake, color: bc.onTertiaryContainer, size: 24, fill: 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: bc.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'STATUS: PENDING',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: bc.onSurface,
                        fontWeight: FontWeight.bold,
                        height: 1.05,
                      ),
                  children: [
                    const TextSpan(text: 'Proposal '),
                    TextSpan(text: 'Sent', style: TextStyle(color: bc.primary)),
                    const TextSpan(text: ' to Glow Lab!'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Your creative vision is now in their hands. They'll review it shortly.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                      height: 1.45,
                    ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/creator/inbox'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bc.primary,
                    foregroundColor: bc.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    elevation: 0,
                    shadowColor: bc.primary.withValues(alpha: 0.15),
                  ),
                  child: Text(
                    'View My Proposals',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: bc.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/creator/feed'),
                child: Text(
                  'Back to Feed',
                  style: TextStyle(
                    color: bc.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEXT STEPS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 10,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: bc.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Symbols.notifications, color: bc.primary, size: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Get Notified',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: bc.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "We'll alert you the moment Glow Lab responds to your proposal.",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: bc.onSurfaceVariant.withValues(alpha: 0.7),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
