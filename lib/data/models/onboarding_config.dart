class CreatorProfileConfig {
  const CreatorProfileConfig({
    required this.suggestedName,
    required this.suggestedHandle,
    required this.suggestedBio,
    required this.suggestedLocation,
    required this.defaultAvatar,
  });

  final String suggestedName;
  final String suggestedHandle;
  final String suggestedBio;
  final String suggestedLocation;
  final String defaultAvatar;

  factory CreatorProfileConfig.fromJson(Map<String, dynamic> j) {
    return CreatorProfileConfig(
      suggestedName: j['suggestedName'] as String? ?? '',
      suggestedHandle: j['suggestedHandle'] as String? ?? '',
      suggestedBio: j['suggestedBio'] as String? ?? '',
      suggestedLocation: j['suggestedLocation'] as String? ?? '',
      defaultAvatar: j['defaultAvatar'] as String? ?? '',
    );
  }
}

class OnboardingConfig {
  const OnboardingConfig({
    required this.niches,
    required this.interests,
    required this.contentTypes,
    required this.brandAvatarUrl,
    required this.creatorProfile,
  });

  final List<String> niches;
  final List<String> interests;
  final List<String> contentTypes;
  final String brandAvatarUrl;
  final CreatorProfileConfig creatorProfile;

  factory OnboardingConfig.fromJson(Map<String, dynamic> j) {
    final brand = j['brandProfile'] as Map<String, dynamic>?;
    final creator = j['creatorProfile'] as Map<String, dynamic>?;
    return OnboardingConfig(
      niches: (j['niches'] as List<dynamic>).map((e) => e as String).toList(),
      interests:
          (j['interests'] as List<dynamic>).map((e) => e as String).toList(),
      contentTypes: (j['contentTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      brandAvatarUrl: brand?['avatarUrl'] as String? ?? '',
      creatorProfile: creator != null
          ? CreatorProfileConfig.fromJson(creator)
          : const CreatorProfileConfig(
              suggestedName: '',
              suggestedHandle: '',
              suggestedBio: '',
              suggestedLocation: '',
              defaultAvatar: '',
            ),
    );
  }
}
