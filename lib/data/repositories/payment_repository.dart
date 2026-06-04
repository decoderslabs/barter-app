import '../../core/network/barter_api_client.dart';

class PaymentRepository {
  PaymentRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<Map<String, dynamic>> createDealFee({required String dealId}) async {
    return _client.postJson(
      '/api/payments/create-deal-fee/',
      body: {'deal_id': dealId},
    );
  }

  Future<Map<String, dynamic>> mySubscription() async {
    return _client.getJson('/api/payments/subscriptions/me/');
  }

  Future<Map<String, dynamic>> myWallet() async {
    return _client.getJson('/api/payments/wallet/');
  }
}
