class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
    required this.username,
    this.bio,
    this.locationCity,
    this.locationCountry,
    this.profilePhotoUrl,
    this.coverPhotoUrl,
    this.isVerified = false,
    this.barterScore,
    this.brandProfile,
    this.creatorProfile,
    this.socialAccounts = const [],
    this.totalDealsCompleted = 0,
    this.totalReach = 0,
    this.avgEngagementRate = 0.0,
    this.barterScoreBreakdown = const {},
  });

  final String id;
  final String email;
  final String role;
  final String name;
  final String username;
  final String? bio;
  final String? locationCity;
  final String? locationCountry;
  final String? profilePhotoUrl;
  final String? coverPhotoUrl;
  final bool isVerified;
  final dynamic barterScore;
  final BrandProfileDto? brandProfile;
  final CreatorProfileDto? creatorProfile;
  final List<SocialAccountDto> socialAccounts;
  final int totalDealsCompleted;
  final int totalReach;
  final double avgEngagementRate;
  final Map<String, int> barterScoreBreakdown;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'creator',
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      bio: json['bio'] as String?,
      locationCity: json['location_city'] as String?,
      locationCountry: json['location_country'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      coverPhotoUrl: json['cover_photo_url'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      barterScore: json['barter_score'],
      brandProfile: json['brand_profile'] != null
          ? BrandProfileDto.fromJson(json['brand_profile'] as Map<String, dynamic>)
          : null,
      creatorProfile: json['creator_profile'] != null
          ? CreatorProfileDto.fromJson(json['creator_profile'] as Map<String, dynamic>)
          : null,
      socialAccounts: (json['social_accounts'] as List<dynamic>? ?? const [])
          .map((e) => SocialAccountDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDealsCompleted: _parseInt(json['total_deals_completed']),
      totalReach: _parseInt(json['total_reach']),
      avgEngagementRate: _parseDouble(json['avg_engagement_rate']),
      barterScoreBreakdown: _parseScoreBreakdown(json['barter_score_breakdown']),
    );
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  static Map<String, int> _parseScoreBreakdown(dynamic v) {
    if (v is Map) {
      return v.map((k, val) => MapEntry(k.toString(), (val as num?)?.toInt() ?? 0));
    }
    return const {};
  }
}

class BrandProfileDto {
  const BrandProfileDto({
    required this.id,
    this.companyName,
    this.website,
    this.industry,
    this.logoUrl,
    this.domainVerified = false,
  });

  final String id;
  final String? companyName;
  final String? website;
  final String? industry;
  final String? logoUrl;
  final bool domainVerified;

  factory BrandProfileDto.fromJson(Map<String, dynamic> json) => BrandProfileDto(
        id: json['id']?.toString() ?? '',
        companyName: json['company_name'] as String?,
        website: json['website'] as String?,
        industry: json['industry'] as String?,
        logoUrl: json['logo_url'] as String?,
        domainVerified: json['domain_verified'] as bool? ?? false,
      );
}

class CreatorProfileDto {
  const CreatorProfileDto({
    required this.id,
    this.niches = const [],
    this.contentTypes = const [],
    this.tier = 'nano',
  });

  final String id;
  final List<String> niches;
  final List<String> contentTypes;
  final String tier;

  factory CreatorProfileDto.fromJson(Map<String, dynamic> json) => CreatorProfileDto(
        id: json['id']?.toString() ?? '',
        niches: List<String>.from(json['niches'] as List? ?? const []),
        contentTypes: List<String>.from(json['content_types'] as List? ?? const []),
        tier: json['tier'] as String? ?? 'nano',
      );
}

class SocialAccountDto {
  const SocialAccountDto({
    required this.id,
    required this.platform,
    required this.handle,
    this.followers,
    this.engagementRate,
  });

  final String id;
  final String platform;
  final String handle;
  final int? followers;
  final double? engagementRate;

  factory SocialAccountDto.fromJson(Map<String, dynamic> json) => SocialAccountDto(
        id: json['id']?.toString() ?? '',
        platform: json['platform'] as String? ?? '',
        handle: json['handle'] as String? ?? '',
        followers: _parseInt(json['followers']),
        engagementRate: _parseDouble(json['engagement_rate']),
      );

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
