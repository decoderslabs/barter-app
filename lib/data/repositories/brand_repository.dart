import '../../core/network/barter_api_client.dart';
import '../dto/analytics_dto.dart';
import '../dto/paginated_response.dart';
import '../dto/user_dto.dart';
import '../mappers/analytics_mapper.dart';
import '../mappers/brand_dashboard_mapper.dart';
import '../models/analytics_model.dart';
import '../models/brand_dashboard_model.dart';
import '../models/brand_profile_model.dart';
import '../models/pipeline_model.dart';
import '../mappers/pipeline_mapper.dart';
import 'auth_repository.dart';
import 'deal_repository.dart';
import 'offer_repository.dart';
import 'proposal_repository.dart';

class BrandRepository {
  BrandRepository({
    BarterApiClient? client,
    AuthRepository? authRepository,
    OfferRepository? offerRepository,
    ProposalRepository? proposalRepository,
    DealRepository? dealRepository,
  })  : _client = client ?? BarterApiClient(),
        _auth = authRepository ?? AuthRepository(client: client),
        _offers = offerRepository ?? OfferRepository(client: client),
        _proposals = proposalRepository ?? ProposalRepository(client: client),
        _deals = dealRepository ?? DealRepository(client: client);

  final BarterApiClient _client;
  final AuthRepository _auth;
  final OfferRepository _offers;
  final ProposalRepository _proposals;
  final DealRepository _deals;

  Future<BrandDashboardData> loadDashboard() async {
    final user = await _auth.getMe();
    final offers = await _offers.myOffers();
    final proposals = await _proposals.listProposals();
    final deals = await _deals.listDeals();
    DealsAnalyticsDto? analytics;
    try {
      final a = await _client.getJson('/analytics/deals');
      analytics = DealsAnalyticsDto.fromJson(a);
    } catch (_) {}

    return BrandDashboardMapper.compose(
      user: user,
      offers: offers,
      proposals: proposals,
      deals: deals,
      analytics: analytics,
    );
  }

  Future<BrandDiscoveryData> loadDiscovery() async {
    final data = await _client.getJson('/users/creators');
    final creators = PaginatedResponse.fromJson(data, UserDto.fromJson).results;
    return BrandDashboardMapper.fromCreators(creators);
  }

  Future<BrandProfile> loadBrandProfile() async {
    final user = await _auth.getMe();
    final bp = user.brandProfile;
    final score = (user.barterScore is num)
        ? (user.barterScore as num).round()
        : int.tryParse(user.barterScore?.toString() ?? '0') ?? 0;
    return BrandProfile(
      id: user.id,
      name: bp?.companyName ?? user.name,
      tagline: user.bio ?? '',
      logoUrl: bp?.logoUrl ?? user.profilePhotoUrl ?? '',
      coverUrl: user.profilePhotoUrl ?? '',
      website: bp?.website ?? '',
      industry: bp?.industry ?? '',
      location: [user.locationCity, user.locationCountry]
          .where((e) => e != null && e.isNotEmpty)
          .join(', '),
      founded: '',
      verified: user.isVerified || (bp?.domainVerified ?? false),
      description: user.bio ?? '',
      niches: const [],
      stats: const BrandStats(
        activeCampaigns: 0,
        totalCollaborations: 0,
        avgBarterValue: 0,
        creatorsWorkedWith: 0,
        totalReach: 0,
        avgEngagementRate: 0,
      ),
      barterScore: BrandBarterScore(
        overall: score,
        paymentReliability: score,
        communication: score,
        briefClarity: score,
        repeatRate: score,
        label: 'Barter Score',
      ),
      badges: const [],
      activeCampaignPreviews: const [],
      recentCollaborations: const [],
      team: const [],
    );
  }

  Future<AnalyticsPayload> loadAnalytics() async {
    final data = await _client.getJson('/analytics/deals');
    return AnalyticsMapper.fromDealsAnalytics(DealsAnalyticsDto.fromJson(data));
  }

  Future<PipelinePayload> loadPipeline() async {
    final proposals = await _proposals.listProposals();
    final deals = await _deals.listDeals();
    return PipelineMapper.fromProposalsAndDeals(proposals, deals);
  }

  Future<List<Map<String, dynamic>>> loadInbox({String? status}) async {
    final list = await _client.getJsonList(
      '/brands/inbox',
      queryParameters: {if (status != null) 'status': status},
    );
    return list.cast<Map<String, dynamic>>();
  }
}
