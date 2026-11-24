import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/models/brand_dashboard_model.dart';
import '../../providers/api_providers.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_card.dart';
import '../../widgets/barter_network_image.dart';

class CreatorDiscoveryScreen extends ConsumerStatefulWidget {
  const CreatorDiscoveryScreen({super.key});

  @override
  ConsumerState<CreatorDiscoveryScreen> createState() => _CreatorDiscoveryScreenState();
}

class _CreatorDiscoveryScreenState extends ConsumerState<CreatorDiscoveryScreen> {
  String _searchQuery = '';
  String? _selectedNiche;
  String? _selectedPlatform;
  String? _selectedFollowerRange;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DiscoveryCreator> _filtered(List<DiscoveryCreator> all) {
    return all.where((c) {
      if (_searchQuery.isNotEmpty &&
          !c.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !c.niche.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !c.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()))) {
        return false;
      }
      if (_selectedNiche != null && c.niche != _selectedNiche) return false;
      if (_selectedPlatform != null && !c.platforms.contains(_selectedPlatform)) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final wide = context.isWide;
    final async = ref.watch(brandDiscoveryProvider);

    return Scaffold(
      backgroundColor: bc.background,
      body: async.when(
        loading: () => Center(child: CircularProgressIndicator(color: bc.primary)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          final filtered = _filtered(data.creators);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(wide ? 48 : 20, wide ? 40 : 24, wide ? 48 : 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Discover Creators',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Find and invite verified creators to your campaigns.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: bc.onSurfaceVariant)),
                      const SizedBox(height: 20),
                      // Search bar
                      Container(
                        decoration: BoxDecoration(
                          color: bc.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.2)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'Search by name, niche or tag…',
                            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: bc.onSurfaceVariant),
                            prefixIcon: Icon(Symbols.search, color: bc.onSurfaceVariant),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Symbols.close, color: bc.onSurfaceVariant, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Filter chips row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChipWidget(
                              label: _selectedNiche ?? 'Niche',
                              active: _selectedNiche != null,
                              bc: bc,
                              onTap: () => _showPickerSheet(
                                context: context,
                                title: 'Select Niche',
                                options: data.filters.niches,
                                selected: _selectedNiche,
                                onSelect: (v) => setState(() => _selectedNiche = v == _selectedNiche ? null : v),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _FilterChipWidget(
                              label: _selectedPlatform ?? 'Platform',
                              active: _selectedPlatform != null,
                              bc: bc,
                              onTap: () => _showPickerSheet(
                                context: context,
                                title: 'Select Platform',
                                options: data.filters.platforms,
                                selected: _selectedPlatform,
                                onSelect: (v) => setState(() => _selectedPlatform = v == _selectedPlatform ? null : v),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _FilterChipWidget(
                              label: _selectedFollowerRange ?? 'Followers',
                              active: _selectedFollowerRange != null,
                              bc: bc,
                              onTap: () => _showPickerSheet(
                                context: context,
                                title: 'Follower Range',
                                options: data.filters.followerRanges,
                                selected: _selectedFollowerRange,
                                onSelect: (v) => setState(() => _selectedFollowerRange = v == _selectedFollowerRange ? null : v),
                              ),
                            ),
                            if (_selectedNiche != null || _selectedPlatform != null || _selectedFollowerRange != null) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => setState(() {
                                  _selectedNiche = null;
                                  _selectedPlatform = null;
                                  _selectedFollowerRange = null;
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: bc.error.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Symbols.close, size: 14, color: bc.error),
                                      const SizedBox(width: 4),
                                      Text('Clear', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.error, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('${filtered.length} creators found',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: bc.onSurfaceVariant)),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(wide ? 48 : 20, 0, wide ? 48 : 20, 120),
                sliver: wide
                    ? SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _CreatorCard(creator: filtered[i], bc: bc),
                          childCount: filtered.length,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 230,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _CreatorCard(creator: filtered[i], bc: bc),
                          ),
                          childCount: filtered.length,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPickerSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelect,
  }) {
    final bc = context.barter;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((o) {
                  final active = o == selected;
                  return GestureDetector(
                    onTap: () {
                      onSelect(o);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? bc.primary : bc.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active ? bc.primary : bc.outlineVariant.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(o,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: active ? bc.onPrimary : bc.onSurface,
                                fontWeight: FontWeight.w600,
                              )),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChipWidget extends StatelessWidget {
  const _FilterChipWidget({required this.label, required this.active, required this.bc, required this.onTap});
  final String label;
  final bool active;
  final BarterColors bc;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? bc.primary.withValues(alpha: 0.1) : bc.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? bc.primary : bc.outlineVariant.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: active ? bc.primary : bc.onSurface,
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(width: 4),
            Icon(Symbols.expand_more, size: 14, color: active ? bc.primary : bc.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _CreatorCard extends ConsumerWidget {
  const _CreatorCard({required this.creator, required this.bc});
  final DiscoveryCreator creator;
  final BarterColors bc;

  String _formatFollowers(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return '$n';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BarterCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      onTap: () => context.push('/brand/discover/${creator.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(shape: BoxShape.circle, color: bc.surfaceContainer),
                child: ClipOval(
                  child: BarterNetworkImage(
                    url: creator.avatarUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 104,
                    memCacheHeight: 104,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(creator.name,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        if (creator.verified)
                          Icon(Symbols.verified, color: bc.primary, size: 16, fill: 1),
                      ],
                    ),
                    Text(creator.username,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: bc.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _StatPill(value: _formatFollowers(creator.totalFollowers), label: 'followers', bc: bc),
              const SizedBox(width: 8),
              _StatPill(value: '${creator.avgEngagementRate.toStringAsFixed(1)}%', label: 'eng.', bc: bc),
              const SizedBox(width: 8),
              _StatPill(value: '${creator.barterScore}', label: 'score', bc: bc, highlight: true),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ...creator.tags.take(2).map((t) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: bc.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(t,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.primary, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis),
                    ),
                  )),
              if (creator.tags.length > 2)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: bc.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('+${creator.tags.length - 2}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: bc.onSurfaceVariant, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final offers = await ref.read(offerRepositoryProvider).myOffers();
                      if (!context.mounted) return;
                      if (offers.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please create an offer before inviting creators.')),
                        );
                        return;
                      }
                      final selectedOffer = await showDialog<String>(
                        context: context,
                        builder: (ctx) => SimpleDialog(
                          title: Text('Invite ${creator.name} to Offer'),
                          children: offers.map((o) => SimpleDialogOption(
                            onPressed: () => Navigator.pop(ctx, o.id),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(o.title),
                            ),
                          )).toList(),
                        ),
                      );
                      if (selectedOffer != null && context.mounted) {
                        await ref.read(brandRepositoryProvider).inviteCreator(selectedOffer, creator.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Invitation sent to ${creator.name}!')),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to send invite: $e')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bc.primary,
                    foregroundColor: bc.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Invite'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => context.push('/brand/discover/${creator.id}'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: bc.outlineVariant),
                ),
                child: Icon(Symbols.open_in_new, size: 16, color: bc.onSurface),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.value, required this.label, required this.bc, this.highlight = false});
  final String value;
  final String label;
  final BarterColors bc;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: highlight ? bc.primary.withValues(alpha: 0.08) : bc.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: highlight ? bc.primary : bc.onSurface,
                  ),
            ),
            TextSpan(
              text: ' $label',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: bc.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
