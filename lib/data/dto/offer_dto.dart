class OfferListItemDto {
  const OfferListItemDto({
    required this.id,
    required this.brandUsername,
    required this.brandName,
    required this.type,
    required this.title,
    required this.estimatedValue,
    required this.currency,
    required this.quantityRemaining,
    required this.status,
    this.contentAsk = const {},
    this.createdAt,
  });

  final String id;
  final String brandUsername;
  final String brandName;
  final String type;
  final String title;
  final String estimatedValue;
  final String currency;
  final int quantityRemaining;
  final String status;
  final Map<String, dynamic> contentAsk;
  final String? createdAt;

  factory OfferListItemDto.fromJson(Map<String, dynamic> json) => OfferListItemDto(
        id: json['id']?.toString() ?? '',
        brandUsername: json['brand_username'] as String? ?? '',
        brandName: json['brand_name'] as String? ?? '',
        type: json['type'] as String? ?? '',
        title: json['title'] as String? ?? '',
        estimatedValue: json['estimated_value']?.toString() ?? '0',
        currency: json['currency'] as String? ?? 'INR',
        quantityRemaining: _parseInt(json['quantity_remaining']),
        status: json['status'] as String? ?? '',
        contentAsk: Map<String, dynamic>.from(json['content_ask'] as Map? ?? const {}),
        createdAt: json['created_at'] as String?,
      );

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class OfferDetailDto extends OfferListItemDto {
  const OfferDetailDto({
    required super.id,
    required super.brandUsername,
    required super.brandName,
    required super.type,
    required super.title,
    required super.estimatedValue,
    required super.currency,
    required super.quantityRemaining,
    required super.status,
    super.contentAsk,
    super.createdAt,
    this.description = '',
    this.images = const [],
    this.rightsTier = 'none',
    this.brandCompanyName,
    this.proposalCount = 0,
    this.isDrops = false,
  });

  final String description;
  final List<String> images;
  final String rightsTier;
  final String? brandCompanyName;
  final int proposalCount;
  final bool isDrops;

  factory OfferDetailDto.fromJson(Map<String, dynamic> json) => OfferDetailDto(
        id: json['id']?.toString() ?? '',
        brandUsername: json['brand_username'] as String? ?? '',
        brandName: json['brand_name'] as String? ?? '',
        type: json['type'] as String? ?? '',
        title: json['title'] as String? ?? '',
        estimatedValue: json['estimated_value']?.toString() ?? '0',
        currency: json['currency'] as String? ?? 'INR',
        quantityRemaining: OfferListItemDto._parseInt(json['quantity_remaining']),
        status: json['status'] as String? ?? '',
        contentAsk: Map<String, dynamic>.from(json['content_ask'] as Map? ?? const {}),
        createdAt: json['created_at'] as String?,
        description: json['description'] as String? ?? '',
        images: List<String>.from(json['images'] as List? ?? const []),
        rightsTier: json['rights_tier'] as String? ?? 'none',
        brandCompanyName: json['brand_company_name'] as String?,
        proposalCount: OfferListItemDto._parseInt(json['proposal_count']),
        isDrops: json['is_drops'] as bool? ?? false,
      );
}
