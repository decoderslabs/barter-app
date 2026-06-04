import '../../core/network/barter_api_client.dart';
import '../dto/notification_dto.dart';
import '../dto/paginated_response.dart';

class NotificationRepository {
  NotificationRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<List<NotificationDto>> listNotifications() async {
    final data = await _client.getJson('/api/notifications/');
    return PaginatedResponse.fromJson(data, NotificationDto.fromJson).results;
  }

  Future<void> markRead(String id) async {
    await _client.patchJson('/api/notifications/$id/read/');
  }

  Future<void> markAllRead() async {
    await _client.postJson('/api/notifications/read-all/');
  }
}
