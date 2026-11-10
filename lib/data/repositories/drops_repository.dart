import '../../core/network/barter_api_client.dart';
import '../dto/drops_dto.dart';

class DropsRepository {
  DropsRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<List<DropsCampaignDto>> listCampaigns() async {
    final list = await _client.getJsonList('/drops', auth: false);
    return list.map((e) => DropsCampaignDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<DropsCampaignDto> getCampaign(String id) async {
    final data = await _client.getJson('/drops/$id');
    return DropsCampaignDto.fromJson(data);
  }

  Future<DropsCampaignDto> createCampaign(Map<String, dynamic> body) async {
    final data = await _client.postJson('/drops', body: body);
    return DropsCampaignDto.fromJson(data);
  }

  Future<List<DropsApplicationDto>> listApplications(String campaignId) async {
    final list = await _client.getJsonList('/drops/$campaignId/applications');
    return list.map((e) => DropsApplicationDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> apply(String campaignId, String pitch) async {
    await _client.postJson(
      '/drops/$campaignId/apply',
      body: {'campaign': campaignId, 'pitch': pitch},
    );
  }

  Future<void> approveApplication(String campaignId, String appId) async {
    await _client.postJson('/drops/$campaignId/applications/$appId/approve');
  }

  Future<void> declineApplication(String campaignId, String appId) async {
    await _client.postJson('/drops/$campaignId/applications/$appId/decline');
  }
}
