import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_card.dart';
import '../../widgets/barter_chips.dart';
import '../../widgets/barter_network_image.dart';

class BrandReviewScreen extends ConsumerWidget {
  const BrandReviewScreen({super.key});

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
            Row(
              children: [
                Text(
                  'Review',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => context.push('/brand/proposal-inbox'),
                  icon: Icon(Symbols.inbox, color: bc.onSurfaceVariant),
                  tooltip: 'Proposal Inbox',
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(title: const Text('Sort by Date'), onTap: () => Navigator.pop(context)),
                            ListTile(title: const Text('Sort by Status'), onTap: () => Navigator.pop(context)),
                            ListTile(title: const Text('Sort by Value'), onTap: () => Navigator.pop(context)),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: Icon(Symbols.sort, color: bc.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Review and manage creator applications.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            _ApplicantCard(
              name: 'Sarah Chen',
              handle: '@sarahcreates',
              followers: '124K',
              engagement: '4.8%',
              niche: 'Fashion',
              avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&crop=face',
              onAccept: () {},
              onDecline: () {},
            ),
            const SizedBox(height: 12),
            _ApplicantCard(
              name: 'Marcus Johnson',
              handle: '@marcusj',
              followers: '89K',
              engagement: '6.2%',
              niche: 'Tech',
              avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
              onAccept: () {},
              onDecline: () {},
            ),
            const SizedBox(height: 12),
            _ApplicantCard(
              name: 'Priya Sharma',
              handle: '@priyalifestyle',
              followers: '203K',
              engagement: '3.9%',
              niche: 'Lifestyle',
              avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face',
              onAccept: () {},
              onDecline: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicantCard extends StatelessWidget {
  const _ApplicantCard({
    required this.name,
    required this.handle,
    required this.followers,
    required this.engagement,
    required this.niche,
    required this.avatarUrl,
    this.onAccept,
    this.onDecline,
  });

  final String name;
  final String handle;
  final String followers;
  final String engagement;
  final String niche;
  final String avatarUrl;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return BarterCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: BarterNetworkImage(url: avatarUrl),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      handle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: bc.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              BarterChip(
                label: niche.toUpperCase(),
                variant: BarterChipVariant.mini,
                bgColor: bc.primaryContainer.withValues(alpha: 0.1),
                fgColor: bc.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Metric(label: 'Followers', value: followers),
              const SizedBox(width: 24),
              _Metric(label: 'Engagement', value: engagement),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: bc.onSurfaceVariant,
                    side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('DECLINE'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onAccept,
                  style: FilledButton.styleFrom(
                    backgroundColor: bc.primary,
                    foregroundColor: bc.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('ACCEPT'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 10,
                color: bc.onSurfaceVariant.withValues(alpha: 0.55),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
