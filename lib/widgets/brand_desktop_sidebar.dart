import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/barter_colors.dart';
import 'barter_network_image.dart';

class BrandDesktopSidebar extends StatelessWidget {
  const BrandDesktopSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    this.userName = 'Arjun Sharma',
    this.userTitle = 'Brand Manager',
    this.avatarUrl,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final String userName;
  final String userTitle;
  final String? avatarUrl;

  static const _items = [
    ('Overview', Symbols.dashboard),
    ('Campaigns', Symbols.campaign),
    ('Review', Symbols.group),
    ('Pipeline', Symbols.view_kanban),
    ('Analytics', Symbols.analytics),
    ('Discover', Symbols.person_search),
    ('Inbox', Symbols.chat_bubble),
    ('Profile', Symbols.business),
  ];

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      width: 288,
      height: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 24),
      decoration: BoxDecoration(
        color: bc.background,
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(40, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bc.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Symbols.analytics, color: bc.onPrimary, fill: 1),
                ),
                const SizedBox(height: 16),
                Text(
                  'Editorial Exchange',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'BRAND DASHBOARD',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 10,
                        letterSpacing: 2,
                        color: bc.onSurfaceVariant.withValues(alpha: 0.55),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final sel = i == selectedIndex;
                final (label, icon) = _items[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Material(
                    color: sel ? bc.surfaceContainerHigh : Colors.transparent,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(999),
                    ),
                    child: InkWell(
                      onTap: () => onSelect(i),
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 16, 24, 16),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              fill: sel ? 1.0 : 0.0,
                              color: sel ? bc.primary : bc.onSurface.withValues(alpha: 0.65),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                label.toUpperCase(),
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontSize: 12,
                                      letterSpacing: 1.5,
                                      fontWeight: sel ? FontWeight.w800 : FontWeight.w600,
                                      color: sel ? bc.primary : bc.onSurface.withValues(alpha: 0.65),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bc.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: avatarUrl != null
                        ? SizedBox(
                            width: 40,
                            height: 40,
                            child: BarterNetworkImage(url: avatarUrl!),
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            color: bc.surfaceContainerHigh,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: bc.onSurface,
                              ),
                        ),
                        Text(
                          userTitle,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontSize: 10,
                                color: bc.onSurfaceVariant.withValues(alpha: 0.55),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
