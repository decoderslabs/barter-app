import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/models/deal_room_model.dart';
import '../../providers/api_providers.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../widgets/barter_appbar.dart';
import '../../widgets/barter_chips.dart';
import '../../widgets/barter_network_image.dart';

class DealRoomScreen extends ConsumerWidget {
  const DealRoomScreen({super.key, this.dealId});

  final String? dealId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final dealAsync = ref.watch(dealRoomProvider(dealId));
    return Scaffold(
      backgroundColor: bc.background,
      body: dealAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _DealErrorView(error: e.toString(), bc: bc),
        data: (DealRoomModel deal) => _DealRoomBody(
          deal: deal,
          dealId: dealId ?? deal.dealId,
        ),
      ),
    );
  }
}

class _DealRoomBody extends ConsumerStatefulWidget {
  const _DealRoomBody({required this.deal, required this.dealId});

  final DealRoomModel deal;
  final String dealId;

  @override
  ConsumerState<_DealRoomBody> createState() => _DealRoomBodyState();
}

class _DealRoomBodyState extends ConsumerState<_DealRoomBody> {
  Timer? _pollTimer;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      ref.invalidate(dealRoomProvider(widget.dealId));
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final deal = widget.deal;
    final currentUserId = ref.watch(authProvider).user?.id ?? '';
    final isBrand = ref.watch(authProvider).role == AppRole.brand;

    return Column(
      children: [
        Material(
          color: bc.background,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  const BarterBackButton(),
                  ClipOval(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: BarterNetworkImage(url: deal.brandLogoUrl),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deal.brandName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            Icon(Symbols.verified,
                                size: 14, color: bc.primary, fill: 1),
                            const SizedBox(width: 4),
                            Text(
                              'OFFICIAL BRAND',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontSize: 10,
                                    color: bc.primary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Symbols.info, color: bc.onSurface),
                  Icon(Symbols.more_vert, color: bc.onSurface),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                BarterEditorialTermsCard(deal: deal),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: bc.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      deal.agreementDateLabel.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 10,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ...deal.messages.map(
                  (m) => _MessageBubble(
                    message: m,
                    isMe: m.senderId == currentUserId,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: bc.surfaceContainerLow, height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _Milestones(deal: deal)),
                    const SizedBox(width: 12),
                    Expanded(child: _Countdown(days: deal.daysRemaining)),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isBrand && deal.status == 'delivered')
          _BrandActionBar(
            bc: bc,
            dealId: widget.dealId,
            onDone: () => ref.invalidate(dealRoomProvider(widget.dealId)),
          )
        else
          _ComposerBar(
            bc: bc,
            dealId: widget.dealId,
            dealStatus: deal.status,
            onSent: () {
              ref.invalidate(dealRoomProvider(widget.dealId));
              _scrollToBottom();
            },
          ),
      ],
    );
  }
}

class BarterEditorialTermsCard extends StatelessWidget {
  const BarterEditorialTermsCard({super.key, required this.deal});

