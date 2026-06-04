import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../theme/responsive_extension.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_network_image.dart';

class CreatorProfileScreen extends ConsumerWidget {
  const CreatorProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(authProvider.notifier).logout();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signed out successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.go('/welcome');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        leading: BarterProfileAvatar(
          imageUrl: user?.profilePhotoUrl,
        ),
        actions: [
          IconButton(
            icon: Icon(Symbols.notifications, color: bc.onBackground),
            onPressed: () => context.push('/notifications/center'),
          ),
          IconButton(
            icon: Icon(Symbols.logout, color: bc.onBackground),
            tooltip: 'Sign out',
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroSection(bc: bc),
            const SizedBox(height: 48),
            _KPIGrid(bc: bc),
            const SizedBox(height: 64),
            _DealHistorySection(bc: bc),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: bc.surfaceContainer,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: bc.onBackground.withValues(alpha: 0.2),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: BarterNetworkImage(
                        url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCHeYJCGsJh92o1tQtWI4nkcknCt5-VYNTTfjhOi32iLHDj65Z3VQwMrAXLQb_Dv2RH9khpvUR5m4eFoaruWst4A0P6PA0duZ8Znm4Cz9CQOL9V_YKYDgRtk0KZfkGSWaWFOMUezlgxy39fyr0Guy8aYDyntSvxh9dkhu2nZJdiFFH8T-pRGId4xhJnWjKl8vdZ9p2VGxBzCR_YLeusHALMQqs8zzaoYkk_CSVJ7NdHDGdKTHU3enX8OwnNwM5gNvq1wcqkcJ9DXno',
                        fit: BoxFit.cover,
                        memCacheWidth: 256,
                        memCacheHeight: 256,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: bc.tertiaryContainer,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: bc.onBackground.withValues(alpha: 0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Symbols.verified,
                            color: bc.onTertiaryContainer,
                            size: 16,
                            fill: 1,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified Creator',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: bc.onTertiaryContainer,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                        children: [
                          const TextSpan(text: 'Maya '),
                          TextSpan(
                            text: 'Sterling',
                            style: TextStyle(color: bc.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Digital Storyteller & Tech Enthusiast',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: bc.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Crafting high-end editorial content for brands that value authenticity and visual excellence. Specializing in lifestyle tech and sustainable fashion.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: bc.onSurfaceVariant,
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => context.push('/creator/offer-feed'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bc.primary,
                            foregroundColor: bc.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                            shadowColor: bc.primary.withValues(alpha: 0.2),
                          ),
                          child: Text(
                            'Request Barter',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Messaging coming soon')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: bc.surfaceContainerHigh,
                            foregroundColor: bc.onSurface,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Message',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
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
        const SizedBox(width: 24),
        _BarterScoreCard(bc: bc),
      ],
    );
    }
    // Mobile: vertical stack
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: bc.surfaceContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: bc.onBackground.withValues(alpha: 0.2),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: BarterNetworkImage(
                      url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCHeYJCGsJh92o1tQtWI4nkcknCt5-VYNTTfjhOi32iLHDj65Z3VQwMrAXLQb_Dv2RH9khpvUR5m4eFoaruWst4A0P6PA0duZ8Znm4Cz9CQOL9V_YKYDgRtk0KZfkGSWaWFOMUezlgxy39fyr0Guy8aYDyntSvxh9dkhu2nZJdiFFH8T-pRGId4xhJnWjKl8vdZ9p2VGxBzCR_YLeusHALMQqs8zzaoYkk_CSVJ7NdHDGdKTHU3enX8OwnNwM5gNvq1wcqkcJ9DXno',
                      fit: BoxFit.cover,
                      memCacheWidth: 256,
                      memCacheHeight: 256,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: bc.tertiaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Symbols.verified, color: bc.onTertiaryContainer, size: 12, fill: 1),
                        const SizedBox(width: 3),
                        Text(
                          'Verified',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.onTertiaryContainer,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize: 9,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                      children: [
                        const TextSpan(text: 'Maya '),
                        TextSpan(
                          text: 'Sterling',
                          style: TextStyle(color: bc.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Digital Storyteller & Tech Enthusiast',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: bc.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Crafting high-end editorial content for brands that value authenticity and visual excellence. Specializing in lifestyle tech and sustainable fashion.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
                height: 1.6,
              ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => context.push('/creator/offer-feed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: bc.primary,
                foregroundColor: bc.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                shadowColor: bc.primary.withValues(alpha: 0.2),
              ),
              child: const Text('Request Barter'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Messaging coming soon')),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: bc.surfaceContainerHigh,
                foregroundColor: bc.onSurface,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide.none,
              ),
              child: const Text('Message'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _BarterScoreCard(bc: bc, fullWidth: true),
      ],
    );
  }
}

class _BarterScoreCard extends StatelessWidget {
  const _BarterScoreCard({required this.bc, this.fullWidth = false});

  final BarterColors bc;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 80,
            offset: const Offset(0, 40),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Barter Score',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.secondary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 10,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '98',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: bc.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Top 1% Creator',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bc.tertiary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _KPIGrid extends StatelessWidget {
  const _KPIGrid({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final wide = context.isWide;
    final cards = [
      _KPICard(platform: 'Instagram', icon: Symbols.camera, followers: '1.2M', engagement: '4.8%', reach: '850K', bc: bc),
      _KPICard(platform: 'TikTok', icon: Symbols.bolt, followers: '2.5M', engagement: '12.4%', reach: '3.1M', bc: bc),
      _KPICard(platform: 'YouTube', icon: Symbols.play_circle, followers: '450K', engagement: '9.1%', reach: '125K', bc: bc),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Platform Stats',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => context.push('/creator/profile/kpi'),
              child: Text(
                'View KPI Details →',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (wide)
          Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 24),
              Expanded(child: cards[1]),
              const SizedBox(width: 24),
              Expanded(child: cards[2]),
            ],
          )
        else
          Column(
            children: [
              cards[0],
              const SizedBox(height: 16),
              cards[1],
              const SizedBox(height: 16),
              cards[2],
            ],
          ),
      ],
    );
  }
}

class _KPICard extends StatelessWidget {
  const _KPICard({
    required this.platform,
    required this.icon,
    required this.followers,
    required this.engagement,
    required this.reach,
    required this.bc,
  });

  final String platform;
  final IconData icon;
  final String followers;
  final String engagement;
  final String reach;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: bc.primary, size: 24),
              ),
              Text(
                platform,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 10,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            followers,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            platform == 'YouTube' ? 'Subscribers' : 'Followers',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: bc.secondary,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: bc.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        engagement,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        platform == 'YouTube' ? 'CTR' : 'ENGAGEMENT',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurfaceVariant,
                              letterSpacing: 1.5,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reach,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        platform == 'YouTube' ? 'VIEWS/VID' : 'AVG. REACH',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurfaceVariant,
                              letterSpacing: 1.5,
                              fontSize: 10,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

typedef _DealHistoryData = ({
  String brand,
  String category,
  String rating,
  String title,
  String description,
  String imageUrl,
});

const _kDealHistory = <_DealHistoryData>[
  (
    brand: 'LuxeTech',
    category: 'Tech & Gadgets',
    rating: '5.0',
    title: 'Quantum Series Launch Campaign',
    description: 'High-performance video series demonstrating daily integration of the Quantum 5 ecosystem.',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDyPYZKUfpQ9kvvPt1qcS0iOUEtQzFCxpUDp_Ouoj2xKx8dNsJoOwQJRIwv6GVuz-m4ghJZJq07hGxvAtWdiiOFxBiFv3gHjIeov8izvkxTTrP7Qa0A8VOIf4yBLiwRY71GuTRlOb8lv_TGG6J81grAkllxpV6pxkdnslSAOHFC5Ce6qIi4dKE72H-d1rtd1HPWUixHEbHXeE4-qzJLv5u7RGW_ZWUTe0B4zxSXags4RbELgcFfuDs9tsbsyiZZ8ws6FRZNUm9Xff8',
  ),
  (
    brand: 'Aether',
    category: 'Fashion',
    rating: '4.9',
    title: 'Aesthetic Footwear Editorial',
    description: 'Creative lookbook and lifestyle shots for the Sustainable Step collection.',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBToh0F-MrjKT1r1O_lmTOA_0mHB6n_TJdJ3a9zRoaX7Yp9QuHOH-I2jl47IL3Q6Wjhb180wCBh159LeKM4eGsI4ALnpVXD44uLtt4ywDGSTh5L6IlRf1HKLY4-VLx2PCTYo0ORsMLeJLjtb5mmnVuPHfcEAWGeaV6xXXq4q-XrnBFTgEsBmmdcLDLCo1_JsFvlMx4-k0VdO9V3gGmDZdQ9T7NYowyDA1BJmuZ-vOscA2fVz6HTmHlgsUgabVRSV7aKRYuTxFJVk_0',
  ),
  (
    brand: 'Nook',
    category: 'Home Decor',
    rating: '5.0',
    title: 'Minimalist Home Integration',
    description: 'Strategic placement of Nook essentials in a modern creator studio environment.',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuChF02KUs3rz3G7B1crSCnTKkjD7if1u5TpplyO6mG5VdpPMirzM4JVaabhCZ4sjKi0dekqMT_Qy6-tPXcUxq_Z-OzMe7kIXYGUjH2UyECvsdzvmgVz8UmW9-KY1_G4yoHbcdMUsW0_SOJBP2Fb7k1byV1DbkvEge3-3SbB5A9wihtgCFrTTA0oTMUQUbq9fMVg9VPVZ5l03Ap0q-60shQkkfG5BR_IDuMuh8oKPpnOzb22qav6F5Evr7eKbUKtm24Bsk2VU9DH8pg',
  ),
];

class _DealHistorySection extends StatelessWidget {
  const _DealHistorySection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Deal History',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '142 Successful Exchanges',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 360,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _kDealHistory.length,
            separatorBuilder: (_, __) => const SizedBox(width: 24),
            itemBuilder: (context, i) {
              final d = _kDealHistory[i];
              return _DealCard(brand: d.brand, category: d.category, rating: d.rating, title: d.title, description: d.description, imageUrl: d.imageUrl, bc: bc);
            },
          ),
        ),
      ],
    );
  }
}

class _DealCard extends StatelessWidget {
  const _DealCard({
    required this.brand,
    required this.category,
    required this.rating,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.bc,
  });

  final String brand;
  final String category;
  final String rating;
  final String title;
  final String description;
  final String imageUrl;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 160,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: BarterNetworkImage(
                    url: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 560,
                    memCacheHeight: 320,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: bc.background.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    brand,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 10,
                          ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Symbols.star,
                          color: bc.primary,
                          size: 16,
                          fill: 1,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
