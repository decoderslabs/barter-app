import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dto/drops_dto.dart';
import '../data/dto/deal_dto.dart';
import '../data/dto/offer_dto.dart';
import '../data/dto/proposal_dto.dart';
import '../data/dto/notification_dto.dart';
import '../data/dto/user_dto.dart';
import '../data/models/analytics_model.dart';
import '../data/models/deal_room_model.dart';
import '../data/models/membership_model.dart';
import '../data/models/brand_dashboard_model.dart';
import '../data/models/brand_profile_model.dart';
import '../data/models/offer_model.dart';
import '../data/models/onboarding_config.dart';
import '../data/models/pipeline_model.dart';
import '../data/repositories/auth_repository.dart';
import 'api_providers.dart';

final dropsProvider = FutureProvider<List<DropsCampaignDto>>((ref) async {
  final repo = ref.watch(dropsRepositoryProvider);
  return repo.listCampaigns();
});

final offersProvider = FutureProvider<OffersPayload>((ref) async {
  final repo = ref.watch(offerRepositoryProvider);
  return repo.listOffers();
});

final offerDetailProvider = FutureProvider.family<OfferModel, String>((ref, id) async {
  final repo = ref.watch(offerRepositoryProvider);
  return repo.getOffer(id);
});

final valueEngineProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final repo = ref.watch(offerRepositoryProvider);
  return repo.getValueEngine(id);
});

final dealRoomProvider = FutureProvider.family<DealRoomModel, String?>((ref, dealId) async {
  final repo = ref.watch(dealRepositoryProvider);
  final id = dealId ?? await repo.firstDealId();
  if (id == null) throw Exception('No active deals');
  return repo.getDealRoom(id);
});

final pipelineProvider = FutureProvider<PipelinePayload>((ref) async {
  final repo = ref.watch(brandRepositoryProvider);
  return repo.loadPipeline();
});

final analyticsProvider = FutureProvider<AnalyticsPayload>((ref) async {
  final repo = ref.watch(brandRepositoryProvider);
  return repo.loadAnalytics();
});

final onboardingConfigProvider = FutureProvider<OnboardingConfig>((ref) async {
  final repo = ref.watch(offerRepositoryProvider);
  return repo.getOnboardingConfig();
});

final brandInboxProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, status) async {
  final repo = ref.watch(brandRepositoryProvider);
  return repo.loadInbox(status: status);
});

final membershipProvider = FutureProvider<MembershipPayload>((ref) async {
  final repo = ref.watch(membershipRepositoryProvider);
  return repo.loadMembership();
});

final brandDashboardProvider = FutureProvider<BrandDashboardData>((ref) async {
  final repo = ref.watch(brandRepositoryProvider);
  return repo.loadDashboard();
});

final brandDiscoveryProvider = FutureProvider<BrandDiscoveryData>((ref) async {
  final repo = ref.watch(brandRepositoryProvider);
  return repo.loadDiscovery();
});

final brandProfileProvider = FutureProvider<BrandProfile>((ref) async {
  final repo = ref.watch(brandRepositoryProvider);
  return repo.loadBrandProfile();
});

final proposalsListProvider = FutureProvider((ref) async {
  final repo = ref.watch(proposalRepositoryProvider);
  return repo.listProposals();
});

final proposalDetailProvider = FutureProvider.family<ProposalDetailDto, String>((ref, id) async {
  final repo = ref.watch(proposalRepositoryProvider);
  return repo.getProposal(id);
});

final myOffersProvider = FutureProvider<List<OfferListItemDto>>((ref) async {
  final repo = ref.watch(offerRepositoryProvider);
  return repo.myOffers();
});

final myDealsProvider = FutureProvider<List<DealListItemDto>>((ref) async {
  final repo = ref.watch(dealRepositoryProvider);
  return repo.listDeals();
});

final notificationsProvider = FutureProvider<List<NotificationDto>>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.listNotifications();
});

final profileStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getProfileStats();
});

final dealsHistoryProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, page) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getDealsHistory(page: page);
});

enum AppRole { creator, brand }

