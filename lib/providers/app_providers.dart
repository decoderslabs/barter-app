import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dto/drops_dto.dart';
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

final notificationsProvider = FutureProvider<List<NotificationDto>>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.listNotifications();
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

  Future<void> persistCreatorOnboarding() async {
    await _auth.updateCreatorProfile(
      niches: state.selectedNiches.toList(),
      contentTypes: state.selectedContentTypes.toList(),
    );
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(ref.watch(authRepositoryProvider));
});

/// Back-compat: role from auth when logged in.
final appRoleProvider = Provider<AppRole>((ref) {
  return ref.watch(authProvider).role;
});
