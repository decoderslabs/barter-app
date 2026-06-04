import '../../core/config/api_config.dart';
import '../../core/network/barter_api_client.dart';
import '../dto/offer_dto.dart';
import '../dto/paginated_response.dart';
import '../mappers/offer_mapper.dart';
import '../mock_json_bundle.dart';
import '../models/offer_model.dart';
import '../models/onboarding_config.dart';

class OfferRepository {
  OfferRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<OffersPayload> listOffers({String? niche}) async {
    if (ApiConfig.useMockData) return MockJsonBundle.instance.loadOffers();

    final data = await _client.getJson(
      '/api/offers/',
      queryParameters: {if (niche != null) 'niche': niche},
      auth: false,
    );
    final page = PaginatedResponse.fromJson(data, OfferListItemDto.fromJson);
    return OffersPayload(
      offers: page.results.map(OfferMapper.fromListItem).toList(),
      resultCount: page.count,
    );
  }

  Future<OfferModel> getOffer(String id) async {
    if (ApiConfig.useMockData) {
      final payload = await MockJsonBundle.instance.loadOffers();
      return payload.offers.firstWhere(
        (o) => o.id == id,
        orElse: () => payload.offers.first,
      );
    }
    final data = await _client.getJson('/api/offers/$id/', auth: false);
    return OfferMapper.fromDetail(OfferDetailDto.fromJson(data));
  }

  Future<Map<String, dynamic>> getValueEngine(String offerId) async {
    final data = await _client.getJson('/api/offers/$offerId/value-engine/');
    return data;
  }

  Future<Map<String, dynamic>> createOffer(Map<String, dynamic> body) async {
    return _client.postJson('/api/offers/', body: body);
  }

  Future<List<OfferListItemDto>> myOffers() async {
    final data = await _client.getJson('/api/offers/my/');
    final page = PaginatedResponse.fromJson(data, OfferListItemDto.fromJson);
    return page.results;
  }

  Future<OnboardingConfig> getOnboardingConfig() async {
    if (ApiConfig.useMockData) {
      return MockJsonBundle.instance.loadOnboarding();
    }
    final data = await _client.getJson('/api/config/onboarding/');
    return OnboardingConfig.fromJson(data);
  }
}
