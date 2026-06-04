import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/brand_desktop_sidebar.dart';

class BrandShell extends StatefulWidget {
  const BrandShell({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  final Widget child;
  final int selectedIndex;

  @override
  State<BrandShell> createState() => _BrandShellState();
}

class _BrandShellState extends State<BrandShell> {
  final _drawerKey = GlobalKey<ScaffoldState>();

  static const _routes = [
    '/brand/dashboard',
    '/brand/campaigns',
    '/brand/review',
    '/brand/pipeline',
    '/brand/analytics',
    '/brand/discover',
    '/brand/inbox',
    '/brand/profile',
  ];

  void _onSelect(BuildContext context, int index) {
    if (index < _routes.length) {
      context.go(_routes[index]);
    }
  }

  void _openDrawer() => _drawerKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final wide = context.isWide;

    if (!wide) {
      return Scaffold(
        key: _drawerKey,
        backgroundColor: bc.background,
        drawer: _BrandDrawer(
          selectedIndex: widget.selectedIndex,
          onSelect: (i) {
            Navigator.of(context).pop();
            _onSelect(context, i);
          },
        ),
        body: Column(
          children: [
            _BrandMobileHeader(
              bc: bc,
              onMenuTap: _openDrawer,
            ),
            Expanded(child: widget.child),
          ],
        ),
        bottomNavigationBar: _BrandBottomNav(
          selectedIndex: widget.selectedIndex,
          onTap: (i) {
            if (i == 4) {
              _openDrawer();
            } else {
              const bottomRouteMap = [0, 1, 6, 7];
              _onSelect(context, bottomRouteMap[i]);
            }
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: bc.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandDesktopSidebar(
            selectedIndex: widget.selectedIndex,
            onSelect: (i) => _onSelect(context, i),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

// ─── Mobile Header ─────────────────────────────────────────────────────────────

class _BrandMobileHeader extends StatelessWidget {
  const _BrandMobileHeader({required this.bc, required this.onMenuTap});
  final BarterColors bc;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bc.primaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Symbols.analytics, color: bc.onPrimary, size: 18, fill: 1),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Editorial Exchange',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            IconButton(
              onPressed: onMenuTap,
              icon: Icon(Symbols.menu, color: bc.onBackground),
              style: IconButton.styleFrom(
                backgroundColor: bc.surfaceContainerLowest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Drawer ────────────────────────────────────────────────────────────────────

class _BrandDrawer extends StatelessWidget {
  const _BrandDrawer({required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final ValueChanged<int> onSelect;

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
    return Drawer(
      backgroundColor: bc.background,
      width: 280,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: bc.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(Symbols.analytics, color: bc.onPrimary, fill: 1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Editorial Exchange',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: bc.primary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 2),
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
            const SizedBox(height: 16),
            Divider(color: bc.outlineVariant.withValues(alpha: 0.2), indent: 24, endIndent: 24),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: _items.length,
                itemBuilder: (context, i) {
                  final sel = i == selectedIndex;
                  final (label, icon) = _items[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Material(
                      color: sel ? bc.surfaceContainerHigh : Colors.transparent,
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(999)),
                      child: InkWell(
                        onTap: () => onSelect(i),
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(999)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 14, 20, 14),
                          child: Row(
                            children: [
                              Icon(
                                icon,
                                fill: sel ? 1.0 : 0.0,
                                size: 22,
                                color: sel ? bc.primary : bc.onSurface.withValues(alpha: 0.65),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                label.toUpperCase(),
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontSize: 12,
                                      letterSpacing: 1.5,
                                      fontWeight: sel ? FontWeight.w800 : FontWeight.w600,
                                      color: sel
                                          ? bc.primary
                                          : bc.onSurface.withValues(alpha: 0.65),
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: bc.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Symbols.person, size: 18, color: bc.onSurfaceVariant),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Arjun Sharma',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: bc.onSurface,
                                ),
                          ),
                          Text(
                            'Brand Manager',
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
      ),
    );
  }
}

class _BrandBottomNav extends StatelessWidget {
  const _BrandBottomNav({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  // Bottom nav positions: 0=Overview, 1=Campaigns, 2=Inbox, 3=Profile, 4=More(drawer)
  static const _bottomItems = [
    (Symbols.dashboard, 'Overview'),
    (Symbols.campaign, 'Campaigns'),
    (Symbols.chat_bubble, 'Inbox'),
    (Symbols.business, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    // Map full selectedIndex to bottom nav active tab
    const activeMap = {0: 0, 1: 1, 6: 2, 7: 3};
    final bottomActive = activeMap[selectedIndex];

    return Container(
      decoration: BoxDecoration(
        color: bc.background,
        border: Border(
          top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.15)),
        ),
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
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < _bottomItems.length; i++)
                _NavItem(
                  icon: _bottomItems[i].$1,
                  label: _bottomItems[i].$2,
                  active: bottomActive == i,
                  onTap: () => onTap(i),
                ),
              _NavItem(
                icon: Symbols.menu,
                label: 'More',
                active: bottomActive == null,
                fillable: false,
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
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.fillable = true,
  });

  final IconData icon;
  final String label;
  final bool active;
  final bool fillable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final color = active ? bc.primary : bc.onSurface.withValues(alpha: 0.45);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, fill: fillable && active ? 1.0 : 0.0),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 10,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
