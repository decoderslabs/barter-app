class DropsCampaignDto {
  const DropsCampaignDto({
    required this.id,
    required this.name,
    required this.goal,
    required this.totalSlots,
    required this.filledSlots,
    required this.status,
    this.brandName,
    this.applicationCount = 0,
  });

  final String id;
  final String name;
  final String goal;
  final int totalSlots;
  final int filledSlots;
  final String status;
  final String? brandName;
  final int applicationCount;

  factory DropsCampaignDto.fromJson(Map<String, dynamic> json) => DropsCampaignDto(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? '',
        goal: json['goal'] as String? ?? '',
        totalSlots: (json['total_slots'] as num?)?.toInt() ?? 0,
        filledSlots: (json['filled_slots'] as num?)?.toInt() ?? 0,
        status: json['status'] as String? ?? '',
        brandName: json['brand_name'] as String?,
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

  factory DropsApplicationDto.fromJson(Map<String, dynamic> json) =>
      DropsApplicationDto(
        id: json['id']?.toString() ?? '',
        creatorUsername: json['creator_username'] as String? ?? '',
        creatorName: json['creator_name'] as String? ?? '',
        status: json['status'] as String? ?? '',
        pitch: json['pitch'] as String?,
      );
}
