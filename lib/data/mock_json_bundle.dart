import 'dart:convert';

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart' show rootBundle;

import 'models/analytics_model.dart';
import 'models/brand_dashboard_model.dart';
import 'models/brand_profile_model.dart';
import 'models/deal_room_model.dart';
import 'models/membership_model.dart';
import 'models/offer_model.dart';
import 'models/onboarding_config.dart';
import 'models/pipeline_model.dart';

// Top-level parse functions required by compute() — must not be closures.
OffersPayload _parseOffers(String s) =>
    OffersPayload.fromJson(jsonDecode(s) as Map<String, dynamic>);
DealRoomModel _parseDealRoom(String s) =>
    DealRoomModel.fromJson(jsonDecode(s) as Map<String, dynamic>);
PipelinePayload _parsePipeline(String s) =>
    PipelinePayload.fromJson(jsonDecode(s) as Map<String, dynamic>);
AnalyticsPayload _parseAnalytics(String s) =>
    AnalyticsPayload.fromJson(jsonDecode(s) as Map<String, dynamic>);
OnboardingConfig _parseOnboarding(String s) =>
    OnboardingConfig.fromJson(jsonDecode(s) as Map<String, dynamic>);
MembershipPayload _parseMembership(String s) =>
    MembershipPayload.fromJson(jsonDecode(s) as Map<String, dynamic>);
BrandDashboardData _parseBrandDashboard(String s) =>
    BrandDashboardData.fromJson(jsonDecode(s) as Map<String, dynamic>);
BrandDiscoveryData _parseBrandDiscovery(String s) =>
    BrandDiscoveryData.fromJson(jsonDecode(s) as Map<String, dynamic>);
BrandProfile _parseBrandProfile(String s) =>
    BrandProfile.fromJson(jsonDecode(s) as Map<String, dynamic>);

class MockJsonBundle {
  MockJsonBundle._();

  static final MockJsonBundle instance = MockJsonBundle._();

  OffersPayload? _offers;
  DealRoomModel? _dealRoom;
  PipelinePayload? _pipeline;
  AnalyticsPayload? _analytics;
  OnboardingConfig? _onboarding;
  MembershipPayload? _membership;
  BrandProfile? _brandProfile;
  BrandDashboardData? _brandDashboard;
  BrandDiscoveryData? _brandDiscovery;

  Future<OffersPayload> loadOffers() async {
    _offers ??= await compute(
      _parseOffers,
      await rootBundle.loadString('assets/mock/offers.json'),
    );
    return _offers!;
  }

  Future<DealRoomModel> loadDealRoom() async {
    _dealRoom ??= await compute(
      _parseDealRoom,
      await rootBundle.loadString('assets/mock/deal_room.json'),
    );
    return _dealRoom!;
  }

  Future<PipelinePayload> loadPipeline() async {
    _pipeline ??= await compute(
      _parsePipeline,
      await rootBundle.loadString('assets/mock/pipeline.json'),
    );
    return _pipeline!;
  }

  Future<AnalyticsPayload> loadAnalytics() async {
    _analytics ??= await compute(
      _parseAnalytics,
      await rootBundle.loadString('assets/mock/analytics.json'),
    );
    return _analytics!;
  }

  Future<OnboardingConfig> loadOnboarding() async {
    _onboarding ??= await compute(
      _parseOnboarding,
      await rootBundle.loadString('assets/mock/onboarding.json'),
    );
    return _onboarding!;
  }

  Future<MembershipPayload> loadMembership() async {
    _membership ??= await compute(
      _parseMembership,
      await rootBundle.loadString('assets/mock/membership.json'),
    );
    return _membership!;
  }

  Future<BrandDashboardData> loadBrandDashboard() async {
    _brandDashboard ??= await compute(
      _parseBrandDashboard,
      await rootBundle.loadString('assets/mock/brand_dashboard_data.json'),
    );
    return _brandDashboard!;
  }

  Future<BrandDiscoveryData> loadBrandDiscovery() async {
    _brandDiscovery ??= await compute(
      _parseBrandDiscovery,
      await rootBundle.loadString('assets/mock/brand_discovery_data.json'),
    );
    return _brandDiscovery!;
  }

  Future<BrandProfile> loadBrandProfile() async {
    _brandProfile ??= await compute(
      _parseBrandProfile,
      await rootBundle.loadString('assets/mock/brand_profile_data.json'),
    );
    return _brandProfile!;
  }
}
