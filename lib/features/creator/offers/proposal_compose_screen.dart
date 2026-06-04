import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../data/models/offer_model.dart';
import '../../../providers/api_providers.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';

class ProposalComposeScreen extends ConsumerStatefulWidget {
  const ProposalComposeScreen({super.key, required this.offerId});

  final String offerId;

  @override
  ConsumerState<ProposalComposeScreen> createState() => _ProposalComposeScreenState();
}

class _ProposalComposeScreenState extends ConsumerState<ProposalComposeScreen> {
  final _pitch = TextEditingController(
    text: "Hi Team! I've been following your brand for months. My audience loves skincare routines that prioritize glow. I'd love to showcase how the new product integrates into a 5-step morning ritual.",
  );
  DateTime _deliveryDate = DateTime(2024, 11, 24);
  final _selectedPlatforms = <String>{'Instagram'};
  bool _kpiToggle = true;

  @override
  void dispose() {
    _pitch.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final bc = context.barter;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: bc.primary,
                  onPrimary: bc.onPrimary,
                  surface: bc.surface,
                  onSurface: bc.onSurface,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _deliveryDate = picked);
    }
  }

  Future<void> _sendProposal(BuildContext context) async {
    final repo = ref.read(proposalRepositoryProvider);
    final timeline =
        '${_deliveryDate.year}-${_deliveryDate.month.toString().padLeft(2, '0')}-${_deliveryDate.day.toString().padLeft(2, '0')}';
    await repo.createProposal(
      offerId: widget.offerId,
      pitch: _pitch.text.trim(),
      deliverables: {
        'types': ['reel', 'story'],
        'platforms': _selectedPlatforms.map((p) => p.toLowerCase()).toList(),
        'count': 1,
      },
      timelineIsoDate: timeline,
    );
    if (!context.mounted) return;
    context.go('/creator/offers/${widget.offerId}/proposal/sent');
  }

  String get _dateLabel {
    final d = _deliveryDate;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final offersAsync = ref.watch(offersProvider);

    return Scaffold(
      backgroundColor: bc.surface,
      appBar: BarterAppBar(
        backgroundColor: bc.surface,
        leading: const BarterCloseButton(),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: BarterProfileAvatar(
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAjB0C_nRcSK0klSxpVbLngOYwbrjG7AGffeeWYGXxpO815hauOIGmcOOaPGQZPS1t0xNnQDOqXU3OB-3DDZTUYbuNk_DNpL8hhi1crWdnND_n4xiigPDyu3rUROBJ0MUwX4rezBJEvO1gUnoYBM9w3as--mapW0qSdqkod-1f7kiGTEU6dFn6RpP9ATbBUL8qg6t-8qR7STx-XhQzFf1DDvAlc6XbV_sIhKJ_sPWdLMhNxVtJTySMWV_BwyRyEyuckSRPfOZYi1fM',
            ),
          ),
        ],
      ),
      body: offersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (OffersPayload payload) {
          OfferModel? offer;
          for (final o in payload.offers) {
            if (o.id == widget.offerId) offer = o;
          }
          offer ??= payload.offers.isNotEmpty ? payload.offers.first : null;
          final offerName = offer?.title ?? 'Luxe Skincare Rebrand';

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: bc.tertiaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'NEW PROPOSAL',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onTertiaryContainer,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              fontSize: 10,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: bc.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        offer?.brandName ?? 'Glow Lab',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: bc.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -2,
                          height: 1,
                        ),
                    children: [
                      const TextSpan(text: 'Draft '),
                      TextSpan(text: 'Pitch', style: TextStyle(color: bc.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: bc.onSurfaceVariant.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                    children: [
                      const TextSpan(text: 'Applying to: '),
                      TextSpan(
                        text: offerName,
                        style: TextStyle(
                          color: bc.onSurface,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // 01. The Pitch
                _NumberedSectionLabel(number: '01', label: 'The Pitch', bc: bc),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    TextField(
                      controller: _pitch,
                      maxLines: 6,
                      maxLength: 500,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText:
                            'Tell the brand why your aesthetic is the perfect fit for this exchange...',
                        hintStyle: TextStyle(color: bc.outline.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: bc.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: bc.primary.withValues(alpha: 0.2), width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: bc.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Editable',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                                fontSize: 10,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_pitch.text.length}/500',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: bc.outline,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                  ),
                ),
                const SizedBox(height: 40),
                // 02. Deliverables
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: bc.surfaceContainerLow.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NumberedSectionLabel(number: '02', label: 'Deliverables', bc: bc),
                      const SizedBox(height: 24),
                      _DeliverableTile(
                        title: '2x Instagram Reels',
                        subtitle: 'Product Showcase',
                        bc: bc,
                      ),
                      const SizedBox(height: 12),
                      _DeliverableTile(
                        title: '3x High-Res Still Shots',
                        subtitle: 'Lifestyle Photography',
                        bc: bc,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Add deliverable coming soon')),
                          );
                        },
                        icon: Icon(Symbols.add_circle, color: bc.outline),
                        label: Text(
                          'Add Custom Deliverable',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: bc.outline,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          side: BorderSide(
                            color: bc.outlineVariant.withValues(alpha: 0.3),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // KPI Highlight Card
                _KPIHighlightCard(
                  bc: bc,
                  toggled: _kpiToggle,
                  onToggle: (v) => setState(() => _kpiToggle = v),
                ),
                const SizedBox(height: 40),
                // 03. Timeline
                _NumberedSectionLabel(number: '03', label: 'Timeline', bc: bc),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _pickDate(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Symbols.calendar_today, color: bc.primary, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          _dateLabel,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer(),
                        Icon(Symbols.arrow_forward_ios, color: bc.outline, size: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // 04. Platform
                _NumberedSectionLabel(number: '04', label: 'Platform', bc: bc),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _PlatformChip(
                        label: 'Instagram',
                        icon: Symbols.photo_camera,
                        selected: _selectedPlatforms.contains('Instagram'),
                        onTap: () => _togglePlatform('Instagram'),
                        bc: bc,
                      ),
                      const SizedBox(width: 12),
                      _PlatformChip(
                        label: 'TikTok',
                        icon: Symbols.videocam,
                        selected: _selectedPlatforms.contains('TikTok'),
                        onTap: () => _togglePlatform('TikTok'),
                        bc: bc,
                      ),
                      const SizedBox(width: 12),
                      _PlatformChip(
                        label: 'YouTube',
                        icon: Symbols.play_circle,
                        selected: _selectedPlatforms.contains('YouTube'),
                        onTap: () => _togglePlatform('YouTube'),
                        bc: bc,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 56),
                OutlinedButton.icon(
                  onPressed: () => context.push('/creator/proposal/sample/preview'),
                  icon: Icon(Symbols.visibility, color: bc.onSurface, size: 20),
                  label: const Text('Preview Proposal'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: bc.surfaceContainerHigh,
                    foregroundColor: bc.onSurface,
                    side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _sendProposal(context),
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Symbols.send, color: bc.onPrimary, fill: 1),
                  label: const Text('Send Proposal'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(64),
                    backgroundColor: bc.primary,
                    foregroundColor: bc.onPrimary,
                    elevation: 0,
                    shadowColor: bc.primary.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _togglePlatform(String platform) {
    setState(() {
      if (_selectedPlatforms.contains(platform)) {
        if (_selectedPlatforms.length > 1) {
          _selectedPlatforms.remove(platform);
        }
      } else {
        _selectedPlatforms.add(platform);
      }
    });
  }
}

class _NumberedSectionLabel extends StatelessWidget {
  const _NumberedSectionLabel({
    required this.number,
    required this.label,
    required this.bc,
  });

  final String number;
  final String label;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bc.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            number,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: bc.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}

class _DeliverableTile extends StatelessWidget {
  const _DeliverableTile({
    required this.title,
    required this.subtitle,
    required this.bc,
  });

  final String title;
  final String subtitle;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Symbols.check_circle, color: bc.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  subtitle.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.outline,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Deliverable removed')),
              );
            },
            icon: Icon(Symbols.delete, color: bc.outline),
          ),
        ],
      ),
    );
  }
}

class _KPIHighlightCard extends StatelessWidget {
  const _KPIHighlightCard({
    required this.bc,
    required this.toggled,
    required this.onToggle,
  });

  final BarterColors bc;
  final bool toggled;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bc.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bc.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Symbols.trending_up, color: bc.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Engagement Rate Projection',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Switch(
                value: toggled,
                onChanged: onToggle,
                activeThumbColor: bc.primary,
                activeTrackColor: bc.primary.withValues(alpha: 0.3),
                inactiveTrackColor: bc.outlineVariant,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            toggled
                ? 'Based on your historical performance, this campaign is projected to hit an 8.4% engagement rate on Instagram Reels.'
                : 'Toggle on to see projected engagement metrics for this proposal.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: bc.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
          if (toggled) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                _KPIStat(label: 'Est. Reach', value: '42K', bc: bc),
                const SizedBox(width: 16),
                _KPIStat(label: 'Est. Saves', value: '1.2K', bc: bc),
                const SizedBox(width: 16),
                _KPIStat(label: 'Match', value: '94%', bc: bc),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _KPIStat extends StatelessWidget {
  const _KPIStat({
    required this.label,
    required this.value,
    required this.bc,
  });

  final String label;
  final String value;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: bc.outline,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                fontSize: 9,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: bc.primary,
                fontWeight: FontWeight.w900,
              ),
        ),
      ],
    );
  }
}

class _PlatformChip extends StatelessWidget {
  const _PlatformChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.bc,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? bc.primary.withValues(alpha: 0.1) : bc.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? bc.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? bc.primary : bc.onSurfaceVariant, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? bc.primary : bc.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
