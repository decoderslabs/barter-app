import '../../core/network/barter_api_client.dart';
import '../dto/offer_dto.dart';
import '../dto/paginated_response.dart';
import '../mappers/offer_mapper.dart';
import '../models/offer_model.dart';
import '../models/onboarding_config.dart';

class OfferRepository {
  OfferRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<OffersPayload> listOffers({String? niche}) async {
    final data = await _client.getJson(
      '/offers',
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
    final data = await _client.getJson('/offers/$id', auth: false);
    return OfferMapper.fromDetail(OfferDetailDto.fromJson(data));
  }

  Future<Map<String, dynamic>> getValueEngine(String offerId) async {
    return _client.getJson('/offers/$offerId/value-engine');
  }

  Future<Map<String, dynamic>> createOffer(Map<String, dynamic> body) async {
    return _client.postJson('/offers', body: body);
  }

  Future<List<OfferListItemDto>> myOffers() async {
    final list = await _client.getJsonList('/offers/my');
    return list
        .map((e) => OfferListItemDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<OnboardingConfig> getOnboardingConfig() async {
    final data = await _client.getJson('/config/onboarding');
    return OnboardingConfig.fromJson(data);
  }
}
