import 'package:dio/dio.dart';

import '../models/analytics_model.dart';
import '../models/brand_dashboard_model.dart';
import '../models/brand_profile_model.dart';
import '../models/deal_room_model.dart';
import '../models/membership_model.dart';
import '../models/offer_model.dart';
import '../models/onboarding_config.dart';
import '../models/pipeline_model.dart';
import 'api_client.dart';

class ApiService {
  ApiService() : _dio = ApiClient.instance.dio;

  final Dio _dio;

  // ==================== Auth ====================

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post('/auth/login/', data: {
      'email': email,
      'password': password,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _dio.post('/auth/register/', data: {
      'email': email,
      'password': password,
      'role': role,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('/users/me/');
    return response.data as Map<String, dynamic>;
  }

  // ==================== Config / Onboarding ====================

  Future<OnboardingConfig> getOnboardingConfig() async {
    final response = await _dio.get('/config/onboarding/');
    return OnboardingConfig.fromJson(response.data as Map<String, dynamic>);
  }

  // ==================== Offers ====================

  Future<OffersPayload> getOffers() async {
    final response = await _dio.get('/offers/');
    return OffersPayload.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getOfferDetail(String id) async {
    final response = await _dio.get('/offers/$id/');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createOffer(Map<String, dynamic> data) async {
    final response = await _dio.post('/offers/', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getOfferValueEngine(String id) async {
    final response = await _dio.get('/offers/$id/value-engine/');
    return response.data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getMyOffers() async {
    final response = await _dio.get('/offers/my/');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  // ==================== Proposals ====================

  Future<List<Map<String, dynamic>>> getProposals({String? status}) async {
    final response = await _dio.get('/proposals/', queryParameters: {
      if (status != null) 'status': status,
    });
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getProposal(String id) async {
    final response = await _dio.get('/proposals/$id/');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createProposal({
    required String offerId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dio.post('/offers/$offerId/proposals/', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> counterProposal({
    required String proposalId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dio.post('/proposals/$proposalId/counter/', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<void> acceptProposal(String proposalId) async {
    await _dio.post('/proposals/$proposalId/accept/');
  }

  Future<void> declineProposal(String proposalId) async {
    await _dio.post('/proposals/$proposalId/decline/');
  }

  // ==================== Deals ====================

  Future<List<Map<String, dynamic>>> getDeals() async {
    final response = await _dio.get('/deals/');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<DealRoomModel> getDeal(String id) async {
    final response = await _dio.get('/deals/$id/');
    return DealRoomModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> getDealMessages(String dealId) async {
    final response = await _dio.get('/deals/$dealId/messages/');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<void> sendDealMessage({
    required String dealId,
    required String content,
  }) async {
    await _dio.post('/deals/$dealId/messages/send/', data: {'content': content});
  }

  Future<void> shipDeal(String dealId) async {
    await _dio.post('/deals/$dealId/ship/');
  }

  Future<void> confirmReceipt(String dealId) async {
    await _dio.post('/deals/$dealId/confirm-receipt/');
  }

  Future<void> deliverContent(String dealId) async {
    await _dio.post('/deals/$dealId/deliver/');
  }

  Future<void> approveContent(String dealId) async {
    await _dio.post('/deals/$dealId/approve/');
  }

  Future<void> requestRevision(String dealId) async {
    await _dio.post('/deals/$dealId/request-revision/');
  }

  Future<void> completeDeal(String dealId) async {
    await _dio.post('/deals/$dealId/complete/');
  }

  Future<void> disputeDeal(String dealId) async {
    await _dio.post('/deals/$dealId/dispute/');
  }

  // ==================== Membership ====================

  Future<MembershipPayload> getMembershipStatus() async {
    final response = await _dio.get('/membership/status/');
    return MembershipPayload.fromJson(response.data as Map<String, dynamic>);
  }

  Future<MembershipPayload> getMembershipTasks() async {
    final response = await _dio.get('/membership/tasks/');
    return MembershipPayload.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getTaskBrief(String taskId) async {
    final response = await _dio.get('/membership/tasks/$taskId/brief/');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitTask({
    required String taskId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dio.post('/membership/submissions/', data: {
      'task_id': taskId,
      ...data,
    });
    return response.data as Map<String, dynamic>;
  }

  // ==================== Brand ====================

  Future<BrandDashboardData> getBrandDashboard() async {
    final response = await _dio.get('/brands/dashboard/');
    return BrandDashboardData.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> getBrandInbox({String? status}) async {
    final response = await _dio.get('/brands/inbox/', queryParameters: {
      if (status != null) 'status': status,
    });
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  // ==================== Users / Creators ====================

  Future<List<Map<String, dynamic>>> getCreators() async {
    final response = await _dio.get('/users/creators/');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getUser(String id) async {
    final response = await _dio.get('/users/$id/');
    return response.data as Map<String, dynamic>;
  }

  Future<void> updateCreatorProfile(Map<String, dynamic> data) async {
    await _dio.patch('/users/me/creator-profile/', data: data);
  }

  Future<void> updateBrandProfile(Map<String, dynamic> data) async {
    await _dio.patch('/users/me/brand-profile/', data: data);
  }

  // ==================== Analytics ====================

  Future<AnalyticsPayload> getAnalytics() async {
    final response = await _dio.get('/analytics/deals/');
    return AnalyticsPayload.fromJson(response.data as Map<String, dynamic>);
  }

  // ==================== Notifications ====================

  Future<Map<String, dynamic>> getNotifications() async {
    final response = await _dio.get('/notifications/');
    return response.data as Map<String, dynamic>;
  }

  Future<int> getUnreadNotificationCount() async {
    final response = await _dio.get('/notifications/unread-count/');
    return (response.data['count'] as num).toInt();
  }

  Future<void> markNotificationRead(String id) async {
    await _dio.patch('/notifications/$id/read/');
  }

  Future<void> markAllNotificationsRead() async {
    await _dio.patch('/notifications/read-all/');
  }

  // ==================== Drops ====================

  Future<List<Map<String, dynamic>>> getDrops() async {
    final response = await _dio.get('/drops/');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createDrop(Map<String, dynamic> data) async {
    final response = await _dio.post('/drops/', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<void> applyToDrop(String dropId) async {
    await _dio.post('/drops/$dropId/apply/');
  }

  Future<List<Map<String, dynamic>>> getDropApplications(String dropId) async {
    final response = await _dio.get('/drops/$dropId/applications/');
    return (response.data as List).cast<Map<String, dynamic>>();
  }

  // ==================== OAuth ====================

  Future<Map<String, dynamic>> getOAuthUrl(String platform) async {
    final response = await _dio.get('/auth/oauth/$platform/url/');
    return response.data as Map<String, dynamic>;
  }
}
