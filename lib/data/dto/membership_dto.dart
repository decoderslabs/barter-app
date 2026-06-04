class MembershipStatusDto {
  const MembershipStatusDto({
    required this.totalPoints,
    required this.proActive,
    this.proExpiresAt,
    this.proDaysRemaining = 0,
    this.tier = 'nano',
    this.tasksThisPeriod = 0,
    this.periodResetAt,
  });

  final int totalPoints;
  final bool proActive;
  final String? proExpiresAt;
  final int proDaysRemaining;
  final String tier;
  final int tasksThisPeriod;
  final String? periodResetAt;

  factory MembershipStatusDto.fromJson(Map<String, dynamic> json) =>
      MembershipStatusDto(
        totalPoints: _parseInt(json['total_points']),
        proActive: json['pro_active'] as bool? ?? false,
        proExpiresAt: json['pro_expires_at'] as String?,
        proDaysRemaining: _parseInt(json['pro_days_remaining']),
        tier: json['tier'] as String? ?? 'nano',
        tasksThisPeriod: _parseInt(json['tasks_this_period']),
        periodResetAt: json['period_reset_at'] as String?,
      );

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class MembershipTaskDto {
  const MembershipTaskDto({
    required this.id,
    required this.brandName,
    required this.brandLogoUrl,
    required this.title,
    required this.platform,
    required this.pointsValue,
    this.briefRichtext = '',
    this.requiredTags = const [],
    this.isFeatured = false,
  });

  final String id;
  final String brandName;
  final String brandLogoUrl;
  final String title;
  final String platform;
  final int pointsValue;
  final String briefRichtext;
  final List<String> requiredTags;
  final bool isFeatured;

  factory MembershipTaskDto.fromJson(Map<String, dynamic> json) => MembershipTaskDto(
        id: json['id'] as String,
        brandName: json['brand_name'] as String? ?? '',
        brandLogoUrl: json['brand_logo_url'] as String? ?? '',
        title: json['title'] as String? ?? '',
        platform: json['platform'] as String? ?? 'Open',
        pointsValue: MembershipStatusDto._parseInt(json['points_value']),
        briefRichtext: json['brief_richtext'] as String? ?? '',
        requiredTags: List<String>.from(json['required_tags'] as List? ?? const []),
        isFeatured: json['is_featured'] as bool? ?? false,
      );
}
