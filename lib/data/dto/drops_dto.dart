class DropsCampaignDto {
  const DropsCampaignDto({
    required this.id,
    required this.name,
    required this.goal,
    required this.totalSlots,
    required this.filledSlots,
    required this.status,
    this.title,
    this.description,
    this.heroImageUrl,
    this.brandName,
    this.brandLogoUrl,
    this.deadline,
    this.slotsRemaining,
    this.estimatedValue,
    this.currency,
    this.contentAsk = const {},
    this.applicationCount = 0,
  });

  final String id;
  final String name;
  final String? title;
  final String? description;
  final String goal;
  final int totalSlots;
  final int filledSlots;
  final int? slotsRemaining;
  final String status;
  final String? heroImageUrl;
  final String? brandName;
  final String? brandLogoUrl;
  final String? deadline;
  final double? estimatedValue;
  final String? currency;
  final Map<String, dynamic> contentAsk;
  final int applicationCount;

  factory DropsCampaignDto.fromJson(Map<String, dynamic> json) => DropsCampaignDto(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? json['title'] as String? ?? '',
        title: json['title'] as String? ?? json['name'] as String?,
        description: json['description'] as String?,
        goal: json['goal'] as String? ?? '',
        totalSlots: (json['total_slots'] as num?)?.toInt() ?? 0,
        filledSlots: (json['filled_slots'] as num?)?.toInt() ?? 0,
        slotsRemaining: (json['slots_remaining'] as num?)?.toInt(),
        status: json['status'] as String? ?? '',
        heroImageUrl: json['hero_image_url'] as String?,
        brandName: json['brand_name'] as String?,
        brandLogoUrl: json['brand_logo_url'] as String?,
        deadline: json['deadline'] as String? ?? json['application_deadline'] as String?,
        estimatedValue: (json['estimated_value'] as num?)?.toDouble(),
        currency: json['currency'] as String?,
        contentAsk: json['content_ask'] is Map ? Map<String, dynamic>.from(json['content_ask'] as Map) : const {},
        applicationCount: (json['application_count'] as num?)?.toInt() ?? 0,
      );
}

class DropsApplicationDto {
  const DropsApplicationDto({
    required this.id,
    required this.creatorUsername,
    required this.creatorName,
    required this.status,
    this.pitch,
  });

  final String id;
  final String creatorUsername;
  final String creatorName;
  final String status;
  final String? pitch;

  factory DropsApplicationDto.fromJson(Map<String, dynamic> json) {
    final creator = json['creator'] as Map<String, dynamic>?;
    return DropsApplicationDto(
      id: json['id']?.toString() ?? '',
      creatorUsername: creator?['username'] as String? ?? json['creator_username'] as String? ?? '',
      creatorName: creator?['name'] as String? ?? json['creator_name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      pitch: json['pitch'] as String?,
    );
  }
}
