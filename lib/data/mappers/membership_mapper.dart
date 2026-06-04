import '../dto/membership_dto.dart';
import '../models/membership_model.dart';

class MembershipMapper {
  static MembershipPayload toPayload(
    MembershipStatusDto status,
    List<MembershipTaskDto> tasks,
  ) {
    return MembershipPayload(
      status: MembershipStatus(
        proActive: status.proActive,
        pendingVerification: !status.proActive && status.totalPoints > 0,
        totalPoints: status.totalPoints,
        pointsToNextMilestone: _pointsToNext(status.totalPoints),
        tier: _tierLabel(status.tier),
        periodLabel: 'month',
        periodTaskLimit: _taskLimit(status.tier),
        completedThisPeriod: status.tasksThisPeriod,
        nextMilestoneLabel: '1 month Pro',
        proExpiresAt: status.proExpiresAt,
        history: status.totalPoints > 0
            ? [
                MembershipHistoryItem(
                  title: 'Points earned',
                  date: status.periodResetAt?.split('T').first ?? '',
                  points: status.totalPoints,
                ),
              ]
            : const [],
      ),
      tasks: tasks.map(_task).toList(),
    );
  }

  static MembershipTask _task(MembershipTaskDto dto) {
    return MembershipTask(
      id: dto.id,
      brandName: dto.brandName,
      brandLogoUrl: dto.brandLogoUrl,
      title: dto.title,
      platform: dto.platform,
      points: dto.pointsValue,
      isFeatured: dto.isFeatured,
      isAvailable: true,
      brief: MembershipTaskBrief(
        whatToCreate: dto.briefRichtext,
        keyMessages: const [],
        donts: const [],
        requiredTags: dto.requiredTags,
      ),
    );
  }

  static int _pointsToNext(int total) {
    const milestones = [50, 100, 200];
    for (final m in milestones) {
      if (total < m) return m - total;
    }
    return 0;
  }

  static String _tierLabel(String tier) {
    if (tier.isEmpty) return 'Nano';
    return tier[0].toUpperCase() + tier.substring(1);
  }

  static int _taskLimit(String tier) {
    switch (tier.toLowerCase()) {
      case 'mega':
      case 'macro':
        return 5;
      case 'mid':
      case 'micro':
        return 3;
      default:
        return 1;
    }
  }
}
