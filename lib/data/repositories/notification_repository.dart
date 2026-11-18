import '../../core/network/barter_api_client.dart';
import '../dto/notification_dto.dart';
import '../dto/paginated_response.dart';

class NotificationRepository {
  NotificationRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<List<NotificationDto>> listNotifications() async {
    final list = await _client.getJsonList('/notifications');
    return list
        .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markRead(String id) async {
    await _client.patchJson('/notifications/$id/read');
  }

  Future<void> markAllRead() async {
    await _client.patchJson('/notifications/read-all');
  }

  Future<void> saveOneSignalPlayerId(String playerId) async {
    if (playerId.isEmpty) return;
    try {
      await _client.postJson(
        '/users/me/onesignal-id',
        body: {'player_id': playerId},
      );
    } catch (_) {
      // Best-effort push token sync
    }
  }
}