  final DealRoomModel deal;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bc.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Symbols.handshake, color: bc.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AGREED TERMS',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 10,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deal.termsSummary,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              BarterChip(
                icon: Symbols.check_circle,
                label: 'Contract Signed',
                variant: BarterChipVariant.status,
                bgColor: bc.tertiaryContainer,
                fgColor: bc.onTertiaryContainer,
              ),
              BarterChip(
                icon: Symbols.schedule,
                label: 'Due in ${deal.daysRemaining} days',
                variant: BarterChipVariant.status,
                bgColor: bc.surfaceContainerHigh,
                fgColor: bc.onSurface,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});

  final DealMessageModel message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final fromBrand = !isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            fromBrand ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (fromBrand) ...[
            ClipOval(
              child: SizedBox(
                width: 32,
                height: 32,
                child: BarterNetworkImage(url: message.avatarUrl),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: fromBrand ? bc.surfaceContainerLowest : bc.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(fromBrand ? 0 : 16),
                  bottomRight: Radius.circular(fromBrand ? 16 : 0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: bc.onBackground.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      message.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: fromBrand ? bc.onSurface : bc.onPrimary,
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message.time,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 9,
                          color: fromBrand
                              ? bc.onSurfaceVariant.withValues(alpha: 0.55)
                              : bc.onPrimary.withValues(alpha: 0.55),
                        ),
                  ),
                ],
              ),
            ),
          ),
          if (!fromBrand) ...[
            const SizedBox(width: 10),
            ClipOval(
              child: SizedBox(
                width: 32,
                height: 32,
                child: BarterNetworkImage(url: message.avatarUrl),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Milestones extends StatelessWidget {
  const _Milestones({required this.deal});

  final DealRoomModel deal;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bc.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MILESTONES',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: bc.primary,
                  fontSize: 10,
                ),
          ),
          const SizedBox(height: 12),
          ...deal.milestones.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    m.done ? Symbols.radio_button_checked : Symbols.radio_button_unchecked,
                    color: m.done ? bc.primary : bc.onSurfaceVariant.withValues(alpha: 0.3),
                    fill: m.done ? 1.0 : 0.0,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      m.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: m.done ? bc.onSurface : bc.onSurfaceVariant,
                          ),
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

class _Countdown extends StatelessWidget {
  const _Countdown({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bc.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bc.onBackground.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$days',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                TextSpan(
                  text: 'd',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: bc.primary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'REMAINING TO DELIVER',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 10,
                  color: bc.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _ComposerBar extends ConsumerStatefulWidget {
  const _ComposerBar({
    required this.bc,
    required this.dealId,
    required this.dealStatus,
    required this.onSent,
  });

  final BarterColors bc;
  final String dealId;
  final String dealStatus;
  final VoidCallback onSent;

  @override
  ConsumerState<_ComposerBar> createState() => _ComposerBarState();
}

class _ComposerBarState extends ConsumerState<_ComposerBar> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final repo = ref.read(dealRepositoryProvider);
      await repo.sendMessage(widget.dealId, text);
      _controller.clear();
      widget.onSent();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _showDeliverySheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeliverySheet(
        bc: widget.bc,
        dealId: widget.dealId,
        onDelivered: widget.onSent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bc = widget.bc;
    final canDeliver = widget.dealStatus == 'active';
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (canDeliver) ...
              [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: bc.primary.withValues(alpha: 0.25),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: bc.primary,
                      foregroundColor: bc.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: _showDeliverySheet,
                    icon: const Icon(Symbols.upload),
                    label: Text(
                      'SUBMIT DELIVERY',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: bc.onPrimary,
                            letterSpacing: 2,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              decoration: BoxDecoration(
                color: bc.surfaceContainerLowest.withValues(alpha: 0.85),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.1)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: bc.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onChanged: (_) => setState(() {}),
                              onSubmitted: (_) => _send(),
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: bc.onSurfaceVariant.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ),
                          Icon(Symbols.attach_file, color: bc.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sending ? null : _send,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: _controller.text.trim().isNotEmpty
                          ? bc.primary
                          : bc.surfaceContainerHigh,
                      child: _sending
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: bc.onPrimary,
                              ),
                            )
                          : Icon(
                              Symbols.send,
                              color: _controller.text.trim().isNotEmpty
                                  ? bc.onPrimary
                                  : bc.primary,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliverySheet extends ConsumerStatefulWidget {
  const _DeliverySheet({
    required this.bc,
    required this.dealId,
    required this.onDelivered,
  });

  final BarterColors bc;
  final String dealId;
  final VoidCallback onDelivered;

  @override
  ConsumerState<_DeliverySheet> createState() => _DeliverySheetState();
}

class _DeliverySheetState extends ConsumerState<_DeliverySheet> {
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();
  bool _submitting = false;

  bool get _validUrl {
    final v = _urlController.text.trim();
    final re = RegExp(
      r'^https?:\/\/(www\.)?(instagram\.com|tiktok\.com)\/.+',
      caseSensitive: false,
    );
    return re.hasMatch(v);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_validUrl || _submitting) return;
    setState(() => _submitting = true);
    try {
      final repo = ref.read(dealRepositoryProvider);
      await repo.deliverContent(
        dealId: widget.dealId,
        files: [],
        postUrls: [_urlController.text.trim()],
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );
      widget.onDelivered();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delivery failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bc = widget.bc;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Symbols.upload, color: bc.primary),
                const SizedBox(width: 10),
                Text(
                  'Submit Delivery',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Post URL (Instagram or TikTok)',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _urlController,
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.url,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'https://www.instagram.com/reel/...',
                prefixIcon: Icon(Symbols.link, color: bc.primary),
                filled: true,
                fillColor: bc.surfaceContainerLow,
                errorText: _urlController.text.isNotEmpty && !_validUrl
                    ? 'Must be an Instagram or TikTok post URL'
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Notes (optional)',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Any context for the brand...',
                filled: true,
                fillColor: bc.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validUrl && !_submitting ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Confirm Delivery'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandActionBar extends ConsumerStatefulWidget {
  const _BrandActionBar({
    required this.bc,
    required this.dealId,
    required this.onDone,
  });

  final BarterColors bc;
  final String dealId;
  final VoidCallback onDone;

  @override
  ConsumerState<_BrandActionBar> createState() => _BrandActionBarState();
}

class _BrandActionBarState extends ConsumerState<_BrandActionBar> {
  bool _loading = false;

  Future<void> _approve() async {
    setState(() => _loading = true);
    try {
      await ref.read(dealRepositoryProvider).approveDelivery(widget.dealId);
      widget.onDone();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _requestRevision() async {
    final reason = await _reasonDialog();
    if (reason == null) return;
    setState(() => _loading = true);
    try {
      await ref
          .read(dealRepositoryProvider)
          .requestRevision(widget.dealId, reason);
      widget.onDone();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<String?> _reasonDialog() {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request Revision'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Describe what needs changing...'),
          minLines: 3,
          maxLines: 6,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bc = widget.bc;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: bc.surfaceContainerLowest,
          border: Border(
            top: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.15)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _loading ? null : _requestRevision,
                icon: Icon(Symbols.refresh, color: bc.onSurface),
                label: const Text('Request Revision'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: bc.onSurface,
                  side: BorderSide(color: bc.outlineVariant.withValues(alpha: 0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _loading ? null : _approve,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(Symbols.check_circle, color: bc.onPrimary),
                label: const Text('Approve'),
                style: FilledButton.styleFrom(
                  backgroundColor: bc.primary,
                  foregroundColor: bc.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DealErrorView extends StatelessWidget {
  const _DealErrorView({required this.error, required this.bc});

  final String error;
  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    final isNotFound = error.contains('404') || error.contains('not found');
    return Scaffold(
      backgroundColor: bc.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BarterBackButton(),
              const SizedBox(height: 48),
              Icon(
                isNotFound ? Symbols.error_outline : Symbols.error,
                size: 64,
                color: bc.primary,
              ),
              const SizedBox(height: 24),
              Text(
                isNotFound ? 'Deal not found' : 'Error loading deal',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                isNotFound
                    ? 'This deal may have been removed or you don\'t have access to it.'
                    : error,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: bc.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/creator/deals'),
                icon: Icon(Symbols.arrow_back, color: bc.onPrimary),
                label: Text(
                  'Back to Deals',
                  style: TextStyle(color: bc.onPrimary),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bc.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
