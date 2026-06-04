class MembershipPayload {
  const MembershipPayload({required this.status, required this.tasks});

  final MembershipStatus status;
  final List<MembershipTask> tasks;

  factory MembershipPayload.fromJson(Map<String, dynamic> json) {
    return MembershipPayload(
      status: MembershipStatus.fromJson(json['status'] as Map<String, dynamic>),
      tasks: (json['tasks'] as List<dynamic>? ?? const [])
          .map((e) => MembershipTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MembershipStatus {
  const MembershipStatus({
    required this.proActive,
    required this.pendingVerification,
    required this.totalPoints,
    required this.pointsToNextMilestone,
    required this.tier,
    required this.periodLabel,
    required this.periodTaskLimit,
    required this.completedThisPeriod,
    required this.nextMilestoneLabel,
    required this.history,
    this.proExpiresAt,
  });

  final bool proActive;
  final bool pendingVerification;
  final int totalPoints;
  final int pointsToNextMilestone;
  final String tier;
  final String periodLabel;
  final int periodTaskLimit;
  final int completedThisPeriod;
  final String nextMilestoneLabel;
  final String? proExpiresAt;
  final List<MembershipHistoryItem> history;

  factory MembershipStatus.fromJson(Map<String, dynamic> json) {
    return MembershipStatus(
      proActive: json['pro_active'] as bool? ?? false,
      pendingVerification: json['pending_verification'] as bool? ?? false,
      totalPoints: json['total_points'] as int? ?? 0,
      pointsToNextMilestone: json['points_to_next_milestone'] as int? ?? 0,
      tier: json['tier'] as String? ?? 'Nano',
      periodLabel: json['period_label'] as String? ?? 'month',
      periodTaskLimit: json['period_task_limit'] as int? ?? 1,
      completedThisPeriod: json['completed_this_period'] as int? ?? 0,
      nextMilestoneLabel: json['next_milestone_label'] as String? ?? '1 month Pro',
      proExpiresAt: json['pro_expires_at'] as String?,
      history: (json['history'] as List<dynamic>? ?? const [])
          .map((e) => MembershipHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MembershipHistoryItem {
  const MembershipHistoryItem({
    required this.title,
    required this.date,
    required this.points,
  });

  final String title;
  final String date;
  final int points;

  factory MembershipHistoryItem.fromJson(Map<String, dynamic> json) {
    return MembershipHistoryItem(
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      points: json['points'] as int? ?? 0,
    );
  }
}

class MembershipTask {
  const MembershipTask({
    required this.id,
    required this.brandName,
    required this.brandLogoUrl,
    required this.title,
    required this.platform,
    required this.points,
    required this.isFeatured,
    required this.isAvailable,
    required this.brief,
    this.availableAgainOn,
  });

  final String id;
  final String brandName;
  final String brandLogoUrl;
  final String title;
  final String platform;
  final int points;
  final bool isFeatured;
  final bool isAvailable;
  final String? availableAgainOn;
  final MembershipTaskBrief brief;

  factory MembershipTask.fromJson(Map<String, dynamic> json) {
    return MembershipTask(
      id: json['id'] as String? ?? '',
      brandName: json['brand_name'] as String? ?? '',
      brandLogoUrl: json['brand_logo_url'] as String? ?? '',
      title: json['title'] as String? ?? '',
      platform: json['platform'] as String? ?? 'Open',
      points: json['points'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? true,
      availableAgainOn: json['available_again_on'] as String?,
      brief: MembershipTaskBrief.fromJson(json['brief'] as Map<String, dynamic>? ?? const {}),
    );
  }
}

class MembershipTaskBrief {
  const MembershipTaskBrief({
    required this.whatToCreate,
    required this.keyMessages,
    required this.donts,
    required this.requiredTags,
    this.exampleUrl,
  });

  final String whatToCreate;
  final List<String> keyMessages;
  final List<String> donts;
  final List<String> requiredTags;
  final String? exampleUrl;

  factory MembershipTaskBrief.fromJson(Map<String, dynamic> json) {
    return MembershipTaskBrief(
      whatToCreate: json['what_to_create'] as String? ?? '',
      keyMessages: (json['key_messages'] as List<dynamic>? ?? const []).cast<String>(),
      donts: (json['donts'] as List<dynamic>? ?? const []).cast<String>(),
      requiredTags: (json['required_tags'] as List<dynamic>? ?? const []).cast<String>(),
      exampleUrl: json['example_url'] as String?,
    );
  }
}
