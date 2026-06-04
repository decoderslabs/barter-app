import '../dto/deal_dto.dart';
import '../dto/proposal_dto.dart';
import '../models/pipeline_model.dart';

class PipelineMapper {
  static PipelinePayload fromProposalsAndDeals(
    List<ProposalListItemDto> proposals,
    List<DealListItemDto> deals,
  ) {
    final columns = <PipelineColumnModel>[
      const PipelineColumnModel(
        id: 'new',
        title: 'New',
        accentHex: '#C4A574',
        cards: [],
      ),
      const PipelineColumnModel(
        id: 'review',
        title: 'In Review',
        accentHex: '#8B7355',
        cards: [],
      ),
      const PipelineColumnModel(
        id: 'active',
        title: 'In Progress',
        accentHex: '#5C4D3C',
        cards: [],
      ),
      const PipelineColumnModel(
        id: 'done',
        title: 'Complete',
        accentHex: '#3D3228',
        cards: [],
      ),
    ];

    final newCards = <PipelineCardModel>[];
    final reviewCards = <PipelineCardModel>[];
    final activeCards = <PipelineCardModel>[];
    final doneCards = <PipelineCardModel>[];

    for (final p in proposals) {
      final card = PipelineCardModel(
        creatorName: p.creatorUsername,
        offerTitle: p.offerTitle,
        tags: [p.status, 'Round ${p.roundNumber}'],
        brandInitial: p.offerBrandUsername.isNotEmpty
            ? p.offerBrandUsername[0].toUpperCase()
            : 'B',
      );
      switch (p.status) {
        case 'pending':
          newCards.add(card);
          break;
        case 'countered':
          reviewCards.add(card);
          break;
        case 'accepted':
          activeCards.add(card);
          break;
        case 'declined':
        case 'expired':
          doneCards.add(card);
          break;
        default:
          reviewCards.add(card);
      }
    }

    for (final d in deals) {
      final card = PipelineCardModel(
        creatorName: d.creatorUsername,
        offerTitle: d.offerTitle,
        tags: [d.status],
        brandInitial: d.brandUsername.isNotEmpty
            ? d.brandUsername[0].toUpperCase()
            : 'B',
      );
      switch (d.status) {
        case 'active':
        case 'delivered':
        case 'revision_requested':
        case 'pending_membership':
          activeCards.add(card);
          break;
        case 'complete':
          doneCards.add(card);
          break;
        default:
          reviewCards.add(card);
      }
    }

    return PipelinePayload(
      columns: [
        columns[0].copyWith(cards: newCards),
        columns[1].copyWith(cards: reviewCards),
        columns[2].copyWith(cards: activeCards),
        columns[3].copyWith(cards: doneCards),
      ],
    );
  }
}

extension on PipelineColumnModel {
  PipelineColumnModel copyWith({List<PipelineCardModel>? cards}) {
    return PipelineColumnModel(
      id: id,
      title: title,
      accentHex: accentHex,
      cards: cards ?? this.cards,
    );
  }
}
