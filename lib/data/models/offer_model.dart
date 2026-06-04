class OfferModel {
  const OfferModel({
    required this.id,
    required this.brandName,
    required this.brandLogoUrl,
    required this.title,
    required this.estimatedValueLabel,
    required this.offerTypeLabel,
    required this.verifiedLabel,
    required this.requirementTags,
    this.matchTag,
    this.invertedCta = false,
    this.heroImageUrl,
    this.heroTitle,
    this.heroSubtitle,
    this.heroCaption,
  });

  final String id;
  final String brandName;
  final String brandLogoUrl;
  final String title;
  final String estimatedValueLabel;
  final String offerTypeLabel;
  final String verifiedLabel;
  final List<String> requirementTags;
  final String? matchTag;
  final bool invertedCta;
  final String? heroImageUrl;
  final String? heroTitle;
  final String? heroSubtitle;
  final String? heroCaption;

  factory OfferModel.fromJson(Map<String, dynamic> j) {
    return OfferModel(
      id: j['id'] as String,
      brandName: j['brandName'] as String,
      brandLogoUrl: j['brandLogoUrl'] as String,
      title: j['title'] as String,
      estimatedValueLabel: j['estimatedValueLabel'] as String,
      offerTypeLabel: j['offerTypeLabel'] as String,
      verifiedLabel: j['verifiedLabel'] as String? ?? 'Verified',
      requirementTags: (j['requirementTags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      matchTag: j['matchTag'] as String?,
      invertedCta: j['invertedCta'] as bool? ?? false,
      heroImageUrl: j['heroImageUrl'] as String?,
      heroTitle: j['heroTitle'] as String?,
      heroSubtitle: j['heroSubtitle'] as String?,
      heroCaption: j['heroCaption'] as String?,
    );
  }
}

class OffersPayload {
  const OffersPayload({required this.offers, required this.resultCount});

  final List<OfferModel> offers;
  final int resultCount;

  factory OffersPayload.fromJson(Map<String, dynamic> j) {
    return OffersPayload(
      offers: (j['offers'] as List<dynamic>)
          .map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      resultCount: (j['resultCount'] as num).toInt(),
    );
  }
}
