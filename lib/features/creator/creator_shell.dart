import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/barter_colors.dart';
import '../../widgets/creator_bottom_nav.dart';

class CreatorShell extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Scaffold(
      backgroundColor: bc.background,
      body: child,
      bottomNavigationBar: CreatorBottomNav(
        currentIndex: selectedIndex,
        inboxBadgeCount: 3,
        onTap: (i) => _go(context, i),
      ),
    );
  }
}
