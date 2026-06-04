import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../widgets/barter_appbar.dart';
import '../../widgets/barter_chips.dart';
import '../../widgets/barter_text.dart';
import '../../widgets/barter_network_image.dart';

class NotificationsCenterScreen extends StatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  State<NotificationsCenterScreen> createState() => _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends State<NotificationsCenterScreen> {
  final List<String> _filters = ['All', 'Unread', 'Exchanges', 'Ratings'];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.surface,
      appBar: BarterAppBar(
        showBrandTitle: false,
        title: 'Notifications',
        leading: IconButton(
          icon: Icon(Symbols.menu, color: bc.onBackground),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: bc.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '4',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Symbols.notifications, color: bc.primary),
            onPressed: () => context.push('/notifications/settings'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                children: [
                  _FilterChips(bc: bc),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Lazy-loaded notification items
          _NotificationItems(bc: bc),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BarterSectionLabel(label: 'Earlier Today'),
                  const SizedBox(height: 24),
                  _FeaturedCard(bc: bc),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          BarterChip(label: 'All', variant: BarterChipVariant.filter, selected: true),
          const SizedBox(width: 8),
          BarterChip(label: 'Unread', variant: BarterChipVariant.filter),
          const SizedBox(width: 8),
          BarterChip(label: 'Exchanges', variant: BarterChipVariant.filter),
          const SizedBox(width: 8),
          BarterChip(label: 'Ratings', variant: BarterChipVariant.filter),
        ],
      ),
    );
  }
}

typedef _NotificationData = ({
  String imageUrl,
  IconData icon,
  String title,
  String time,
  String actorName,
  String bodyText,
  String? boldItem,
  bool isUnread,
  double? rating,
  bool isDeadline,
});

class _NotificationItems extends StatelessWidget {
  const _NotificationItems({required this.bc});

  final BarterColors bc;

