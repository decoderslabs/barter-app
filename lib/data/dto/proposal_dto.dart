class ProposalListItemDto {
  const ProposalListItemDto({
    required this.id,
    required this.offerTitle,
    required this.offerBrandUsername,
    required this.creatorUsername,
    required this.status,
    required this.roundNumber,
    this.createdAt,
  });

  final String id;
  final String offerTitle;
  final String offerBrandUsername;
  final String creatorUsername;
  final String status;
  final int roundNumber;
  final String? createdAt;

  factory ProposalListItemDto.fromJson(Map<String, dynamic> json) =>
      ProposalListItemDto(
        id: json['id'] as String,
        offerTitle: json['offer_title'] as String? ?? '',
        offerBrandUsername: json['offer_brand_username'] as String? ?? '',
        creatorUsername: json['creator_username'] as String? ?? '',
        status: json['status'] as String,
        roundNumber: _parseInt(json['round_number']),
        createdAt: json['created_at'] as String?,
      );

  static int _parseInt(dynamic value) {
    if (value == null) return 1;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 1;
    return 1;
  }
}

class ProposalDetailDto {
  const ProposalDetailDto({
    required this.id,
    required this.offerId,
    required this.offerTitle,
    required this.creatorUsername,
    required this.creatorName,
    required this.pitch,
    required this.deliverables,
    required this.timeline,
    required this.status,
    required this.roundNumber,
    this.canCounter = false,
  });

  final String id;
  final String offerId;
  final String offerTitle;
  final String creatorUsername;
  final String creatorName;
  final String pitch;
  final Map<String, dynamic> deliverables;
  final String timeline;
  final String status;
  final int roundNumber;
  final bool canCounter;

  factory ProposalDetailDto.fromJson(Map<String, dynamic> json) => ProposalDetailDto(
        id: json['id'] as String,
        offerId: json['offer'] as String,
        offerTitle: json['offer_title'] as String? ?? '',
        creatorUsername: json['creator_username'] as String? ?? '',
        creatorName: json['creator_name'] as String? ?? '',
        pitch: json['pitch'] as String? ?? '',
        deliverables: Map<String, dynamic>.from(json['deliverables'] as Map? ?? const {}),
        timeline: json['timeline'] as String,
        status: json['status'] as String,
        roundNumber: ProposalListItemDto._parseInt(json['round_number']),
        canCounter: json['can_counter'] as bool? ?? false,
      );
}
