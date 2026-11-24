import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferWizardState {
  const CreateOfferWizardState({
    this.title = 'TaskFlow Pro Annual',
    this.description = 'Premium annual subscription to TaskFlow Pro. Includes all automation features and priority support for growth teams.',
    this.type = 'SaaS / Software',
    this.estimatedValue = 12000,
    this.currency = 'INR',
    this.quantity = 10,
    this.contentAsk = const ['1 Reel', '2 Stories'],
    this.kpiPreferences = const ['Engagement Rate > 3%'],
    this.rightsTier = 'perpetual_digital',
    this.rawFilesRequired = true,
    this.exclusivity = false,
    this.shippingRequired = false,
    this.images = const [],
    this.customTerms = '',
  });

  final String title;
  final String description;
  final String type;
  final double estimatedValue;
  final String currency;
  final int quantity;
  final List<String> contentAsk;
  final List<String> kpiPreferences;
  final String rightsTier;
  final bool rawFilesRequired;
  final bool exclusivity;
  final bool shippingRequired;
  final List<String> images;
  final String customTerms;

  CreateOfferWizardState copyWith({
    String? title,
    String? description,
    String? type,
    double? estimatedValue,
    String? currency,
    int? quantity,
    List<String>? contentAsk,
    List<String>? kpiPreferences,
    String? rightsTier,
    bool? rawFilesRequired,
    bool? exclusivity,
    bool? shippingRequired,
    List<String>? images,
    String? customTerms,
  }) {
    return CreateOfferWizardState(
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      contentAsk: contentAsk ?? this.contentAsk,
      kpiPreferences: kpiPreferences ?? this.kpiPreferences,
      rightsTier: rightsTier ?? this.rightsTier,
      rawFilesRequired: rawFilesRequired ?? this.rawFilesRequired,
      exclusivity: exclusivity ?? this.exclusivity,
      shippingRequired: shippingRequired ?? this.shippingRequired,
      images: images ?? this.images,
      customTerms: customTerms ?? this.customTerms,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'type': type,
    'estimated_value': estimatedValue,
    'currency': currency,
    'quantity': quantity,
    'content_ask': contentAsk,
    'kpi_preferences': kpiPreferences,
    'rights_tier': rightsTier,
    'raw_files_required': rawFilesRequired ? 1 : 0,
    'exclusivity': exclusivity,
    'shipping_required': shippingRequired ? 1 : 0,
    'images': images,
    if (customTerms.isNotEmpty) 'custom_terms': customTerms,
  };
}

class CreateOfferWizardNotifier extends StateNotifier<CreateOfferWizardState> {
  CreateOfferWizardNotifier() : super(const CreateOfferWizardState());

  void updateDetails({
    required String title,
    required String description,
    required String type,
    required int quantity,
    double? estimatedValue,
    String? currency,
  }) {
    state = state.copyWith(
      title: title,
      description: description,
      type: type,
      quantity: quantity,
      estimatedValue: estimatedValue ?? state.estimatedValue,
      currency: currency ?? state.currency,
    );
  }

  void updateRequirements({
    List<String>? contentAsk,
    List<String>? kpiPreferences,
  }) {
    state = state.copyWith(
      contentAsk: contentAsk ?? state.contentAsk,
      kpiPreferences: kpiPreferences ?? state.kpiPreferences,
    );
  }

  void updateRights({
    required String rightsTier,
    bool? rawFilesRequired,
    bool? exclusivity,
    String? customTerms,
  }) {
    state = state.copyWith(
      rightsTier: rightsTier,
      rawFilesRequired: rawFilesRequired ?? state.rawFilesRequired,
      exclusivity: exclusivity ?? state.exclusivity,
      customTerms: customTerms ?? state.customTerms,
    );
  }

  void reset() => state = const CreateOfferWizardState();
}

final createOfferWizardProvider =
    StateNotifierProvider<CreateOfferWizardNotifier, CreateOfferWizardState>(
  (ref) => CreateOfferWizardNotifier(),
);
