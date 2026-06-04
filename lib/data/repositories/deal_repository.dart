import '../../core/config/api_config.dart';
import '../../core/network/barter_api_client.dart';
import '../dto/deal_dto.dart';
import '../dto/paginated_response.dart';
import '../mappers/deal_mapper.dart';
import '../mock_json_bundle.dart';
import '../models/deal_room_model.dart';

class DealRepository {
  DealRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<List<DealListItemDto>> listDeals() async {
    if (ApiConfig.useMockData) return [];

    final data = await _client.getJson('/api/deals/');
    return PaginatedResponse.fromJson(data, DealListItemDto.fromJson).results;
  }

  Future<DealRoomModel> getDealRoom(String dealId) async {
    if (ApiConfig.useMockData) return MockJsonBundle.instance.loadDealRoom();

    final dealData = await _client.getJson('/api/deals/$dealId/');
    final deal = DealDetailDto.fromJson(dealData);
    final messagesRaw = await _client.getJsonList('/api/deals/$dealId/messages/');
    final messages = messagesRaw
        .map((e) => DealMessageDto.fromJson(e as Map<String, dynamic>))
        .toList();
    return DealMapper.toDealRoom(deal, messages);
  }

  Future<void> sendMessage(String dealId, String body) async {
    await _client.postJson(
      '/api/deals/$dealId/messages/send/',
      body: {'body': body},
    );
  }

  Future<void> shipDeal(String dealId, Map<String, dynamic> shippingAddress) async {
    await _client.postJson(
      '/api/deals/$dealId/ship/',
      body: {'shipping_address': shippingAddress},
    );
  }

  Future<void> deliverContent({
    required String dealId,
    required List<String> files,
    required List<String> postUrls,
    String? notes,
  }) async {
    await _client.postJson(
      '/api/deals/$dealId/deliver/',
      body: {
        'files': files,
        'post_urls': postUrls,
        if (notes != null) 'notes': notes,
      },
    );
  }

  Future<void> requestRevision(String dealId, String reason) async {
    await _client.postJson(
      '/api/deals/$dealId/request-revision/',
      body: {'reason': reason},
    );
  }

  Future<void> approveDelivery(String dealId) async {
    await _client.postJson('/api/deals/$dealId/approve/');
  }

  Future<void> completeDeal(String dealId) async {
    await _client.postJson('/api/deals/$dealId/complete/');
  }

  Future<void> rateDeal(String dealId, Map<String, dynamic> rating) async {
    await _client.postJson('/api/ratings/$dealId/rate/', body: rating);
  }

  Future<String?> firstDealId() async {
    final deals = await listDeals();
    return deals.isEmpty ? null : deals.first.id;
  }
}
