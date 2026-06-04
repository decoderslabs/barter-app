import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/dto/proposal_dto.dart';
import '../../providers/api_providers.dart';
import '../../providers/app_providers.dart';
import '../../theme/barter_colors.dart';
import '../../theme/responsive_extension.dart';
import '../../widgets/barter_card.dart';
import '../../widgets/barter_chips.dart';
import '../../widgets/barter_network_image.dart';

class ReviewProposalScreen extends ConsumerWidget {
  const ReviewProposalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bc = context.barter;
    final wide = context.isWide;
    final proposalsAsync = ref.watch(proposalsListProvider);

    return Scaffold(
      backgroundColor: bc.background,
      body: proposalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (List<ProposalListItemDto> proposals) {
          if (proposals.isEmpty) {
            return const Center(child: Text('No proposals yet'));
          }
          final items = proposals
              .map((p) => _ProposalCard(
                    proposalId: p.id,
                    creatorName: p.creatorUsername,
                    creatorHandle: '@${p.creatorUsername}',
                    campaign: p.offerTitle,
                    proposalTitle: p.offerTitle,
                    description: 'Status: ${p.status} · Round ${p.roundNumber}',
                    deliverables: const ['See proposal detail'],
                    estimatedValue: '—',
                    avatarUrl: '',
                    bc: bc,
                  ))
              .toList();

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              wide ? 48 : 20,
              wide ? 40 : 24,
              wide ? 48 : 20,
              48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review Proposal',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Review and respond to creator proposals.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bc.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),
                ...items,
              ],
            ),
          );
        },
      ),
    );
  }

}

class _ProposalCard extends ConsumerWidget {
  const _ProposalCard({
    required this.proposalId,
    required this.creatorName,
    required this.creatorHandle,
    required this.campaign,
    required this.proposalTitle,
    required this.description,
    required this.deliverables,
    required this.estimatedValue,
    required this.avatarUrl,
    required this.bc,
  });

  final String proposalId;
  final String creatorName;
  final String creatorHandle;
  final String campaign;
  final String proposalTitle;
  final String description;
  final List<String> deliverables;
  final String estimatedValue;
  final String avatarUrl;
  final BarterColors bc;

  Future<void> _accept(BuildContext context, WidgetRef ref) async {
    await ref.read(proposalRepositoryProvider).acceptProposal(proposalId);
    ref.invalidate(proposalsListProvider);
    if (context.mounted) context.pop();
  }

  Future<void> _decline(BuildContext context, WidgetRef ref) async {
    await ref.read(proposalRepositoryProvider).declineProposal(proposalId);
    ref.invalidate(proposalsListProvider);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BarterCard(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: bc.surfaceContainerHigh,
                child: avatarUrl.isEmpty
                    ? Text(creatorName.isNotEmpty ? creatorName[0] : '?')
                    : ClipOval(
                        child: BarterNetworkImage(url: avatarUrl, width: 48, height: 48),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(creatorName, style: Theme.of(context).textTheme.titleMedium),
                    Text(creatorHandle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(campaign, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(proposalTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: deliverables
                .map((d) => BarterChip(label: d, variant: BarterChipVariant.mini))
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _decline(context, ref),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _accept(context, ref),
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}
