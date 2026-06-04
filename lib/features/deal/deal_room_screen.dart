import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../data/models/deal_room_model.dart';
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
        error: (e, _) => Center(child: Text('$e')),
        data: (DealRoomModel deal) => _DealRoomBody(deal: deal),
      ),
    );
  }
}

class _DealRoomBody extends StatelessWidget {
  const _DealRoomBody({required this.deal});

  final DealRoomModel deal;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
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
                ...deal.messages.map((m) => _MessageBubble(message: m)),
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
        _ComposerBar(bc: bc),
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
  const _MessageBubble({required this.message});

  final DealMessageModel message;

  @override
  Widget build(BuildContext context) {
    final bc = context.barter;
    final fromBrand = message.from == 'brand';
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

class _ComposerBar extends StatelessWidget {
  const _ComposerBar({required this.bc});

  final BarterColors bc;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
                onPressed: () => context.push('/deal/review'),
                icon: const Icon(Symbols.send),
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
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: bc.surfaceContainerHigh,
                    child: Icon(Symbols.mic, color: bc.primary),
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
