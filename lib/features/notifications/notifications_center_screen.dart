import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/dto/notification_dto.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_appbar.dart';
import '../../widgets/barter_chips.dart';
import '../../widgets/barter_text.dart';
import '../../widgets/barter_network_image.dart';

class NotificationsCenterScreen extends ConsumerStatefulWidget {
  const NotificationsCenterScreen({super.key});

  @override
  ConsumerState<NotificationsCenterScreen> createState() => _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends ConsumerState<NotificationsCenterScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final notificationsAsync = ref.watch(notificationsProvider);
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
          notificationsAsync.maybeWhen(
            data: (items) {
              final unread = items.where((n) => !n.read).length;
              if (unread == 0) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: bc.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unread > 99 ? '99+' : '$unread',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                      ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Symbols.notifications, color: bc.primary),
            onPressed: () => context.push('/notifications/settings'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) {
          final filtered = _selectedFilter == 'Unread'
              ? items.where((n) => !n.read).toList()
              : _selectedFilter == 'Exchanges'
                  ? items.where((n) => n.type.contains('deal') || n.type.contains('proposal')).toList()
                  : _selectedFilter == 'Ratings'
                      ? items.where((n) => n.type.contains('rating')).toList()
                      : items;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    children: [
                      _FilterChips(
                        bc: bc,
                        selected: _selectedFilter,
                        onSelected: (f) => setState(() => _selectedFilter = f),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              if (filtered.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text('No notifications')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, i) => _LiveNotificationCard(n: filtered[i], bc: bc),
                  ),
                ),
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
          );
        },
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.bc, required this.selected, required this.onSelected});

  final BarterColors bc;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const filters = ['All', 'Unread', 'Exchanges', 'Ratings'];
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filters
            .map((f) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: BarterChip(
                    label: f,
                    variant: BarterChipVariant.filter,
                    selected: f == selected,
                    onTap: () => onSelected(f),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _LiveNotificationCard extends StatelessWidget {
  const _LiveNotificationCard({required this.n, required this.bc});

  final NotificationDto n;
  final BarterColors bc;

  IconData get _icon {
    if (n.type.contains('proposal')) return Symbols.mail;
    if (n.type.contains('deal') || n.type.contains('accept')) return Symbols.handshake;
    if (n.type.contains('rating')) return Symbols.star;
    if (n.type.contains('deadline') || n.type.contains('reminder')) return Symbols.timer;
    return Symbols.notifications;
  }

  Color _iconColor(BarterColors bc) {
    if (n.type.contains('rating')) return bc.secondary;
    if (n.type.contains('deal') || n.type.contains('accept')) return bc.tertiary;
    return bc.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        border: !n.read ? Border(left: BorderSide(color: bc.primary, width: 4)) : null,
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _iconColor(bc).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_icon, color: _iconColor(bc), size: 24),
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
                        n.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    if (n.createdAt != null)
                      Text(
                        _timeAgo(n.createdAt!),
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
                Text(
                  n.body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          if (!n.read) ...[const SizedBox(width: 8), Container(width: 8, height: 8, decoration: BoxDecoration(color: bc.primary, shape: BoxShape.circle))],
        ],
      ),
    );
  }

  String _timeAgo(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
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
