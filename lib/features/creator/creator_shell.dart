import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/creator_bottom_nav.dart';

class CreatorShell extends ConsumerWidget {
  const CreatorShell({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  final Widget child;
  final int selectedIndex;

  void _go(BuildContext context, int i) {
    switch (i) {
      case 0:
        context.go('/creator/feed');
      case 1:
        context.go('/creator/drops');
      case 2:
        context.go('/creator/deals');
      case 3:
        context.go('/creator/inbox');
      case 4:
        context.go('/creator/profile');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final unreadCount = ref.watch(notificationsProvider).maybeWhen(
      data: (items) => items.where((n) => !n.read).length,
      orElse: () => 0,
    );
    return Scaffold(
      backgroundColor: bc.background,
      body: child,
      bottomNavigationBar: CreatorBottomNav(
        currentIndex: selectedIndex,
        inboxBadgeCount: unreadCount,
        onTap: (i) => _go(context, i),
      ),
    );
  }
}
