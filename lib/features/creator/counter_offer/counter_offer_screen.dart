import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/routing/deal_route.dart';
import '../../../data/dto/proposal_dto.dart';
import '../../../providers/api_providers.dart';
import '../../../providers/app_providers.dart';
import '../../../theme/barter_colors.dart';
import '../../../widgets/barter_appbar.dart';

class CounterOfferScreen extends ConsumerStatefulWidget {
  const CounterOfferScreen({super.key});

  @override
  ConsumerState<CounterOfferScreen> createState() => _CounterOfferScreenState();
}

class _CounterOfferScreenState extends ConsumerState<CounterOfferScreen> {
  List<DeliverableItem> _deliverables = [
    DeliverableItem(icon: Symbols.video_library, value: '2x TikTok Reels (15-30s)', type: 'Video Content'),
    DeliverableItem(icon: Symbols.photo_camera, value: '3x Instagram Story Frames', type: 'Image / Series'),
  ];
  bool _submitting = false;

  Future<void> _submit(String note) async {
    final proposalId = dealIdFromRoute(context);
    if (proposalId == null) return;
    setState(() => _submitting = true);
    try {
      final deliverablesList = _deliverables.map((d) => d.value).toList();
      await ref.read(proposalRepositoryProvider).counterProposal(
        proposalId: proposalId,
        deliverables: {'items': deliverablesList},
        timelineIsoDate: DateTime.now().add(const Duration(days: 14)).toIso8601String(),
        note: note.isNotEmpty ? note : null,
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final proposalId = dealIdFromRoute(context);
    final proposalAsync = proposalId != null
        ? ref.watch(proposalDetailProvider(proposalId))
        : null;

    return proposalAsync == null
        ? Scaffold(backgroundColor: bc.background, body: const Center(child: CircularProgressIndicator()))
        : proposalAsync.when(
            loading: () => Scaffold(backgroundColor: bc.background, body: const Center(child: CircularProgressIndicator())),
            error: (e, _) => Scaffold(backgroundColor: bc.background, body: Center(child: Text('$e'))),
            data: (proposal) => _buildBody(context, bc, proposal),
          );
  }

  Widget _buildBody(BuildContext context, bc, ProposalDetailDto proposal) {
    return Scaffold(
      backgroundColor: bc.background,
      appBar: BarterAppBar(
        leading: const BarterBackButton(),
        actions: [
          IconButton(
            icon: Icon(Symbols.help_outline, color: bc.onBackground.withValues(alpha: 0.6)),
            onPressed: () => context.push('/help'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderSection(bc: bc, proposal: proposal),
            const SizedBox(height: 40),
            _DeliverablesSection(
              deliverables: _deliverables,
              onAdd: () {},
              onRemove: (index) {
                setState(() {
                  if (_deliverables.length > 1) {
                    _deliverables.removeAt(index);
                  }
                });
              },
              onUpdate: (value) {
                setState(() {
                  final index = _deliverables.indexWhere((item) => item.value == _deliverables[_deliverables.indexOf(item)].value);
                  if (index >= 0 && index < _deliverables.length) {
                    _deliverables[index] = _deliverables[index].copyWith(value: value);
                  }
                });
              },
              bc: bc,
            ),
            const SizedBox(height: 32),
            _TimelineBudgetGrid(bc: bc),
            const SizedBox(height: 32),
            _NoteSection(bc: bc),
            const SizedBox(height: 140),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              bc.background,
              bc.background.withValues(alpha: 0.95),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _submitting ? null : () => _submit(''),
              style: ElevatedButton.styleFrom(
                backgroundColor: bc.primary,
                foregroundColor: bc.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                elevation: 12,
                shadowColor: bc.primary.withValues(alpha: 0.2),
              ),
              child: Text(
                'Send Counter-Offer',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'Cancel Negotiation',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.bc, required this.proposal});

  final BarterColors bc;
  final ProposalDetailDto proposal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: bc.tertiaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Round ${proposal.roundNumber}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.onTertiaryContainer,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontSize: 10,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
                '• ${proposal.offerTitle.isNotEmpty ? proposal.offerTitle : "Negotiating"}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: bc.onSurfaceVariant.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1,
                  letterSpacing: -2,
                ),
            children: [
              const TextSpan(text: 'Refine the '),
              TextSpan(
                text: 'Terms',
                style: TextStyle(color: bc.primary, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Adjust deliverables and timelines to better align with your campaign goals.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: bc.onSurfaceVariant,
                height: 1.6,
              ),
        ),
      ],
    );
  }
}

class _DeliverablesSection extends StatelessWidget {
  const _DeliverablesSection({
    required this.deliverables,
    required this.onAdd,
    required this.onRemove,
    required this.onUpdate,
    required this.bc,
  });

  final List<DeliverableItem> deliverables;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final ValueChanged<String> onUpdate;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Deliverables',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                'Editable',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: bc.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 10,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...deliverables.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _DeliverableItemCard(
                item: item,
                onRemove: () => onRemove(index),
                onUpdate: (value) => onUpdate(value),
                bc: bc,
              ),
            );
          }),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: Icon(Symbols.add, size: 16),
            label: Text(
              'Add Deliverable',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: bc.onSurfaceVariant.withValues(alpha: 0.6),
              side: BorderSide(
                color: bc.outlineVariant.withValues(alpha: 0.3),
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliverableItemCard extends StatefulWidget {
  const _DeliverableItemCard({
    required this.item,
    required this.onRemove,
    required this.onUpdate,
    required this.bc,
  });

  final DeliverableItem item;
  final VoidCallback onRemove;
  final ValueChanged<String> onUpdate;
  final BarterColors bc;

  @override
  State<_DeliverableItemCard> createState() => _DeliverableItemCardState();
}

class _DeliverableItemCardState extends State<_DeliverableItemCard> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.item.value);
  }

