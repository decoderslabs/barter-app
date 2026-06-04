class DashboardKpis {
  const DashboardKpis({
    required this.activeCampaigns,
    required this.pendingProposals,
    required this.dealsInProgress,
    required this.totalReachThisMonth,
    required this.avgEngagementRate,
    required this.barterValueDelivered,
  });
  final int activeCampaigns;
  final int pendingProposals;
  final int dealsInProgress;
  final int totalReachThisMonth;
  final double avgEngagementRate;
  final int barterValueDelivered;

  factory DashboardKpis.fromJson(Map<String, dynamic> j) => DashboardKpis(
        activeCampaigns: j['activeCampaigns'] as int,
        pendingProposals: j['pendingProposals'] as int,
        dealsInProgress: j['dealsInProgress'] as int,
        totalReachThisMonth: j['totalReachThisMonth'] as int,
        avgEngagementRate: (j['avgEngagementRate'] as num).toDouble(),
        barterValueDelivered: j['barterValueDelivered'] as int,
      );
}

class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.route,
    required this.urgent,
    this.avatarUrl,
  });
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String timestamp;
  final String route;
  final bool urgent;
  final String? avatarUrl;

  factory ActivityItem.fromJson(Map<String, dynamic> j) => ActivityItem(
        id: j['id'] as String,
        type: j['type'] as String,
        title: j['title'] as String,
        subtitle: j['subtitle'] as String,
        timestamp: j['timestamp'] as String,
        route: j['route'] as String,
        urgent: j['urgent'] as bool,
        avatarUrl: j['avatarUrl'] as String?,
      );
}

class BrandDashboardData {
  const BrandDashboardData({
    required this.greeting,
    required this.kpis,
    required this.recentActivity,
  });
  final String greeting;
  final DashboardKpis kpis;
  final List<ActivityItem> recentActivity;

  factory BrandDashboardData.fromJson(Map<String, dynamic> j) {
    final d = j['dashboard'] as Map<String, dynamic>;
    return BrandDashboardData(
      greeting: d['greeting'] as String,
      kpis: DashboardKpis.fromJson(d['kpis'] as Map<String, dynamic>),
      recentActivity: (d['recentActivity'] as List)
          .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ─── Discovery ────────────────────────────────────────────────────────────────

class DiscoveryCreator {
  const DiscoveryCreator({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
    required this.niche,
    required this.location,
    required this.verified,
    required this.barterScore,
    required this.totalFollowers,
    required this.avgEngagementRate,
    required this.pastCollabs,
    required this.platforms,
    required this.tags,
  });
  final String id;
  final String name;
  final String username;
  final String avatarUrl;
  final String niche;
  final String location;
  final bool verified;
  final int barterScore;
  final int totalFollowers;
  final double avgEngagementRate;
  final int pastCollabs;
  final List<String> platforms;
  final List<String> tags;

  factory DiscoveryCreator.fromJson(Map<String, dynamic> j) => DiscoveryCreator(
        id: j['id'] as String,
        name: j['name'] as String,
        username: j['username'] as String,
        avatarUrl: j['avatarUrl'] as String,
        niche: j['niche'] as String,
        location: j['location'] as String,
        verified: j['verified'] as bool,
        barterScore: j['barterScore'] as int,
        totalFollowers: j['totalFollowers'] as int,
        avgEngagementRate: (j['avgEngagementRate'] as num).toDouble(),
        pastCollabs: j['pastCollabs'] as int,
        platforms: List<String>.from(j['platforms'] as List),
        tags: List<String>.from(j['tags'] as List),
      );
}

class DiscoveryFilters {
  const DiscoveryFilters({
    required this.niches,
    required this.platforms,
    required this.followerRanges,
    required this.engagementRanges,
  });
  final List<String> niches;
  final List<String> platforms;
  final List<String> followerRanges;
  final List<String> engagementRanges;

  factory DiscoveryFilters.fromJson(Map<String, dynamic> j) => DiscoveryFilters(
        niches: List<String>.from(j['niches'] as List),
        platforms: List<String>.from(j['platforms'] as List),
        followerRanges: List<String>.from(j['followerRanges'] as List),
        engagementRanges: List<String>.from(j['engagementRanges'] as List),
      );
}

class InboxData {
  const InboxData({required this.conversations});
  final List<InboxConversation> conversations;

  factory InboxData.fromJson(Map<String, dynamic> j) => InboxData(
        conversations: (j['conversations'] as List)
            .map((e) => InboxConversation.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class BrandDiscoveryData {
  const BrandDiscoveryData({required this.filters, required this.creators, required this.inbox});
  final DiscoveryFilters filters;
  final List<DiscoveryCreator> creators;
  final InboxData inbox;

  factory BrandDiscoveryData.fromJson(Map<String, dynamic> j) => BrandDiscoveryData(
        filters: DiscoveryFilters.fromJson(j['filters'] as Map<String, dynamic>),
        creators: (j['creators'] as List)
            .map((e) => DiscoveryCreator.fromJson(e as Map<String, dynamic>))
            .toList(),
        inbox: InboxData.fromJson(j['inbox'] as Map<String, dynamic>),
      );
}

// ─── Inbox ────────────────────────────────────────────────────────────────────

class InboxMessage {
  const InboxMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
  });
  final String id;
  final String sender;
  final String text;
  final String time;

  factory InboxMessage.fromJson(Map<String, dynamic> j) => InboxMessage(
        id: j['id'] as String,
        sender: j['sender'] as String,
        text: j['text'] as String,
        time: j['time'] as String,
      );
}

class InboxConversation {
  const InboxConversation({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    required this.creatorAvatar,
    required this.campaignTitle,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unread,
    required this.messages,
  });
  final String id;
  final String creatorId;
  final String creatorName;
  final String creatorAvatar;
  final String campaignTitle;
  final String lastMessage;
  final String lastMessageTime;
  final bool unread;
  final List<InboxMessage> messages;

  factory InboxConversation.fromJson(Map<String, dynamic> j) => InboxConversation(
        id: j['id'] as String,
        creatorId: j['creatorId'] as String,
        creatorName: j['creatorName'] as String,
        creatorAvatar: j['creatorAvatar'] as String,
        campaignTitle: j['campaignTitle'] as String,
        lastMessage: j['lastMessage'] as String,
        lastMessageTime: j['lastMessageTime'] as String,
        unread: j['unread'] as bool,
        messages: (j['messages'] as List)
            .map((e) => InboxMessage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
