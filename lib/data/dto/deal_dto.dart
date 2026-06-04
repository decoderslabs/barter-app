class DealListItemDto {
  const DealListItemDto({
    required this.id,
    required this.offerTitle,
    required this.brandUsername,
    required this.creatorUsername,
    required this.status,
    this.dealFee,
    this.currency,
    this.deadline,
    this.createdAt,
  });

  final String id;
  final String offerTitle;
  final String brandUsername;
  final String creatorUsername;
  final String status;
  final String? dealFee;
  final String? currency;
  final String? deadline;
  final String? createdAt;

  factory DealListItemDto.fromJson(Map<String, dynamic> json) => DealListItemDto(
        id: json['id']?.toString() ?? '',
        offerTitle: json['offer_title'] as String? ?? '',
        brandUsername: json['brand_username'] as String? ?? '',
        creatorUsername: json['creator_username'] as String? ?? '',
        status: json['status'] as String? ?? '',
        dealFee: json['deal_fee']?.toString(),
        currency: json['currency'] as String?,
        deadline: json['deadline'] as String?,
        createdAt: json['created_at'] as String?,
      );
}

class DealDetailDto {
  const DealDetailDto({
    required this.id,
    required this.status,
    required this.brandUsername,
    required this.brandName,
    required this.creatorUsername,
    required this.creatorName,
    required this.offerTitle,
    this.agreedTerms = const {},
    this.deadline,
    this.shippedAt,
    this.deliveredAt,
    this.completedAt,
    this.contractUrl,
  });

  final String id;
  final String status;
  final String brandUsername;
  final String brandName;
  final String creatorUsername;
  final String creatorName;
  final String offerTitle;
  final Map<String, dynamic> agreedTerms;
  final String? deadline;
  final String? shippedAt;
  final String? deliveredAt;
  final String? completedAt;
  final String? contractUrl;

  factory DealDetailDto.fromJson(Map<String, dynamic> json) => DealDetailDto(
        id: json['id']?.toString() ?? '',
        status: json['status'] as String? ?? '',
        brandUsername: json['brand_username'] as String? ?? '',
        brandName: json['brand_name'] as String? ?? '',
        creatorUsername: json['creator_username'] as String? ?? '',
        creatorName: json['creator_name'] as String? ?? '',
        offerTitle: json['offer_title'] as String? ?? '',
        agreedTerms: Map<String, dynamic>.from(json['agreed_terms'] as Map? ?? const {}),
        deadline: json['deadline'] as String?,
        shippedAt: json['shipped_at'] as String?,
        deliveredAt: json['delivered_at'] as String?,
        completedAt: json['completed_at'] as String?,
        contractUrl: json['contract_url'] as String?,
      );
}

class DealMessageDto {
  const DealMessageDto({
    required this.id,
    required this.senderUsername,
    required this.senderName,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String senderUsername;
  final String senderName;
  final String body;
  final String createdAt;

  factory DealMessageDto.fromJson(Map<String, dynamic> json) => DealMessageDto(
        id: json['id']?.toString() ?? '',
        senderUsername: json['sender_username'] as String? ?? '',
        senderName: json['sender_name'] as String? ?? '',
        body: json['body'] as String? ?? '',
        createdAt: json['created_at'] as String? ?? '',
      );
}
