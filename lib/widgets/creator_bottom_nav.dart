import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/barter_colors.dart';

class CreatorBottomNav extends StatelessWidget {
  const CreatorBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.inboxBadgeCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int inboxBadgeCount;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      decoration: BoxDecoration(
        color: bc.background.withValues(alpha: 0.6),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                label: 'Feed',
                icon: Symbols.style,
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                label: 'Drops',
                icon: Symbols.flare,
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                label: 'Deals',
                icon: Symbols.handshake,
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                label: 'Inbox',
                icon: Symbols.chat_bubble,
                selected: currentIndex == 3,
                badgeCount: inboxBadgeCount,
                onTap: () => onTap(3),
              ),
              _NavItem(
                label: 'Profile',
                icon: Symbols.person,
                selected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final color = selected ? bc.primary : bc.onSurface.withValues(alpha: 0.45);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 26,
                  fill: selected ? 1.0 : 0.0,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: bc.error,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: bc.background, width: 1.5),
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        badgeCount > 99 ? '99+' : '$badgeCount',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onError,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 10,
                    color: color,
                    letterSpacing: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
