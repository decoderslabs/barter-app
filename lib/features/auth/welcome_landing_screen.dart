import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_buttons.dart';
import '../../widgets/barter_network_image.dart';

class WelcomeLandingScreen extends StatelessWidget {
  const WelcomeLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final isWide = context.isWide;
    return Scaffold(
      backgroundColor: bc.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: bc.background.withValues(alpha: 0.6),
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: BarterNetworkImage(
                    url:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAPHMZ7MydIjr5uT3bpufh2GNllTy-RqbpVLDB8FJJPTnMlIh-RfY5uYtlA2aCBCe9Hsb9qRTbM83P28Z3AcEKgDbak6mwGuRt7Axr4yfCLMCBBO_ccCznkFJ4bXGjNvclBSa2D--R8QaBIfuob9bJf7XkVrLezAQHUSqgWISHYjejktGMZ9LSSZ33G3l3A3UOqIu0wc_Dg6Ps-tGtrKyt90kngHJGwNEXUCB6liAYIRJRRaizi8nGIjQgcj3r7ZVRtNsZlgXIN2Fg',
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'BARTER',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        color: bc.onBackground,
                      ),
                ),
                const Spacer(),
                if (isWide) ...[
                  TextButton(
                    onPressed: () => context.go('/creator/membership/earn'),
                    child: Text(
                      'Membership',
                      style: TextStyle(
                        color: bc.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/creator/feed'),
                    child: Text(
                      'Journal',
                      style: TextStyle(
                        color: bc.onBackground.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                ],
                TextButton(
                  onPressed: () => context.go('/sign-in'),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: bc.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
            sliver: SliverToBoxAdapter(
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _HeroCopy()),
                        const SizedBox(width: 32),
                        const Expanded(flex: 5, child: _HeroVisual()),
                      ],
                    )
                  : const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroCopy(),
                        SizedBox(height: 32),
                        _HeroVisual(),
                      ],
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: bc.surfaceContainerLow,
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: const _TrustGrid(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EDITORIAL EXCHANGE',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: bc.primary,
                letterSpacing: 4,
              ),
        ),
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 0.95,
                  letterSpacing: -2,
                  color: bc.onBackground,
                ),
            children: [
              const TextSpan(text: 'THE '),
              TextSpan(
                text: 'EXCHANGE.',
                style: TextStyle(
                  color: bc.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'The Curated Canvas for Editorial Barter.\nBy Invitation Only.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 28),
        BarterPrimaryButton(
          label: 'Apply for Membership',
          icon: Symbols.arrow_forward,
          onPressed: () => context.go('/sign-in'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go('/sign-in'),
          child: Text(
            'Already on the list? Sign In',
            style: TextStyle(
              color: bc.tertiary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            BarterNetworkImage(
              url:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCTGrhOopa1vkTyDSWk8ViEjrw2bFt5zqR_hU01EuGQDzMfdAz5Z2ixz8VMYjBcG5BKqj8Nrfo0buiRrrFXnv5-cklpGwIM9X2Cr2X6odXPzGbcrCW0vpvc8pkWo5m8lb611pTSjcLWTmg2-olEjrydsI_z_ouAU1H9gIOWhGC_ytxhMMsidIXN3aB_7x_iOud_KzRuhX_ogRPR3uiRw0c_PEoMiqO_faBJqL98i1x8zm9IkMhIPn719ronvpnqdiBwGJrRHF-hmTg',
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    bc.background.withValues(alpha: 0.45),
                    Colors.transparent,
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

class _TrustGrid extends StatelessWidget {
  const _TrustGrid();

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final isWide = context.isWide;
    final items = [
      ('500', 'Vetted Brands', 'Global luxury partners across lifestyle, tech, and travel.'),
      ('1.2k', 'Creators', 'Hand-selected editorial talent with verified engagement.'),
      ('98%', 'Match Rate', 'Precision algorithm ensuring brand-creator alignment.'),
    ];
    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 32),
            _TrustItem(bc: bc, index: i, line1: items[i].$1, line2: items[i].$2, line3: items[i].$3),
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                height: 120,
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: bc.outlineVariant.withValues(alpha: 0.25),
                ),
              ),
            ),
          Expanded(
            child: _TrustItem(
              bc: bc,
              index: i,
              line1: items[i].$1,
              line2: items[i].$2,
              line3: items[i].$3,
            ),
          ),
        ],
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({
    required this.bc,
    required this.index,
    required this.line1,
    required this.line2,
    required this.line3,
  });

  final BarterColors bc;
  final int index;
  final String line1;
  final String line2;
  final String line3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line1,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: index == 0 ? bc.primary : bc.onSurface,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          line2.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                letterSpacing: 2,
                color: bc.onSurface,
              ),
        ),
        const SizedBox(height: 6),
        Text(line3, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
