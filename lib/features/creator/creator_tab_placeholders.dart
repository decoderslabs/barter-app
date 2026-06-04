import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/barter_colors.dart';
import '../../widgets/barter_network_image.dart';

class CreatorDropsTabScreen extends StatelessWidget {
  const CreatorDropsTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: bc.background,
      body: CustomScrollView(
        slivers: [
          const _CreatorTabAppBar(),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editorial Header
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.onSurface,
                        height: 1.1,
                      ),
                      children: [
                        const TextSpan(text: 'The '),
                        TextSpan(
                          text: 'Feed',
                          style: TextStyle(color: bc.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Curated brand exchanges for elite storytellers.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: bc.secondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search brands, niches, or keywords...',
                        hintStyle: TextStyle(color: bc.outline.withValues(alpha: 0.6)),
                        prefixIcon: Icon(Icons.search, color: bc.outline),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Filter Chips
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip(context, bc, theme, label: 'Type: SaaS', isActive: true),
                        const SizedBox(width: 12),
                        _buildFilterChip(context, bc, theme, label: 'Value: \$500+', isActive: false),
                        const SizedBox(width: 12),
                        _buildFilterChip(context, bc, theme, label: 'Niche: Tech', isActive: false),
                        const SizedBox(width: 12),
                        _buildFilterChip(context, bc, theme, label: 'Platform: IG', isActive: false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Barter Drops Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: bc.onBackground,
                          ),
                          children: [
                            const TextSpan(text: 'Barter '),
                            TextSpan(
                              text: 'Drops',
                              style: TextStyle(
                                color: bc.primary,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/creator/feed'),
                        child: Text(
                          'View All',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: bc.tertiary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Drop Cards Horizontal
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildDropCard(context, bc, theme,
                          title: 'Alpha Wear Pro',
                          subtitle: 'Exclusive Gym Launch',
                          value: '\$1,200',
                          badge: '4 Slots Left',
                          icon: Icons.auto_awesome,
                          iconColor: bc.tertiary,
                          iconBg: bc.tertiaryContainer,
                        ),
                        const SizedBox(width: 24),
                        _buildDropCard(context, bc, theme,
                          title: 'Skyline Resorts',
                          subtitle: 'Bali Explorer Drop',
                          value: '\$4,500',
                          badge: 'Ending Soon',
                          icon: Icons.flight_takeoff,
                          iconColor: bc.primary,
                          iconBg: bc.primaryFixed,
                          isEndingSoon: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Featured Exchanges Section
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: bc.onBackground,
                      ),
                      children: [
                        const TextSpan(text: 'Featured '),
                        TextSpan(
                          text: 'Exchanges',
                          style: TextStyle(color: bc.secondary.withValues(alpha: 0.5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Offer Card 1
                  _buildOfferCard(context, bc, theme,
                    brandName: 'StreamFlow AI',
                    brandType: 'SaaS',
                    brandDesc: 'Content Automation Suite',
                    title: 'Scale your content creation with lifetime pro access.',
                    description: "We're looking for high-quality video creators to showcase our new AI video editor. You get lifetime access and 3 feature spots.",
                    value: '\$2,400 Est. Value',
                    deliverable: '3x Reels / TikTok',
                    platforms: ['IG', 'TT'],
                    isVerified: true,
                    brandLogo: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCquinfoPTqPDiR6oc-limfncVK9lRZq1p5nRup5kRBuS0lczo3dV2BWRIko3djLsXLXVs2DDKqG5OAw4aLgkeXA41PHx3RtBBLbiiPITBZNuNfuq-k9fMx4lBwpA2BcPaSekzPW9uY8B_2GuIa-qkaKWKzmPCYbnagTEUDzmITVxOA-MTYZJ1ZdfwuMhv95npObqyaNNbOIS_Te3qxDGPc5QuPgP-HmnbPHB6NbMgRU3ONSwHr-VUrcuk1QxhModHKVSJtkZ2afhM',
                  ),
                  const SizedBox(height: 24),
                  
                  // Offer Card 2
                  _buildOfferCard(context, bc, theme,
                    brandName: 'Luna Horology',
                    brandType: 'Product',
                    brandDesc: 'Luxury Timepieces',
                    title: 'The "Stellar" Collection launch partnership.',
                    description: 'High-end lifestyle photography for our upcoming collection. Product shipping worldwide. Looking for aesthetic-driven creators.',
                    value: '\$850 Est. Value',
                    deliverable: '5x Hi-Res Photos',
                    platforms: ['X', 'IN'],
                    isVerified: false,
                    brandLogo: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDjSjEgkQfsBNIvUqLlhVl2sar4YdAOZuuV_NCc56AR90Yzv6s3FD3yxM-V-RDQY4InxwWexj3Qq9pLu6eWlUjv3ktUfFszub1PxLtorAsA40uDqcS65rBd0b5PU3xk5O1HbV8w5xgvBFIAHAPoR9czWDiEx0eJ_VOS_h3UbHgN9MGmLCC1XgLNRWavL56SsG0ed0Sz8ElH0vWHaWcK04wbIlxQNJOE87adKQ_ex_A-h_nkMIAJWhw2rYFGikrHLcHAXY2wMV2vAEw',
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String label,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? bc.primary : bc.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive) ...[
            Icon(Icons.filter_list, size: 18, color: bc.onPrimary),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isActive ? bc.onPrimary : bc.onSurface,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropCard(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String title,
    required String subtitle,
    required String value,
    required String badge,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    bool isEndingSoon = false,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: bc.onSurface.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
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
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isEndingSoon ? bc.error.withValues(alpha: 0.1) : bc.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isEndingSoon ? bc.error : bc.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: bc.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: bc.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: bc.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Value Drop',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: bc.outline,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String brandName,
    required String brandType,
    required String brandDesc,
    required String title,
    required String description,
    required String value,
    required String deliverable,
    required List<String> platforms,
    required bool isVerified,
    required String brandLogo,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isVerified ? bc.surfaceContainerLowest : bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(40),
        border: isVerified 
            ? Border.all(color: bc.outlineVariant.withValues(alpha: 0.05))
            : Border.all(color: bc.outlineVariant.withValues(alpha: 0.1)),
        boxShadow: isVerified ? [
          BoxShadow(
            color: bc.onSurface.withValues(alpha: 0.03),
            blurRadius: 50,
            offset: const Offset(0, 20),
          ),
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isVerified ? bc.surfaceContainer : bc.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BarterNetworkImage(
                        url: brandLogo,
                        fit: BoxFit.cover,
                        memCacheWidth: 112,
                        memCacheHeight: 112,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            brandName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: bc.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isVerified ? bc.tertiaryContainer : bc.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              brandType,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isVerified ? bc.onTertiaryContainer : bc.onSecondary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        brandDesc,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: bc.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: bc.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified, size: 16, color: bc.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Good match',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: bc.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          // Offer Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: bc.onSurface,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: bc.secondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Value & Deliverables
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.payments, color: bc.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: bc.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.videocam, color: bc.tertiary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      deliverable,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: bc.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: platforms.map((p) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: p == 'IG' ? bc.surfaceVariant : (p == 'X' ? bc.onBackground : bc.surfaceVariant),
                      shape: BoxShape.circle,
                      border: Border.all(color: bc.surfaceContainerLowest, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        p,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: p == 'X' ? bc.onPrimary : bc.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                )).toList(),
              ),
              ElevatedButton(
                onPressed: () => context.push('/creator/feed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVerified ? bc.primary : bc.onBackground,
                  foregroundColor: isVerified ? bc.onPrimary : bc.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                  shadowColor: bc.primary.withValues(alpha: 0.2),
                ),
                child: Text(
                  'View Offer',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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

class CreatorDealsTabScreen extends StatelessWidget {
  const CreatorDealsTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: bc.background,
      body: CustomScrollView(
        slivers: [
          const _CreatorTabAppBar(),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editorial Header
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.onSurface,
                        height: 1.1,
                      ),
                      children: [
                        const TextSpan(text: 'Your '),
                        TextSpan(
                          text: 'Deals',
                          style: TextStyle(color: bc.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track and manage your active partnerships.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: bc.secondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Stats Overview
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(context, bc, theme,
                          label: 'Active',
                          value: '3',
                          color: bc.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(context, bc, theme,
                          label: 'Pending',
                          value: '2',
                          color: bc.tertiary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(context, bc, theme,
                          label: 'Completed',
                          value: '15',
                          color: bc.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  // Active Deals Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                    'Active Deals',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: bc.onBackground,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/creator/feed'),
                    child: Text(
                      'View All',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: bc.tertiary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
                  
                  // Deal Card 1
                  _buildDealCard(context, bc, theme,
                    brandName: 'LuxeTech',
                    brandLogo: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDyPYZKUfpQ9kvvPt1qcS0iOUEtQzFCxpUDp_Ouoj2xKx8dNsJoOwQJRIwv6GVuz-m4ghJZJq07hGxvAtWdiiOFxBiFv3gHjIeov8izvkxTTrP7Qa0A8VOIf4yBLiwRY71GuTRlOb8lv_TGG6J81grAkllxpV6pxkdnslSAOHFC5Ce6qIi4dKE72H-d1rtd1HPWUixHEbHXeE4-qzJLv5u7RGW_ZWUTe0B4zxSXags4RbELgcFfuDs9tsbsyiZZ8ws6FRZNUm9Xff8',
                    title: 'Quantum Series Launch Campaign',
                    status: 'In Transit',
                    statusColor: bc.primaryContainer,
                    statusTextColor: bc.onPrimary,
                    value: '\$1,200',
                    dueDate: 'Oct 14, 2023',
                    progress: 0.75,
                  ),
                  const SizedBox(height: 24),
                  
                  // Deal Card 2
                  _buildDealCard(context, bc, theme,
                    brandName: 'Aether',
                    brandLogo: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBToh0F-MrjKT1r1O_lmTOA_0mHB6n_TJdJ3a9zRoaX7Yp9QuHOH-I2jl47IL3Q6Wjhb180wCBh159LeKM4eGsI4ALnpVXD44uLtt4ywDGSTh5L6IlRf1HKLY4-VLx2PCTYo0ORsMLeJLjtb5mmnVuPHfcEAWGeaV6xXXq4q-XrnBFTgEsBmmdcLDLCo1_JsFvlMx4-k0VdO9V3gGmDZdQ9T7NYowyDA1BJmuZ-vOscA2fVz6HTmHlgsUgabVRSV7aKRYuTxFJVk_0',
                    title: 'Aesthetic Footwear Editorial',
                    status: 'Draft Review',
                    statusColor: bc.secondaryContainer,
                    statusTextColor: bc.secondary,
                    value: '\$2,500',
                    dueDate: 'Oct 16, 2023',
                    progress: 0.5,
                  ),
                  const SizedBox(height: 24),
                  
                  // Deal Card 3
                  _buildDealCard(context, bc, theme,
                    brandName: 'Nook',
                    brandLogo: 'https://lh3.googleusercontent.com/aida-public/AB6AXuChF02KUs3rz3G7B1crSCnTKkjD7if1u5TpplyO6mG5VdpPMirzM4JVaabhCZ4sjKi0dekqMT_Qy6-tPXcUxq_Z-OzMe7kIXYGUjH2UyECvsdzvmgVz8UmW9-KY1_G4yoHbcdMUsW0_SOJBP2Fb7k1byV1DbkvEge3-3SbB5A9wihtgCFrTTA0oTMUQUbq9fMVg9VPVZ5l03Ap0q-60shQkkfG5BR_IDuMuh8oKPpnOzb22qav6F5Evr7eKbUKtm24Bsk2VU9DH8pg',
                    title: 'Minimalist Home Integration',
                    status: 'Signed',
                    statusColor: bc.tertiaryContainer,
                    statusTextColor: bc.onTertiaryContainer,
                    value: '\$850',
                    dueDate: 'Oct 18, 2023',
                    progress: 0.25,
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: bc.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String brandName,
    required String brandLogo,
    required String title,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String value,
    required String dueDate,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: bc.onSurface.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: bc.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BarterNetworkImage(
                    url: brandLogo,
                    fit: BoxFit.cover,
                    memCacheWidth: 112,
                    memCacheHeight: 112,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brandName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.onBackground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusTextColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: bc.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: bc.surfaceContainer,
                  valueColor: AlwaysStoppedAnimation<Color>(bc.primary),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Due Date',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dueDate,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: bc.onBackground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Value',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/deal/demo'),
              style: OutlinedButton.styleFrom(
                backgroundColor: bc.surfaceContainerHigh,
                foregroundColor: bc.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                side: BorderSide.none,
              ),
              child: Text(
                'View Deal Room',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProposalData {
  const _ProposalData({
    required this.name,
    required this.isVerified,
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.igFollowers,
    required this.tikTok,
    required this.engagement,
    required this.barterScore,
    required this.imageRotation,
    required this.imageUrl,
  });

  final String name;
  final bool isVerified;
  final String badge;
  final Color Function(BarterColors) badgeColor;
  final Color Function(BarterColors) badgeTextColor;
  final String igFollowers;
  final String tikTok;
  final String engagement;
  final String barterScore;
  final double imageRotation;
  final String imageUrl;
}

const _kProposals = [
  _ProposalData(
    name: 'Sienna Rivers',
    isVerified: true,
    badge: 'Pro Creator',
    badgeColor: _bcTertiaryContainer,
    badgeTextColor: _bcOnTertiaryContainer,
    igFollowers: '245K',
    tikTok: '1.2M',
    engagement: '8.4%',
    barterScore: '98',
    imageRotation: 6,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDY6m5l8N-SiaAtzA03YxeMfciCKeLWy31oNacGMdSk1Cl5YgZUSv8cMwrbsOocRctHGi1iusEa5Xy1CSzyzL96oUurmqw3r0Ae-Jxu5bE9pZO9is6VvLTlpHzrNPj0oP4WPcmAzn-jveJtB1Ij28zmgOcelU5u8nHziUMA6RhA7miEGuD_mO9N0m_3zllAp2fehA4bK5YmttG4dWQlMVzzqR91qSYWqOHOkQ17FOdO2d3xzwxbWTlARiWMUV7QCayHTLRT8mDLWEs',
  ),
  _ProposalData(
    name: 'Marcus Tech',
    isVerified: false,
    badge: 'New Application',
    badgeColor: _bcSurfaceContainerHigh,
    badgeTextColor: _bcSecondary,
    igFollowers: '12K',
    tikTok: '89K',
    engagement: '12.1%',
    barterScore: '82',
    imageRotation: -3,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCWpYgBrARt-KWyMxVQzX12IoEjDZBhMtl8-0oJrqbqI8UxchD7jj9Ey9YziiLJgpoBuYPdl_0RZ_mzV4Tfpi80gGnJb8yV9dEE37NCR3KomIGWgwG3bxeRD1Kovn_pNCv9z8UmuUqgo0P8syq1y_zKzgvv9PI6ae79SjR9esgOvT8GGNWz4mkaxB48_qFktdDoegyCB_r6hw2OVTktoBAtVxf1XdKg7hVxKoqYZJrbABjqrioC-A81YuOQgasJ3c4pw1bZfcOChEk',
  ),
];

Color _bcTertiaryContainer(BarterColors bc) => bc.tertiaryContainer;
Color _bcOnTertiaryContainer(BarterColors bc) => bc.onTertiaryContainer;
Color _bcSurfaceContainerHigh(BarterColors bc) => bc.surfaceContainerHigh;
Color _bcSecondary(BarterColors bc) => bc.secondary;

class CreatorInboxTabScreen extends StatelessWidget {
  const CreatorInboxTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: bc.background,
      body: CustomScrollView(
        slivers: [
          const _CreatorTabAppBar(),

          // Editorial Header
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.onBackground,
                        height: 1.1,
                      ),
                      children: [
                        const TextSpan(text: 'PROPOSAL '),
                        TextSpan(
                          text: 'INBOX',
                          style: TextStyle(color: bc.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Review incoming creator partnerships for your Fall campaign.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          // Lazy-loaded proposals and declined card
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 48),
              itemCount: _kProposals.length,
              itemBuilder: (context, i) {
                final p = _kProposals[i];
                return _buildProposalCard(context, bc, theme,
                  name: p.name,
                  isVerified: p.isVerified,
                  badge: p.badge,
                  badgeColor: p.badgeColor(bc),
                  badgeTextColor: p.badgeTextColor(bc),
                  igFollowers: p.igFollowers,
                  tikTok: p.tikTok,
                  engagement: p.engagement,
                  barterScore: p.barterScore,
                  imageRotation: p.imageRotation,
                  imageUrl: p.imageUrl,
                );
              },
            ),
          ),
          // Declined proposal card
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bc.surfaceContainer,
                      ),
                      child: ClipOval(
                        child: BarterNetworkImage(
                          url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDMD0K0D1JoWFINTBrYqJQdjiICmMxQW89gybIyKrB8HRpNkP4z0XXgdFQCCJov4Mr774_ENlJ361b6GOZVWFHwtfowExI0fOD4P3ybu1mojhWiNlPmZn8ppKzDiERPti1azVLeqzZUWwxrfoq3vdBRkuFw5e4R9s2rDYH5cw-WX5OPBXD-okUzZGHI4dOu-1UaVqMEmY9U86Mrme_vijrFuIgHU70oaJqreGfXWjzPlJzA3qRetWE2lWLv6xbbYg5pY8Cyx0I0lJI',
                          fit: BoxFit.cover,
                          memCacheWidth: 96,
                          memCacheHeight: 96,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Luna Gray',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: bc.onBackground,
                            ),
                          ),
                          Text(
                            'Declined 2h ago',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: bc.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.close, color: bc.outline),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildProposalCard(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String name,
    required bool isVerified,
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
    required String igFollowers,
    required String tikTok,
    required String engagement,
    required String barterScore,
    required double imageRotation,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: bc.onSurface.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator Image Breaking Boundary
          Align(
            alignment: Alignment.topRight,
            child: Transform.rotate(
              angle: imageRotation * 3.14159 / 180,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: bc.surfaceContainerLowest, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: bc.onSurface.withValues(alpha: 0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BarterNetworkImage(
                    url: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 400,
                    memCacheHeight: 400,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Creator Info
          Row(
            children: [
              Text(
                name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: bc.onBackground,
                ),
              ),
              if (isVerified) ...[
                const SizedBox(width: 8),
                Icon(Icons.verified, color: bc.tertiary, size: 20),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: theme.textTheme.labelSmall?.copyWith(
                color: badgeTextColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Stats Bento
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildStatBox(context, bc, theme, label: 'IG Followers', value: igFollowers),
              _buildStatBox(context, bc, theme, label: 'TikTok', value: tikTok),
              _buildStatBox(context, bc, theme, label: 'Engagement', value: engagement, isPrimary: true),
              _buildBarterScoreBox(context, bc, theme, value: barterScore),
            ],
          ),
          const SizedBox(height: 32),
          // Actions
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: () => context.push('/deal/sample/review'),
                icon: const Icon(Icons.handshake),
                label: Text(
                  'Accept Proposal',
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                  shadowColor: bc.primary.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/deal/sample/counter-offer'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: bc.surfaceContainerHigh,
                        foregroundColor: bc.onBackground,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        side: BorderSide.none,
                      ),
                      child: Text(
                        'Counter',
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Proposal declined')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: bc.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Decline',
                        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String label,
    required String value,
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: bc.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: isPrimary ? bc.primary : bc.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarterScoreBox(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bc.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Barter Score',
            style: theme.textTheme.labelSmall?.copyWith(
              color: bc.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: bc.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class CreatorProfileTabScreen extends StatelessWidget {
  const CreatorProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: bc.background,
      body: CustomScrollView(
        slivers: [
          const _CreatorTabAppBar(),

          // Hero Profile Section
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(child: _buildHeroSection(context, bc, theme)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          // KPI Bento Grid — lazy-loaded cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList.separated(
              itemCount: 3,
              itemBuilder: (context, index) {
                final kpis = [
                  (
                    icon: Icons.camera_alt_outlined,
                    platform: 'Instagram',
                    followers: '1.2M',
                    engagement: '4.8%',
                    reach: '850K',
                    engagementLabel: 'Engagement',
                    reachLabel: 'Avg. Reach',
                  ),
                  (
                    icon: Icons.bolt_outlined,
                    platform: 'TikTok',
                    followers: '2.5M',
                    engagement: '12.4%',
                    reach: '3.1M',
                    engagementLabel: 'Engagement',
                    reachLabel: 'Avg. Reach',
                  ),
                  (
                    icon: Icons.play_circle_outline,
                    platform: 'YouTube',
                    followers: '450K',
                    engagement: '9.1%',
                    reach: '125K',
                    engagementLabel: 'CTR',
                    reachLabel: 'Views/Vid',
                  ),
                ];
                final k = kpis[index];
                return _buildKPICard(
                  context, bc, theme,
                  icon: k.icon,
                  platform: k.platform,
                  followers: k.followers,
                  engagement: k.engagement,
                  reach: k.reach,
                  engagementLabel: k.engagementLabel,
                  reachLabel: k.reachLabel,
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 16),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          // Membership Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(child: _buildMembershipSection(context, bc, theme)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          // Deal History Section (already uses horizontal ListView.builder internally)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(child: _buildDealHistorySection(context, bc, theme)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, BarterColors bc, ThemeData theme) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: bc.surfaceContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: bc.onSurface.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: BarterNetworkImage(
                      url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCHeYJCGsJh92o1tQtWI4nkcknCt5-VYNTTfjhOi32iLHDj65Z3VQwMrAXLQb_Dv2RH9khpvUR5m4eFoaruWst4A0P6PA0duZ8Znm4Cz9CQOL9V_YKYDgRtk0KZfkGSWaWFOMUezlgxy39fyr0Guy8aYDyntSvxh9dkhu2nZJdiFFH8T-pRGId4xhJnWjKl8vdZ9p2VGxBzCR_YLeusHALMQqs8zzaoYkk_CSVJ7NdHDGdKTHU3enX8OwnNwM5gNvq1wcqkcJ9DXno',
                      fit: BoxFit.cover,
                      memCacheWidth: 240,
                      memCacheHeight: 240,
                    ),
                  ),
                ),
                // Verified Badge
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: bc.tertiaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: bc.onSurface.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, size: 14, color: bc.onTertiaryContainer),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: bc.onTertiaryContainer,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bc.onBackground,
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: bc.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Crafting high-end editorial content for brands that value authenticity and visual excellence. Specializing in lifestyle tech and sustainable fashion.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: bc.onSurfaceVariant,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.push('/creator/feed'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bc.primary,
                          foregroundColor: bc.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                          shadowColor: bc.primary.withValues(alpha: 0.2),
                        ),
                        child: Text(
                          'Request Barter',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          side: BorderSide.none,
                        ),
                        child: Text(
                          'Message',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Barter Score Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: bc.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: bc.onSurface.withValues(alpha: 0.06),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Barter Score',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: bc.secondary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '98',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Top 1% Creator',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: bc.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembershipSection(BuildContext context, BarterColors bc, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: bc.onSurface.withValues(alpha: 0.06),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bc.primaryFixed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.workspace_premium, color: bc.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Membership',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Free • 30 points earned',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'FREE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 8,
              backgroundColor: bc.surfaceContainerHigh,
              color: bc.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You're 20 pts away from 1 month Pro.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: bc.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/creator/membership/earn'),
              style: ElevatedButton.styleFrom(
                backgroundColor: bc.primary,
                foregroundColor: bc.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: const Text('Earn more months'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(
    BuildContext context,
    BarterColors bc,
    ThemeData theme, {
    required IconData icon,
    required String platform,
    required String followers,
    required String engagement,
    required String reach,
    required String engagementLabel,
    required String reachLabel,
  }) {
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
                style: theme.textTheme.labelSmall?.copyWith(
                  color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            followers,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Followers',
            style: theme.textTheme.bodyMedium?.copyWith(color: bc.secondary),
          ),
          const SizedBox(height: 16),
          Divider(color: bc.outlineVariant.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      engagement,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      engagementLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        letterSpacing: 0.5,
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
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: bc.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      reachLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        letterSpacing: 0.5,
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

  Widget _buildDealHistorySection(BuildContext context, BarterColors bc, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Deal History',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '142 Successful Exchanges',
              style: theme.textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              final deals = [
                {
                  'brand': 'LuxeTech',
                  'category': 'Tech & Gadgets',
                  'title': 'Quantum Series Launch Campaign',
                  'description': 'High-performance video series demonstrating daily integration of the Quantum 5 ecosystem.',
                  'rating': '5.0',
                  'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDyPYZKUfpQ9kvvPt1qcS0iOUEtQzFCxpUDp_Ouoj2xKx8dNsJoOwQJRIwv6GVuz-m4ghJZJq07hGxvAtWdiiOFxBiFv3gHjIeov8izvkxTTrP7Qa0A8VOIf4yBLiwRY71GuTRlOb8lv_TGG6J81grAkllxpV6pxkdnslSAOHFC5Ce6qIi4dKE72H-d1rtd1HPWUixHEbHXeE4-qzJLv5u7RGW_ZWUTe0B4zxSXags4RbELgcFfuDs9tsbsyiZZ8ws6FRZNUm9Xff8',
                },
                {
                  'brand': 'Aether',
                  'category': 'Fashion',
                  'title': 'Aesthetic Footwear Editorial',
                  'description': 'Creative lookbook and lifestyle shots for the Sustainable Step collection.',
                  'rating': '4.9',
                  'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBToh0F-MrjKT1r1O_lmTOA_0mHB6n_TJdJ3a9zRoaX7Yp9QuHOH-I2jl47IL3Q6Wjhb180wCBh159LeKM4eGsI4ALnpVXD44uLtt4ywDGSTh5L6IlRf1HKLY4-VLx2PCTYo0ORsMLeJLjtb5mmnVuPHfcEAWGeaV6xXXq4q-XrnBFTgEsBmmdcLDLCo1_JsFvlMx4-k0VdO9V3gGmDZdQ9T7NYowyDA1BJmuZ-vOscA2fVz6HTmHlgsUgabVRSV7aKRYuTxFJVk_0',
                },
                {
                  'brand': 'Nook',
                  'category': 'Home Decor',
                  'title': 'Minimalist Home Integration',
                  'description': 'Strategic placement of Nook essentials in a modern creator studio environment.',
                  'rating': '5.0',
                  'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuChF02KUs3rz3G7B1crSCnTKkjD7if1u5TpplyO6mG5VdpPMirzM4JVaabhCZ4sjKi0dekqMT_Qy6-tPXcUxq_Z-OzMe7kIXYGUjH2UyECvsdzvmgVz8UmW9-KY1_G4yoHbcdMUsW0_SOJBP2Fb7k1byV1DbkvEge3-3SbB5A9wihtgCFrTTA0oTMUQUbq9fMVg9VPVZ5l03Ap0q-60shQkkfG5BR_IDuMuh8oKPpnOzb22qav6F5Evr7eKbUKtm24Bsk2VU9DH8pg',
                },
              ];
              final deal = deals[index];
              
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          child: BarterNetworkImage(
                            url: deal['image'] as String,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            memCacheWidth: 640,
                            memCacheHeight: 320,
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: bc.background.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              deal['brand'] as String,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                deal['category'] as String,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: bc.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 16, color: bc.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    deal['rating'] as String,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            deal['title'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            deal['description'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
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
            },
          ),
        ),
      ],
    );
  }
}

class _CreatorTabAppBar extends StatelessWidget {
  const _CreatorTabAppBar();

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Container(
        color: bc.surface,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'BARTER',
              style: theme.textTheme.titleLarge?.copyWith(
                color: bc.primary,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: bc.onSurface),
              onPressed: () => GoRouter.of(context).push('/notifications/center'),
            ),
          ],
        ),
      ),
    );
  }
}