class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  final UserDto? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => user != null;

  /// True when the logged-in creator hasn't reached the 80% gate yet.
  bool get needsProfileCompletion {
    if (user == null || user!.role == 'brand') return false;
    final pc = user!.profileCompletion;
    if (pc == null) return false;
    return !pc.canAccessMembership;
  }

  /// True when profile is complete but the creator hasn't got membership yet.
  bool get needsMembership {
    if (user == null || user!.role == 'brand') return false;
    final pc = user!.profileCompletion;
    if (pc != null && !pc.canAccessMembership) return false;
    return !user!.canSubmitMembership;
  }

  /// Resolved initial route for the authenticated user.
  String get initialRoute {
    if (user == null) return '/welcome';
    if (user!.role == 'brand') return '/brand/dashboard';
    if (needsProfileCompletion) return '/creator/onboarding/profile';
    return '/creator/feed';
  }

  AppRole get role {
    if (user == null) return AppRole.creator;
    if (user!.role == 'brand') return AppRole.brand;
    return AppRole.creator;
  }

  AuthState copyWith({
    UserDto? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._auth) : super(const AuthState()) {
    _bootstrap();
  }

  final AuthRepository _auth;

  Future<void> _bootstrap() async {
    if (!await _auth.isLoggedIn) return;
    state = state.copyWith(isLoading: true);
    try {
      final user = await _auth.getMe();
      state = AuthState(user: user);
    } catch (_) {
      await _auth.logout();
      state = const AuthState();
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _auth.login(email: email, password: password);
      state = AuthState(user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String username,
    required AppRole role,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _auth.register(
        email: email,
        password: password,
        name: name,
        username: username,
        role: role == AppRole.brand ? 'brand' : 'creator',
      );
      state = AuthState(user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    state = const AuthState();
  }

  Future<void> refreshUser() async {
    final user = await _auth.getMe();
    state = state.copyWith(user: user);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class SessionState {
  const SessionState({
    this.onboardingStep = 0,
    this.selectedNiches = const {'Skincare', 'Tech'},
    this.selectedInterests = const <String>{},
    this.selectedContentTypes = const <String>{},
  });

  final int onboardingStep;
  final Set<String> selectedNiches;
  final Set<String> selectedInterests;
  final Set<String> selectedContentTypes;

  SessionState copyWith({
    int? onboardingStep,
    Set<String>? selectedNiches,
    Set<String>? selectedInterests,
    Set<String>? selectedContentTypes,
  }) {
    return SessionState(
      onboardingStep: onboardingStep ?? this.onboardingStep,
      selectedNiches: selectedNiches ?? this.selectedNiches,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      selectedContentTypes: selectedContentTypes ?? this.selectedContentTypes,
    );
  }
}

class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier(this._auth) : super(const SessionState());

  final AuthRepository _auth;

  void setOnboardingStep(int step) =>
      state = state.copyWith(onboardingStep: step);

  Set<String> _toggleSet(Set<String> current, String value) {
    final next = {...current};
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    return next;
  }

  void toggleNiche(String n) {
    state = state.copyWith(selectedNiches: _toggleSet(state.selectedNiches, n));
  }

  void toggleInterest(String n) {
    state = state.copyWith(selectedInterests: _toggleSet(state.selectedInterests, n));
  }

  void toggleContentType(String n) {
    state = state.copyWith(selectedContentTypes: _toggleSet(state.selectedContentTypes, n));
  }

  /// Persist all creator onboarding selections to backend
  Future<void> persistCreatorOnboarding() async {
    await _auth.updateCreatorProfile(
      niches: state.selectedNiches.toList(),
      contentTypes: state.selectedContentTypes.toList(),
    );
  }

  /// Persist profile setup data (name, bio, location)
  Future<void> persistProfileSetup({
    required String name,
    String? bio,
    String? locationCity,
    String? locationCountry,
  }) async {
    await _auth.updateProfile(
      name: name,
      bio: bio,
      locationCity: locationCity,
      locationCountry: locationCountry,
    );
  }

  /// Persist niche selections
  Future<void> persistNiches(List<String> niches) async {
    await _auth.updateCreatorProfile(niches: niches, contentTypes: state.selectedContentTypes.toList());
  }

  /// Persist content type selections
  Future<void> persistContentTypes(List<String> contentTypes) async {
    await _auth.updateCreatorProfile(
      niches: state.selectedNiches.toList(),
      contentTypes: contentTypes,
    );
  }

  /// Connect a social account
  Future<void> connectSocialAccount({
    required String platform,
    required String username,
    required int followers,
    bool verified = false,
    double? engagementRate,
  }) async {
    await _auth.addSocialAccount({
      'platform': platform,
      'username': username,
      'followers': followers,
      'verified': verified,
      if (engagementRate != null) 'engagement_rate': engagementRate,
    });
  }

  /// Remove a social account
  Future<void> disconnectSocialAccount(String platform) async {
    await _auth.removeSocialAccount(platform);
  }

  /// Verify social account ownership
  Future<bool> verifySocialAccount(String platform, {String? code}) async {
    return await _auth.verifySocialAccount(platform, verificationCode: code);
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(ref.watch(authRepositoryProvider));
});

/// Back-compat: role from auth when logged in.
final appRoleProvider = Provider<AppRole>((ref) {
  return ref.watch(authProvider).role;
});
