import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/routing/deal_route.dart';
import '../../data/models/deal_room_model.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_network_image.dart';

class ReviewContentScreen extends ConsumerWidget {
  const ReviewContentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final dealId = dealIdFromRoute(context);
    final dealAsync = ref.watch(dealRoomProvider(dealId));
    return dealAsync.when(
      loading: () => Scaffold(backgroundColor: bc.background, body: const Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(backgroundColor: bc.background, body: Center(child: Text('$e'))),
      data: (deal) => _ReviewContentBody(bc: bc, deal: deal),
    );
  }
}

class _ReviewContentBody extends StatelessWidget {
  const _ReviewContentBody({required this.bc, required this.deal});
  final BarterColors bc;
  final DealRoomModel deal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bc.background,
      appBar: AppBar(
        backgroundColor: bc.background,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: bc.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Deal Room',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Symbols.more_vert, color: bc.primary),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Symbols.flag, color: bc.error),
                        title: const Text('Report Content'),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        leading: Icon(Symbols.share, color: bc.primary),
                        title: const Text('Share Deal'),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bc.tertiaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Review Phase',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onTertiaryContainer,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      fontSize: 10,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.05,
                    ),
                children: [
                  const TextSpan(text: 'Review '),
                  TextSpan(text: 'Content', style: TextStyle(color: bc.primary)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please review the deliverables submitted by ${deal.creatorName.isNotEmpty ? deal.creatorName : "the creator"} for "${deal.offerTitle}".',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: bc.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: bc.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: bc.primaryFixed, width: 2),
                    ),
                    child: ClipOval(
                      child: BarterNetworkImage(
                        url: deal.creatorAvatarUrl,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CREATOR',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          deal.creatorName.isNotEmpty ? deal.creatorName : 'Creator',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Symbols.star, color: bc.primary, size: 16, fill: 1),
                            const SizedBox(width: 4),
                            Text(
                              '4.9',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
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
            const SizedBox(height: 32),
            _MainContentPreview(bc: bc),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _StillCard(bc: bc, label: 'Still_01.jpg')),
                const SizedBox(width: 16),
                Expanded(child: _StillCard(bc: bc, label: 'Still_02.jpg')),
              ],
            ),
            const SizedBox(height: 32),
            _DeliverablesList(bc: bc),
            const SizedBox(height: 24),
            _DealFeeCard(bc: bc, deal: deal),
          ],
        ),
      ),
    );
  }
}

class _MainContentPreview extends StatelessWidget {
  const _MainContentPreview({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BarterNetworkImage(
                    url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCLrhlk4BgCafAab-i9I9JyDXWVsB7pcqgO_nUruE2lTF5sMuwdPQTphUs_BXqFOvR9F91fc1H2N7BXtMhyug8ral2dbx0DW4dDtExeUI_upNeOs33TD9F5nU46c7Mj6buPnACP90QsDRcZ5fTI53SbGV6--C3NaAqIuWfaadezhSc75MG5PB2-Iz5YofpYJUV6awCRGDlFO8LFcqAkh5FBb32LxkQGgXtm28LYOpoeOwmS_FMxUNV_tK6OYi6rZkluh1899R5WMLg',
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: bc.onBackground.withValues(alpha: 0.2),
                    child: Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: bc.onPrimary.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Symbols.play_arrow, color: bc.onPrimary, size: 32, fill: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '01_Summer_Editorial_V1.mp4',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Main campaign video showcasing the linen collection in Mediterranean setting.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: bc.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: bc.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'REELS / 4K',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Symbols.link, color: bc.tertiary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Instagram Live Post',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: bc.tertiary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StillCard extends StatelessWidget {
  const _StillCard({required this.bc, required this.label});

  final BarterColors bc;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: AspectRatio(
              aspectRatio: 1,
              child: BarterNetworkImage(
                url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCLrhlk4BgCafAab-i9I9JyDXWVsB7pcqgO_nUruE2lTF5sMuwdPQTphUs_BXqFOvR9F91fc1H2N7BXtMhyug8ral2dbx0DW4dDtExeUI_upNeOs33TD9F5nU46c7Mj6buPnACP90QsDRcZ5fTI53SbGV6--C3NaAqIuWfaadezhSc75MG5PB2-Iz5YofpYJUV6awCRGDlFO8LFcqAkh5FBb32LxkQGgXtm28LYOpoeOwmS_FMxUNV_tK6OYi6rZkluh1899R5WMLg',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliverablesList extends StatelessWidget {
  const _DeliverablesList({required this.bc});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deliverables',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          _DeliverableItem(label: '1x Instagram Reel', status: 'Delivered', bc: bc, done: true),
          const SizedBox(height: 12),
          _DeliverableItem(label: '3x High-Res Stills', status: 'Delivered', bc: bc, done: true),
          const SizedBox(height: 12),
          _DeliverableItem(label: '1x Story Post', status: 'Pending', bc: bc, done: false),
        ],
      ),
    );
  }
}

class _DeliverableItem extends StatelessWidget {
  const _DeliverableItem({
    required this.label,
    required this.status,
    required this.bc,
    required this.done,
  });

  final String label;
  final String status;
  final BarterColors bc;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                done ? Symbols.check_circle : Symbols.schedule,
                color: done ? Colors.green : bc.onSurfaceVariant,
                fill: done ? 1.0 : 0.0,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          Text(
            status.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: done ? Colors.green : bc.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _DealFeeCard extends StatelessWidget {
  const _DealFeeCard({required this.bc, required this.deal});

  final BarterColors bc;
  final DealRoomModel deal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.onBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agreed Deal Fee',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.onPrimary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '${deal.currency} ${deal.dealFee}',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: bc.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/deal/${deal.dealId}/shipping'),
              style: ElevatedButton.styleFrom(
                backgroundColor: bc.primary,
                foregroundColor: bc.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                elevation: 0,
              ),
              child: const Text('Approve & Pay'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/deal/${deal.dealId}/revision'),
              style: OutlinedButton.styleFrom(
                foregroundColor: bc.onPrimary,
                side: BorderSide(color: bc.onPrimary.withValues(alpha: 0.2)),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
              child: const Text('Request Revision'),
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: bc.onPrimary.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dispute feature coming soon')),
              );
            },
            icon: Icon(Symbols.gavel, color: bc.error),
            label: Text(
              'Raise Dispute',
              style: TextStyle(color: bc.error, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
