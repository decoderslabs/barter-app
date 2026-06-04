import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../widgets/barter_network_image.dart';

class ShippingStatusScreen extends StatelessWidget {
  const ShippingStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'BARTER',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: bc.primary,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    letterSpacing: -1,
                  ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    'Active Exchange',
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
                  'ID: #BT-8821',
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
              'The brand has received your details and is preparing your exchange items.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: bc.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
            ),
            const SizedBox(height: 32),
            _StatusCard(bc: bc),
            const SizedBox(height: 32),
            _ActionButtons(bc: bc),
            const SizedBox(height: 32),
            _BrandContextCard(bc: bc),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.bc});

  final BarterColors bc;

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
                    'Marked as Shipped',
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
                      '7734 •••• •••• 9921',
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
                      'Alex Rivers\n48•• •••••• •••• Ave, Suite ••\nLos Angeles, CA 90210',
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
  const _ActionButtons({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push('/deal/rate-close'),
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
  const _BrandContextCard({required this.bc});

  final BarterColors bc;

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
                    url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAF12_KK8hHL23K5cX9yPKuyOjuMXKP2zC4e7_pi4f7xcHuaBdD87crrkJUAc7QRWafL4N9LZ3s8ptvitUMuYEG7Tree2KTS0IBTCvzGPx5tLne0bFHwGe4Wm_iawah-0C_DYGgO2_ARjbEEtsJoqxQuosFmbMmxWiM7v5VPeiAub1jQKiQxfnBJxD9FPbfjD8ge-HNxkogsDyyfz80EhW_5OjHagAqZ-FWqWDd1_fGCjeGvFu98JTyRsuMn59qTWaCHWp9OqEuDm8',
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
            'VOGUE ELYSIAN',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Official Brand Partner',
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