  static const _data = <_NotificationData>[
    (
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuABMK6SNVORPI-pr2G8OxNNABUobLc5aPFpZW5gIw9fo7ciLcpeaAEF8odpCTWRghT2SEllieENLB941kJVyG5a2MPLtZwcPxpy_e_EfRj_SBARaiVaHkUYMfuh5sEP9t72GKAXXBg0n6H7XEzukuNSdbCMpBHuNjfwywz6c8uCX8LtpGoIupF3h39m-5iSSN4qGif5eFdyU2tTqzRBjHwnWPfyyEva_RoCJuwTqpxZbmfEflmorvmUR5JAigaX7vQYs6z7IoGcGqM',
      icon: Symbols.mail,
      title: 'New Proposal Received',
      time: '2m ago',
      actorName: 'Priya',
      bodyText: ' wants to exchange for ',
      boldItem: 'Glow Lab Serum',
      isUnread: true,
      rating: null,
      isDeadline: false,
    ),
    (
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDmT5qngLO9efHvFe6rAW1vRFHwfEulcqSq0Wf4zkvmKxNOeaGvI2d8MQK_gNB7K3tcJqypBkhf3OyhlchcAGpkCF0Z7BnMMKz6jfnZrwEIwyTfYj6D1mDQGlD0Hv3SO5nYpHdLYGPCyBVOJOuOWxj3qJ7-1zjJoL5F5yJuSRoqJhjTkEA-R6RYzjmywZCb9Tt3Ldl83v5mP5lv-C8-oD1qkIZC4Ddf2XAujjpiTHn0PLBK-6NSFzmpGku2iJOixeeXMZmLKmx5vWA',
      icon: Symbols.handshake,
      title: 'Deal Accepted',
      time: '15m ago',
      actorName: 'Arjun',
      bodyText: ' accepted your terms for ',
      boldItem: 'TaskFlow Pro',
      isUnread: true,
      rating: null,
      isDeadline: false,
    ),
    (
      imageUrl: '',
      icon: Symbols.timer,
      title: 'Deadline Reminder',
      time: '1h ago',
      actorName: '',
      bodyText: '',
      boldItem: null,
      isUnread: false,
      rating: null,
      isDeadline: true,
    ),
    (
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCqu97dGCVC9axOWiYXMrjmkZa8RO6R8wuBXqxYz1MyF69kVCbx21FOn1FEPLxDuVUxlfm0m0riQZh0dXU0FLZbXLBVsD4935HiFzfR-BlmOmF-6UOnPIxoiB0IGK99eK-oCi-C3qqm2qSWcwCwMP_ERjFspzJyJU8hFrmmtnth0PX7eMWKkBhdkjCY6zoOOsV1W6iUB-tsHW5dp5GcOiTE-RtrLbLrhAteRtJ6cLRtXPAExOqTr-y9JBHeYyj3gaYYieNUZ16mPTI',
      icon: Symbols.star,
      title: 'Rating Received',
      time: '3h ago',
      actorName: 'Kabir Singh',
      bodyText: ' left you a review:',
      boldItem: null,
      isUnread: false,
      rating: 5.0,
      isDeadline: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList.separated(
        itemCount: _data.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final d = _data[i];
          if (d.isDeadline) return _DeadlineCard(bc: bc);
          return _NotificationCard(
            imageUrl: d.imageUrl,
            icon: d.icon,
            iconColor: d.icon == Symbols.handshake ? bc.tertiary : d.icon == Symbols.star ? bc.secondary : bc.primary,
            title: d.title,
            time: d.time,
            message: _buildMessage(context, d),
            isUnread: d.isUnread,
            rating: d.rating,
            bc: bc,
          );
        },
      ),
    );
  }

  Widget _buildMessage(BuildContext context, _NotificationData d) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: bc.onSurfaceVariant),
        children: [
          TextSpan(text: d.actorName, style: TextStyle(color: bc.primary, fontWeight: FontWeight.bold)),
          TextSpan(text: d.bodyText),
          if (d.boldItem != null)
            TextSpan(text: d.boldItem, style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
          if (d.boldItem != null) const TextSpan(text: '.'),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.imageUrl,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.message,
    this.rating,
    this.isUnread = false,
    required this.bc,
  });

  final String imageUrl;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  final Widget message;
  final double? rating;
  final bool isUnread;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        border: isUnread ? Border(left: BorderSide(color: bc.primary, width: 4)) : null,
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BarterNetworkImage(
                  url: imageUrl,
                  width: 56,
                  height: 56,
                  memCacheWidth: 112,
                  memCacheHeight: 112,
                ),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: bc.surfaceContainerLowest, width: 2),
                  ),
                  child: Icon(icon, color: bc.onPrimary, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                message,
                if (rating != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(5, (index) => Icon(
                        Symbols.star,
                        color: bc.primary,
                        size: 16,
                        fill: 1,
                      )),
                      const SizedBox(width: 4),
                      Text(
                        rating!.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: bc.onSurface,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isUnread) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: bc.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  const _DeadlineCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -32,
            right: -32,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: bc.primary.withValues(alpha: 0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: bc.primaryFixedDim,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Symbols.alarm, color: bc.primary, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deadline Approaching',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '1h ago',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1 DAY LEFT',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.primary,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                fontSize: 10,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ship your assets for SoundWave VIP Pass to Rahul.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: bc.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.push('/deal/sample/shipping'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bc.primary,
                        foregroundColor: bc.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Action Now',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              fontSize: 10,
                            ),
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

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.onBackground,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -48,
            right: -48,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: bc.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Symbols.verified, color: bc.primary, size: 40),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: bc.onPrimary,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.1,
                      ),
                  children: [
                    const TextSpan(text: 'New Verified\n'),
                    const TextSpan(text: 'Brands'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '3 major beauty brands just joined the exchange circle.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: bc.onPrimary.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => context.go('/creator/feed'),
                icon: Icon(Symbols.arrow_forward, color: bc.primary),
                label: Text(
                  'Explore Now',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontSize: 12,
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
