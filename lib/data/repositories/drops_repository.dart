import '../../core/network/barter_api_client.dart';
import '../dto/drops_dto.dart';
import '../dto/paginated_response.dart';

class DropsRepository {
  DropsRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<List<DropsCampaignDto>> listCampaigns() async {
    final data = await _client.getJson('/api/drops/');
    return PaginatedResponse.fromJson(data, DropsCampaignDto.fromJson).results;
  }

  Future<DropsCampaignDto> getCampaign(String id) async {
    final data = await _client.getJson('/api/drops/$id/');
    return DropsCampaignDto.fromJson(data);
  }

  Future<DropsCampaignDto> createCampaign(Map<String, dynamic> body) async {
    final data = await _client.postJson('/api/drops/', body: body);
    return DropsCampaignDto.fromJson(data);
  }

  Future<List<DropsApplicationDto>> listApplications(String campaignId) async {
    final data = await _client.getJson('/api/drops/$campaignId/applications/');
    return PaginatedResponse.fromJson(data, DropsApplicationDto.fromJson).results;
  }

  Future<void> apply(String campaignId, String pitch) async {
    await _client.postJson(
      '/api/drops/$campaignId/apply/',
      body: {'campaign': campaignId, 'pitch': pitch},
    );
  }

  Future<void> approveApplication(String campaignId, String appId) async {
    await _client.postJson('/api/drops/$campaignId/applications/$appId/approve/');
  }

  Future<void> declineApplication(String campaignId, String appId) async {
    await _client.postJson('/api/drops/$campaignId/applications/$appId/decline/');
  }
}
