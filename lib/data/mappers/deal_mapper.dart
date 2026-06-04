import 'package:intl/intl.dart';

import '../dto/deal_dto.dart';
import '../models/deal_room_model.dart';

class DealMapper {
  static DealRoomModel toDealRoom(
    DealDetailDto deal,
    List<DealMessageDto> messages, {
    String brandLogoUrl = '',
    String creatorAvatarUrl = '',
  }) {
    final terms = deal.agreedTerms['offer_title']?.toString() ?? deal.offerTitle;
    return DealRoomModel(
      dealId: deal.id,
      brandName: deal.brandName,
      brandLogoUrl: brandLogoUrl,
      creatorAvatarUrl: creatorAvatarUrl,
      termsSummary: terms,
      milestones: _milestones(deal),
      daysRemaining: _daysRemaining(deal.deadline),
      agreementDateLabel: _formatDate(deal.deadline),
      messages: messages.map(_message).toList(),
    );
  }

  static List<MilestoneModel> _milestones(DealDetailDto deal) {
    final status = deal.status;
    bool done(String s) {
      const order = [
        'pending_membership',
        'active',
        'delivered',
        'revision_requested',
        'complete',
      ];
      final idx = order.indexOf(status);
      final target = order.indexOf(s);
      if (idx < 0 || target < 0) return false;
      return idx >= target;
    }

    return [
      MilestoneModel(
        id: 'agreement',
        label: 'Agreement signed',
        done: true,
      ),
      MilestoneModel(
        id: 'ship',
        label: 'Product shipped',
        done: deal.shippedAt != null || done('active'),
      ),
      MilestoneModel(
        id: 'deliver',
        label: 'Content delivered',
        done: deal.deliveredAt != null || done('delivered'),
      ),
      MilestoneModel(
        id: 'complete',
        label: 'Deal complete',
        done: status == 'complete',
      ),
    ];
  }

  static DealMessageModel _message(DealMessageDto dto) {
    DateTime? dt;
    try {
      dt = DateTime.parse(dto.createdAt);
    } catch (_) {}
    return DealMessageModel(
      id: dto.id,
      from: dto.senderName.isNotEmpty ? dto.senderName : dto.senderUsername,
      text: dto.body,
      time: dt != null ? DateFormat.jm().format(dt.toLocal()) : dto.createdAt,
      avatarUrl: '',
    );
  }

  static int _daysRemaining(String? deadline) {
    if (deadline == null) return 0;
    try {
      final d = DateTime.parse(deadline);
      return d.difference(DateTime.now()).inDays.clamp(0, 999);
    } catch (_) {
      return 0;
    }
  }

  static String _formatDate(String? iso) {
    if (iso == null) return '';
    try {
      return DateFormat.yMMMd().format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }
}
