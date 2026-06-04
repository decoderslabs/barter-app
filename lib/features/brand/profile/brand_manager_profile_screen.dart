import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/models/brand_profile_model.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../theme/responsive_extension.dart';
import '../../../widgets/barter_appbar.dart';
import '../../../widgets/barter_card.dart';
import '../../../widgets/barter_network_image.dart';

class BrandManagerProfileScreen extends ConsumerWidget {
  const BrandManagerProfileScreen({super.key, required this.managerId});

  final String managerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;
    final async = ref.watch(brandProfileProvider);

    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        leading: context.canPop() ? BarterBackButton(onPressed: () => context.pop()) : null,
        actions: [
          IconButton(
            icon: Icon(Symbols.notifications, color: bc.onBackground),
            onPressed: () => context.push('/notifications/center'),
          ),
        ],
      ),
      body: async.when(
        loading: () => Center(child: CircularProgressIndicator(color: bc.primary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (brand) {
          final manager = brand.team.where((m) => m.id == managerId).firstOrNull;
          if (manager == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Symbols.person_off, size: 64, color: bc.onSurfaceVariant.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  Text('Manager not found',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: bc.onSurfaceVariant)),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(wide ? 48 : 20, 0, wide ? 48 : 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ManagerHero(manager: manager, brand: brand, bc: bc, wide: wide),
                const SizedBox(height: 40),
                _KpiRow(manager: manager, bc: bc, wide: wide),
                const SizedBox(height: 40),
                _BioSection(manager: manager, bc: bc),
                const SizedBox(height: 40),
                _ContactSection(manager: manager, bc: bc),
                const SizedBox(height: 40),
                _SocialLinksSection(manager: manager, bc: bc),
                const SizedBox(height: 40),
                _BrandContextSection(brand: brand, bc: bc),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Hero ─────────────────────────────────────────────────────────────────────

class _ManagerHero extends StatelessWidget {
  const _ManagerHero({
    required this.manager,
    required this.brand,
    required this.bc,
    required this.wide,
  });
  final BrandManager manager;
  final BrandProfile brand;
  final BarterColors bc;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(manager: manager, bc: bc, size: 120),
          const SizedBox(width: 32),
          Expanded(child: _NameBlock(manager: manager, brand: brand, bc: bc)),
          _ContactButtons(manager: manager, bc: bc),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Avatar(manager: manager, bc: bc, size: 88),
            const SizedBox(width: 20),
            Expanded(child: _NameBlock(manager: manager, brand: brand, bc: bc)),
          ],
        ),
        const SizedBox(height: 20),
        _ContactButtons(manager: manager, bc: bc),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.manager, required this.bc, required this.size});
  final BrandManager manager;
  final BarterColors bc;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bc.surfaceContainer,
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.12),
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipOval(
        child: BarterNetworkImage(
          url: manager.avatarUrl,
          fit: BoxFit.cover,
          memCacheWidth: (size * 2).toInt(),
          memCacheHeight: (size * 2).toInt(),
        ),
      ),
    );
  }
}

class _NameBlock extends StatelessWidget {
  const _NameBlock({required this.manager, required this.brand, required this.bc});
  final BrandManager manager;
  final BrandProfile brand;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          manager.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          manager.role,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: bc.primary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        // Brand affiliation chip
        GestureDetector(
          onTap: () => context.push('/brand/profile'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: bc.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: bc.surfaceContainer,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: BarterNetworkImage(
                      url: brand.logoUrl,
                      fit: BoxFit.contain,
                      memCacheWidth: 36,
                      memCacheHeight: 36,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  brand.name,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                Icon(Symbols.open_in_new, size: 12, color: bc.onSurfaceVariant),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Symbols.schedule, size: 14, color: bc.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              'Joined ${_formatDate(manager.joinedDate)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(String iso) {
    final parts = iso.split('-');
    if (parts.length < 3) return iso;
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = int.tryParse(parts[1]) ?? 1;
    return '${months[month - 1]} ${parts[0]}';
  }
}

class _ContactButtons extends StatelessWidget {
  const _ContactButtons({required this.manager, required this.bc});
  final BrandManager manager;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: () => context.push('/notifications/center'),
          icon: const Icon(Symbols.chat_bubble, size: 18),
          label: const Text('Message'),
          style: ElevatedButton.styleFrom(
            backgroundColor: bc.primary,
            foregroundColor: bc.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(Symbols.call, size: 18, color: bc.onSurface),
          label: const Text('Call'),
          style: OutlinedButton.styleFrom(
            foregroundColor: bc.onSurface,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: bc.outlineVariant),
          ),
        ),
      ],
    );
  }
}

