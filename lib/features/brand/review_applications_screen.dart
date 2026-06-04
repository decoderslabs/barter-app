import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_card.dart';
import '../../widgets/barter_chips.dart';
import '../../widgets/barter_network_image.dart';

class ReviewApplicationsScreen extends ConsumerWidget {
  const ReviewApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;

    return Scaffold(
      backgroundColor: bc.background,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(wide ? 48 : 20, wide ? 40 : 24, wide ? 48 : 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Review ',
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                  TextSpan(
                                    text: '/ ',
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          color: bc.primary.withValues(alpha: 0.3),
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                  TextSpan(
                                    text: 'Applications',
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          color: bc.onSurfaceVariant,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Curating the aesthetic for Summer Drop \'24. 124 pending requests.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: bc.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (wide) ...[
                        const SizedBox(width: 24),
                        BarterChip(label: 'High Engagement', variant: BarterChipVariant.filter, icon: Symbols.filter_list),
                        const SizedBox(width: 8),
                        BarterChip(label: 'Barter Score', variant: BarterChipVariant.filter, icon: Symbols.filter_list),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (!wide) ...[
                    Row(
                      children: [
                        BarterChip(label: 'High Engagement', variant: BarterChipVariant.filter, icon: Symbols.filter_list),
                        const SizedBox(width: 8),
                        BarterChip(label: 'Barter Score', variant: BarterChipVariant.filter, icon: Symbols.filter_list),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  _ApplicationListHeader(bc: bc),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Lazy-loaded application cards
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: wide ? 48 : 20),
            sliver: SliverList.separated(
              itemCount: 4,
              itemBuilder: (context, index) {
                final apps = [
                  (
                    name: 'Sarah Chen',
                    handle: '@sarahcreates',
                    followers: '124K',
                    engagement: '4.8%',
                    score: '92',
                    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&crop=face',
                  ),
                  (
                    name: 'Marcus Johnson',
                    handle: '@marcusj',
                    followers: '89K',
                    engagement: '6.2%',
                    score: '88',
                    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
                  ),
                  (
                    name: 'Priya Sharma',
                    handle: '@priyalifestyle',
                    followers: '203K',
                    engagement: '3.9%',
                    score: '85',
                    avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face',
                  ),
                  (
                    name: 'Alex Rivera',
                    handle: '@arivera',
                    followers: '156K',
                    engagement: '5.1%',
                    score: '91',
                    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face',
                  ),
                ];
                final a = apps[index];
                return _ApplicationCard(
                  name: a.name,
                  handle: a.handle,
                  followers: a.followers,
                  engagement: a.engagement,
                  score: a.score,
                  avatarUrl: a.avatarUrl,
                  bc: bc,
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _ApplicationListHeader extends StatelessWidget {
  const _ApplicationListHeader({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    return BarterCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (_) {},
            activeColor: bc.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Select All Applications',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (wide) ...[
            const Spacer(),
            _HeaderLabel('Followers'),
            const SizedBox(width: 40),
            _HeaderLabel('Eng. Rate'),
            const SizedBox(width: 40),
            _HeaderLabel('Score'),
            const SizedBox(width: 40),
            _HeaderLabel('Action'),
          ],
        ],
      ),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  const _HeaderLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 11,
            color: bc.onSurfaceVariant.withValues(alpha: 0.7),
          ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({
    required this.name,
    required this.handle,
    required this.followers,
    required this.engagement,
    required this.score,
    required this.avatarUrl,
    required this.bc,
  });

  final String name;
  final String handle;
  final String followers;
  final String engagement;
  final String score;
  final String avatarUrl;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    return BarterCard(
      padding: const EdgeInsets.all(20),
      borderColor: bc.outlineVariant.withValues(alpha: 0.1),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (_) {},
            activeColor: bc.primary,
          ),
          const SizedBox(width: 16),
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
          if (wide) ...[
            _MetricValue(followers),
            const SizedBox(width: 40),
            _MetricValue(engagement),
            const SizedBox(width: 40),
            _ScoreValue(score, bc: bc),
            const SizedBox(width: 40),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => context.push('/brand/review/proposal'),
                  icon: Icon(Symbols.check, color: bc.success),
                  style: IconButton.styleFrom(
                    backgroundColor: bc.success.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Application declined')),
                    );
                  },
                  icon: Icon(Symbols.close, color: bc.error),
                  style: IconButton.styleFrom(
                    backgroundColor: bc.error.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ] else ...[
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(leading: const Icon(Icons.person), title: const Text('View Profile'), onTap: () => Navigator.pop(context)),
                        ListTile(leading: const Icon(Icons.message), title: const Text('Message'), onTap: () => Navigator.pop(context)),
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(Symbols.more_vert, color: bc.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricValue extends StatelessWidget {
  const _MetricValue(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _ScoreValue extends StatelessWidget {
  const _ScoreValue(this.value, {required this.bc});

  final String value;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: bc.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: bc.primary,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
