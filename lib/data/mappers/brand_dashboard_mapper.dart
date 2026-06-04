import '../dto/analytics_dto.dart';
import '../dto/deal_dto.dart';
import '../dto/offer_dto.dart';
import '../dto/proposal_dto.dart';
import '../dto/user_dto.dart';
import '../models/brand_dashboard_model.dart';

class BrandDashboardMapper {
  static BrandDashboardData compose({
    required UserDto user,
    required List<OfferListItemDto> offers,
    required List<ProposalListItemDto> proposals,
    required List<DealListItemDto> deals,
    DealsAnalyticsDto? analytics,
  }) {
    final pending = proposals.where((p) => p.status == 'pending').length;
    final inProgress = deals
        .where((d) => ['active', 'delivered', 'revision_requested'].contains(d.status))
        .length;
    final liveOffers = offers.where((o) => o.status == 'live').length;

    final activity = <ActivityItem>[];
    for (final p in proposals.take(5)) {
      activity.add(ActivityItem(
        id: p.id,
        type: 'proposal',
        title: 'Proposal from @${p.creatorUsername}',
        subtitle: p.offerTitle,
        timestamp: p.createdAt ?? '',
        route: '/brand/review-proposal',
        urgent: p.status == 'pending',
      ));
    }
    for (final d in deals.take(3)) {
      activity.add(ActivityItem(
        id: d.id,
        type: 'deal',
        title: 'Deal: ${d.offerTitle}',
        subtitle: d.status,
        timestamp: d.createdAt ?? '',
        route: '/deal/${d.id}',
        urgent: d.status == 'revision_requested',
      ));
    }

    return BrandDashboardData(
      greeting: 'Hello, ${user.name.split(' ').first}',
      kpis: DashboardKpis(
        activeCampaigns: liveOffers,
        pendingProposals: pending,
        dealsInProgress: inProgress,
        totalReachThisMonth: analytics?.recentDeals30Days ?? 0,
        avgEngagementRate: analytics?.completionRate ?? 0,
        barterValueDelivered:
            int.tryParse(analytics?.avgDealValue?.toString() ?? '0') ?? 0,
      ),
      recentActivity: activity,
    );
  }

  static BrandDiscoveryData fromCreators(List<UserDto> creators) {
    return BrandDiscoveryData(
      filters: const DiscoveryFilters(
        niches: ['Skincare', 'Tech', 'Fashion', 'Food', 'Fitness'],
        platforms: ['Instagram', 'TikTok', 'YouTube'],
        followerRanges: ['1K–10K', '10K–50K', '50K+'],
        engagementRanges: ['2%+', '5%+'],
      ),
      creators: creators.map(_discoveryCreator).toList(),
      inbox: const InboxData(conversations: []),
    );
  }

  static DiscoveryCreator _discoveryCreator(UserDto u) {
    final profile = u.creatorProfile;
    final niche = profile?.niches.isNotEmpty == true ? profile!.niches.first : 'Creator';
    final platforms = u.socialAccounts.map((s) => s.platform).toList();
    final followers = u.socialAccounts.fold<int>(
      0,
      (sum, s) => sum + (s.followers ?? 0),
    );
    final engagement = u.socialAccounts.isEmpty
        ? 0.0
        : u.socialAccounts
                .map((s) => s.engagementRate ?? 0)
                .reduce((a, b) => a + b) /
            u.socialAccounts.length;

    return DiscoveryCreator(
      id: u.id,
      name: u.name,
      username: u.username,
      avatarUrl: u.profilePhotoUrl ?? '',
      niche: niche,
      location: [u.locationCity, u.locationCountry]
          .where((e) => e != null && e.isNotEmpty)
          .join(', '),
      verified: u.isVerified,
      barterScore: (u.barterScore is num)
          ? (u.barterScore as num).round()
          : int.tryParse(u.barterScore?.toString() ?? '0') ?? 0,
      totalFollowers: followers,
      avgEngagementRate: engagement,
      pastCollabs: 0,
      platforms: platforms.isEmpty ? const ['Instagram'] : platforms,
      tags: profile?.contentTypes ?? const [],
    );
  }
}