// ─── KPI Row ─────────────────────────────────────────────────────────────────

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.manager, required this.bc, required this.wide});
  final BrandManager manager;
  final BarterColors bc;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Symbols.handshake, '${manager.dealsManaged}', 'Deals Managed'),
      (Symbols.campaign, '${manager.activeCampaigns}', 'Active Campaigns'),
      (Symbols.timer, manager.responseTime, 'Avg Response Time'),
    ];

    return Row(
      children: items
          .map((item) => Expanded(
                child: _KpiCard(icon: item.$1, value: item.$2, label: item.$3, bc: bc),
              ))
          .expand((w) => [w, const SizedBox(width: 12)])
          .toList()
        ..removeLast(),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.icon, required this.value, required this.label, required this.bc});
  final IconData icon;
  final String value;
  final String label;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return BarterCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bc.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: bc.primary, size: 18),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: bc.onSurfaceVariant,
                    height: 1.3,
                  )),
        ],
      ),
    );
  }
}

// ─── Bio ─────────────────────────────────────────────────────────────────────

class _BioSection extends StatelessWidget {
  const _BioSection({required this.manager, required this.bc});
  final BrandManager manager;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        BarterCard(
          padding: const EdgeInsets.all(24),
          borderRadius: 20,
          child: Text(
            manager.bio,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ),
      ],
    );
  }
}

// ─── Contact ─────────────────────────────────────────────────────────────────

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.manager, required this.bc});
  final BrandManager manager;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        BarterCard(
          padding: const EdgeInsets.all(20),
          borderRadius: 20,
          child: Column(
            children: [
              _ContactRow(icon: Symbols.mail, label: 'Email', value: manager.email, bc: bc),
              Divider(height: 24, color: bc.outlineVariant.withValues(alpha: 0.15)),
              _ContactRow(icon: Symbols.phone, label: 'Phone', value: manager.phone, bc: bc),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.bc,
  });
  final IconData icon;
  final String label;
  final String value;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bc.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: bc.primary, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant)),
              Text(value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Icon(Symbols.chevron_right, color: bc.onSurfaceVariant.withValues(alpha: 0.4), size: 18),
      ],
    );
  }
}

// ─── Social Links ─────────────────────────────────────────────────────────────

class _SocialLinksSection extends StatelessWidget {
  const _SocialLinksSection({required this.manager, required this.bc});
  final BrandManager manager;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    if (manager.socialLinks.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Socials', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: manager.socialLinks.map((link) {
            final (icon, color) = _platformStyle(link.platform, bc);
            return OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(icon, size: 16, color: color),
              label: Text(link.platform),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  (IconData, Color) _platformStyle(String platform, BarterColors bc) {
    switch (platform.toLowerCase()) {
      case 'linkedin':
        return (Symbols.work, bc.primary);
      case 'instagram':
        return (Symbols.photo_camera, bc.tertiary);
      case 'twitter':
      case 'x':
        return (Symbols.alternate_email, bc.onSurface);
      default:
        return (Symbols.link, bc.onSurfaceVariant);
    }
  }
}

// ─── Brand Context ─────────────────────────────────────────────────────────────

class _BrandContextSection extends StatelessWidget {
  const _BrandContextSection({required this.brand, required this.bc});
  final BrandProfile brand;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Brand', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        BarterCard(
          padding: const EdgeInsets.all(20),
          borderRadius: 20,
          onTap: () => context.push('/brand/profile'),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: bc.surfaceContainer,
                  border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.15)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BarterNetworkImage(
                    url: brand.logoUrl,
                    fit: BoxFit.contain,
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
                    Row(
                      children: [
                        Text(brand.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        if (brand.verified) ...[
                          const SizedBox(width: 4),
                          Icon(Symbols.verified, color: bc.primary, size: 16, fill: 1),
                        ],
                      ],
                    ),
                    Text(brand.industry,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Symbols.chevron_right, color: bc.onSurfaceVariant.withValues(alpha: 0.45)),
            ],
          ),
        ),
      ],
    );
  }
}
