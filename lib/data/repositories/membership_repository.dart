import '../../core/config/api_config.dart';
import '../../core/network/barter_api_client.dart';
import '../dto/membership_dto.dart';
import '../dto/paginated_response.dart';
import '../mappers/membership_mapper.dart';
import '../mock_json_bundle.dart';
import '../models/membership_model.dart';

class MembershipRepository {
  MembershipRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<MembershipPayload> loadMembership() async {
    if (ApiConfig.useMockData) return MockJsonBundle.instance.loadMembership();

    final statusData = await _client.getJson('/api/membership/status/');
    final status = MembershipStatusDto.fromJson(statusData);

    final tasksData = await _client.getJson('/api/membership/tasks/');
    final tasks = PaginatedResponse.fromJson(tasksData, MembershipTaskDto.fromJson).results;

    return MembershipMapper.toPayload(status, tasks);
  }

  Future<void> submitTask({
    required String taskId,
    required String postUrl,
    String? note,
  }) async {
    await _client.postJson(
      '/api/membership/submissions/',
      body: {
        'task': taskId,
        'post_url': postUrl,
        if (note != null && note.isNotEmpty) 'note': note,
      },
    );
  }
}
