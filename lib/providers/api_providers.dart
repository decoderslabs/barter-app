import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/auth/token_storage.dart';
import '../core/network/barter_api_client.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/brand_repository.dart';
import '../data/repositories/deal_repository.dart';
import '../data/repositories/drops_repository.dart';
import '../data/repositories/membership_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/offer_repository.dart';
import '../data/repositories/payment_repository.dart';
import '../data/repositories/proposal_repository.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final apiClientProvider = Provider<BarterApiClient>((ref) {
  return BarterApiClient(tokenStorage: ref.watch(tokenStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    client: ref.watch(apiClientProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  return OfferRepository(client: ref.watch(apiClientProvider));
});

final proposalRepositoryProvider = Provider<ProposalRepository>((ref) {
  return ProposalRepository(client: ref.watch(apiClientProvider));
});

final dealRepositoryProvider = Provider<DealRepository>((ref) {
  return DealRepository(client: ref.watch(apiClientProvider));
});

final membershipRepositoryProvider = Provider<MembershipRepository>((ref) {
  return MembershipRepository(client: ref.watch(apiClientProvider));
});

final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  return BrandRepository(
    client: ref.watch(apiClientProvider),
    authRepository: ref.watch(authRepositoryProvider),
    offerRepository: ref.watch(offerRepositoryProvider),
    proposalRepository: ref.watch(proposalRepositoryProvider),
    dealRepository: ref.watch(dealRepositoryProvider),
  );
});

final dropsRepositoryProvider = Provider<DropsRepository>((ref) {
  return DropsRepository(client: ref.watch(apiClientProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(client: ref.watch(apiClientProvider));
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(client: ref.watch(apiClientProvider));
});
