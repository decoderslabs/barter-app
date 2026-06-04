class BrandBadge {
  const BrandBadge({required this.id, required this.label, required this.icon});
  final String id;
  final String label;
  final String icon;

  factory BrandBadge.fromJson(Map<String, dynamic> j) => BrandBadge(
        id: j['id'] as String,
        label: j['label'] as String,
        icon: j['icon'] as String,
      );
}

class CampaignPreview {
  const CampaignPreview({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.status,
    required this.applicants,
    required this.spots,
    required this.barterValue,
  });
  final String id;
  final String title;
  final String imageUrl;
  final String status;
  final int applicants;
  final int spots;
  final String barterValue;

  factory CampaignPreview.fromJson(Map<String, dynamic> j) => CampaignPreview(
        id: j['id'] as String,
        title: j['title'] as String,
        imageUrl: j['imageUrl'] as String,
        status: j['status'] as String,
        applicants: j['applicants'] as int,
        spots: j['spots'] as int,
        barterValue: j['barterValue'] as String,
      );
}

class RecentCollaboration {
  const RecentCollaboration({
    required this.creatorName,
    required this.creatorAvatar,
    required this.campaignTitle,
    required this.rating,
    required this.niche,
    required this.completedDate,
  });
  final String creatorName;
  final String creatorAvatar;
  final String campaignTitle;
  final double rating;
  final String niche;
  final String completedDate;

  factory RecentCollaboration.fromJson(Map<String, dynamic> j) =>
      RecentCollaboration(
        creatorName: j['creatorName'] as String,
        creatorAvatar: j['creatorAvatar'] as String,
        campaignTitle: j['campaignTitle'] as String,
        rating: (j['rating'] as num).toDouble(),
        niche: j['niche'] as String,
        completedDate: j['completedDate'] as String,
      );
}

class BrandManagerSocialLink {
  const BrandManagerSocialLink({required this.platform, required this.url});
  final String platform;
  final String url;

  factory BrandManagerSocialLink.fromJson(Map<String, dynamic> j) =>
      BrandManagerSocialLink(
        platform: j['platform'] as String,
        url: j['url'] as String,
      );
}

class BrandManager {
  const BrandManager({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.email,
    required this.phone,
    required this.activeCampaigns,
    required this.dealsManaged,
    required this.responseTime,
    required this.joinedDate,
    required this.bio,
    required this.socialLinks,
  });
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final String email;
  final String phone;
  final int activeCampaigns;
  final int dealsManaged;
  final String responseTime;
  final String joinedDate;
  final String bio;
  final List<BrandManagerSocialLink> socialLinks;

  factory BrandManager.fromJson(Map<String, dynamic> j) => BrandManager(
        id: j['id'] as String,
        name: j['name'] as String,
        role: j['role'] as String,
        avatarUrl: j['avatarUrl'] as String,
        email: j['email'] as String,
        phone: j['phone'] as String,
        activeCampaigns: j['activeCampaigns'] as int,
        dealsManaged: j['dealsManaged'] as int,
        responseTime: j['responseTime'] as String,
        joinedDate: j['joinedDate'] as String,
        bio: j['bio'] as String,
        socialLinks: (j['socialLinks'] as List)
            .map((e) => BrandManagerSocialLink.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class BrandBarterScore {
  const BrandBarterScore({
    required this.overall,
    required this.paymentReliability,
    required this.communication,
    required this.briefClarity,
    required this.repeatRate,
    required this.label,
  });
  final int overall;
  final int paymentReliability;
  final int communication;
  final int briefClarity;
  final int repeatRate;
  final String label;

  factory BrandBarterScore.fromJson(Map<String, dynamic> j) => BrandBarterScore(
        overall: j['overall'] as int,
        paymentReliability: j['paymentReliability'] as int,
        communication: j['communication'] as int,
        briefClarity: j['briefClarity'] as int,
        repeatRate: j['repeatRate'] as int,
        label: j['label'] as String,
      );
}

class BrandStats {
  const BrandStats({
    required this.activeCampaigns,
    required this.totalCollaborations,
    required this.avgBarterValue,
    required this.creatorsWorkedWith,
    required this.totalReach,
    required this.avgEngagementRate,
  });
  final int activeCampaigns;
  final int totalCollaborations;
  final int avgBarterValue;
  final int creatorsWorkedWith;
  final int totalReach;
  final double avgEngagementRate;

  factory BrandStats.fromJson(Map<String, dynamic> j) => BrandStats(
        activeCampaigns: j['activeCampaigns'] as int,
        totalCollaborations: j['totalCollaborations'] as int,
        avgBarterValue: j['avgBarterValue'] as int,
        creatorsWorkedWith: j['creatorsWorkedWith'] as int,
        totalReach: j['totalReach'] as int,
        avgEngagementRate: (j['avgEngagementRate'] as num).toDouble(),
      );
}

class BrandProfile {
  const BrandProfile({
    required this.id,
    required this.name,
    required this.tagline,
    required this.logoUrl,
    required this.coverUrl,
    required this.website,
    required this.industry,
    required this.location,
    required this.founded,
    required this.verified,
    required this.description,
    required this.niches,
    required this.stats,
    required this.barterScore,
    required this.badges,
    required this.activeCampaignPreviews,
    required this.recentCollaborations,
    required this.team,
  });

  final String id;
  final String name;
  final String tagline;
  final String logoUrl;
  final String coverUrl;
  final String website;
  final String industry;
  final String location;
  final String founded;
  final bool verified;
  final String description;
  final List<String> niches;
  final BrandStats stats;
  final BrandBarterScore barterScore;
  final List<BrandBadge> badges;
  final List<CampaignPreview> activeCampaignPreviews;
  final List<RecentCollaboration> recentCollaborations;
  final List<BrandManager> team;

  factory BrandProfile.fromJson(Map<String, dynamic> j) {
    final b = j['brand'] as Map<String, dynamic>;
    return BrandProfile(
      id: b['id'] as String,
      name: b['name'] as String,
      tagline: b['tagline'] as String,
      logoUrl: b['logoUrl'] as String,
      coverUrl: b['coverUrl'] as String,
      website: b['website'] as String,
      industry: b['industry'] as String,
      location: b['location'] as String,
      founded: b['founded'] as String,
      verified: b['verified'] as bool,
      description: b['description'] as String,
      niches: List<String>.from(b['niches'] as List),
      stats: BrandStats.fromJson(b['stats'] as Map<String, dynamic>),
      barterScore: BrandBarterScore.fromJson(b['barterScore'] as Map<String, dynamic>),
      badges: (b['badges'] as List)
          .map((e) => BrandBadge.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeCampaignPreviews: (b['activeCampaignPreviews'] as List)
          .map((e) => CampaignPreview.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentCollaborations: (b['recentCollaborations'] as List)
          .map((e) => RecentCollaboration.fromJson(e as Map<String, dynamic>))
          .toList(),
      team: (b['team'] as List)
          .map((e) => BrandManager.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