  @override
  void didUpdateWidget(_DeliverableItemCard old) {
    super.didUpdateWidget(old);
    if (old.item.value != widget.item.value) {
      _ctrl.text = widget.item.value;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bc = widget.bc;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bc.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.item.icon, color: bc.primary, size: 20, fill: 1),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _ctrl,
                  onChanged: widget.onUpdate,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.item.type,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant.withValues(alpha: 0.7),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Symbols.close, color: bc.onSurfaceVariant.withValues(alpha: 0.4)),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }
}

class _TimelineBudgetGrid extends StatefulWidget {
  const _TimelineBudgetGrid({required this.bc});

  final BarterColors bc;

  @override
  State<_TimelineBudgetGrid> createState() => _TimelineBudgetGridState();
}

class _TimelineBudgetGridState extends State<_TimelineBudgetGrid> {
  late final TextEditingController _timelineCtrl;
  late final TextEditingController _valueCtrl;

  @override
  void initState() {
    super.initState();
    _timelineCtrl = TextEditingController(text: '14 Days');
    _valueCtrl = TextEditingController(text: '1,200');
  }

  @override
  void dispose() {
    _timelineCtrl.dispose();
    _valueCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bc = widget.bc;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bc.surfaceContainerLow,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Symbols.event, color: bc.primary),
                const SizedBox(height: 8),
                Text(
                  'Timeline',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _timelineCtrl,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bc.surfaceContainerLow,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Symbols.payments, color: bc.primary),
                const SizedBox(height: 8),
                Text(
                  'Offer Value',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bc.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _valueCtrl,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NoteSection extends StatelessWidget {
  const _NoteSection({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add a Note',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: bc.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 12),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Explain your reasoning or specific requirements...',
            hintStyle: TextStyle(color: bc.onSurfaceVariant.withValues(alpha: 0.4)),
            border: InputBorder.none,
            filled: true,
            fillColor: bc.surfaceContainerLow,
            contentPadding: const EdgeInsets.all(20),
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class DeliverableItem {
  final IconData icon;
  final String value;
  final String type;

  DeliverableItem({
    required this.icon,
    required this.value,
    required this.type,
  });

  DeliverableItem copyWith({
    IconData? icon,
    String? value,
    String? type,
  }) {
    return DeliverableItem(
      icon: icon ?? this.icon,
      value: value ?? this.value,
      type: type ?? this.type,
    );
  }
}
