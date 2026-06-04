class DealMessageModel {
  const DealMessageModel({
    required this.id,
    required this.from,
    required this.text,
    required this.time,
    required this.avatarUrl,
  });

  final String id;
  final String from;
  final String text;
  final String time;
  final String avatarUrl;

  factory DealMessageModel.fromJson(Map<String, dynamic> j) {
    return DealMessageModel(
      id: j['id'] as String,
      from: j['from'] as String,
      text: j['text'] as String,
      time: j['time'] as String,
      avatarUrl: j['avatarUrl'] as String,
    );
  }
}

class MilestoneModel {
  const MilestoneModel({
    required this.id,
    required this.label,
    required this.done,
  });

  final String id;
  final String label;
  final bool done;

  factory MilestoneModel.fromJson(Map<String, dynamic> j) {
    return MilestoneModel(
      id: j['id'] as String,
      label: j['label'] as String,
      done: j['done'] as bool,
    );
  }
}

class DealRoomModel {
  const DealRoomModel({
    required this.dealId,
    required this.brandName,
    required this.brandLogoUrl,
    required this.creatorAvatarUrl,
    required this.termsSummary,
    required this.milestones,
    required this.daysRemaining,
    required this.agreementDateLabel,
    required this.messages,
  });

  final String dealId;
  final String brandName;
  final String brandLogoUrl;
  final String creatorAvatarUrl;
  final String termsSummary;
  final List<MilestoneModel> milestones;
  final int daysRemaining;
  final String agreementDateLabel;
  final List<DealMessageModel> messages;

  factory DealRoomModel.fromJson(Map<String, dynamic> j) {
    return DealRoomModel(
      dealId: j['dealId'] as String,
      brandName: j['brandName'] as String,
      brandLogoUrl: j['brandLogoUrl'] as String,
      creatorAvatarUrl: j['creatorAvatarUrl'] as String,
      termsSummary: j['termsSummary'] as String,
      milestones: (j['milestones'] as List<dynamic>)
          .map((e) => MilestoneModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      daysRemaining: (j['daysRemaining'] as num).toInt(),
      agreementDateLabel: j['agreementDateLabel'] as String,
      messages: (j['messages'] as List<dynamic>)
          .map((e) => DealMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
