import '../../core/network/barter_api_client.dart';
import '../dto/membership_dto.dart';
import '../dto/paginated_response.dart';
import '../mappers/membership_mapper.dart';
import '../models/membership_model.dart';

class MembershipRepository {
  MembershipRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<MembershipPayload> loadMembership() async {
    final statusData = await _client.getJson('/membership/status');
    final status = MembershipStatusDto.fromJson(statusData);

    final tasksRaw = await _client.getJsonList('/membership/tasks');
    final tasks = tasksRaw
        .map((e) => MembershipTaskDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return MembershipMapper.toPayload(status, tasks);
  }

  Future<void> submitTask({
    required String taskId,
    required String postUrl,
    String? note,
  }) async {
    await _client.postJson(
      '/membership/submissions',
      body: {
        'task_id': int.tryParse(taskId) ?? taskId,
        'post_url': postUrl,
        if (note != null && note.isNotEmpty) 'note': note,
      },
    );
  }

  Future<MembershipTaskBriefDto> getTaskBrief(String taskId) async {
    final data = await _client.getJson('/membership/tasks/$taskId/brief');
    return MembershipTaskBriefDto.fromJson(data);
  }
}
