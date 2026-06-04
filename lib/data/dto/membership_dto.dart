class MembershipStatusDto {
  const MembershipStatusDto({
    required this.totalPoints,
    required this.proActive,
    this.proExpiresAt,
    this.proDaysRemaining = 0,
    this.tier = 'nano',
    this.tasksThisPeriod = 0,
    this.periodResetAt,
    this.pointsToNextMilestone = 0,
    this.periodLabel = '',
    this.periodTaskLimit = 0,
    this.completedThisPeriod = 0,
    this.nextMilestoneLabel = '',
    this.pendingVerification = false,
    this.history = const [],
  });

  final int totalPoints;
  final bool proActive;
  final String? proExpiresAt;
  final int proDaysRemaining;
  final String tier;
  final int tasksThisPeriod;
  final String? periodResetAt;
  final int pointsToNextMilestone;
  final String periodLabel;
  final int periodTaskLimit;
  final int completedThisPeriod;
  final String nextMilestoneLabel;
  final bool pendingVerification;
  final List<Map<String, dynamic>> history;

  factory MembershipStatusDto.fromJson(Map<String, dynamic> json) =>
      MembershipStatusDto(
        totalPoints: _parseInt(json['total_points']),
        proActive: json['pro_active'] as bool? ?? false,
        proExpiresAt: json['pro_expires_at'] as String?,
        proDaysRemaining: _parseInt(json['pro_days_remaining']),
        tier: json['tier'] as String? ?? 'nano',
        tasksThisPeriod: _parseInt(json['tasks_this_period']),
        periodResetAt: json['period_reset_at'] as String?,
        pointsToNextMilestone: _parseInt(json['points_to_next_milestone']),
        periodLabel: json['period_label'] as String? ?? '',
        periodTaskLimit: _parseInt(json['period_task_limit']),
        completedThisPeriod: _parseInt(json['completed_this_period']),
        nextMilestoneLabel: json['next_milestone_label'] as String? ?? '',
        pendingVerification: json['pending_verification'] as bool? ?? false,
        history: (() {
          final h = json['history'];
          if (h is List) return h.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
          return <Map<String, dynamic>>[];
        })(),
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
        id: json['id']?.toString() ?? '',
        // WP returns int post IDs — convert to String for consistency
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

class MembershipTaskBriefDto {
  const MembershipTaskBriefDto({
    this.briefRichtext = '',
    this.requiredTags = const [],
  });

  final String briefRichtext;
  final List<String> requiredTags;

  factory MembershipTaskBriefDto.fromJson(Map<String, dynamic> json) =>
      MembershipTaskBriefDto(
        briefRichtext: json['brief_richtext'] as String? ?? '',
        requiredTags: (() {
          final tags = json['required_tags'];
          if (tags is List) return List<String>.from(tags);
          if (tags is String && tags.isNotEmpty) return tags.split(',').map((t) => t.trim()).toList();
          return <String>[];
        })(),
      );
}
