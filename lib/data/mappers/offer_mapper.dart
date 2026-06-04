import '../dto/offer_dto.dart';
import '../models/offer_model.dart';

class OfferMapper {
  static const _typeLabels = {
    'saas': 'SaaS Offer',
    'physical': 'Physical Product',
    'event_pass': 'Event Pass',
    'experience': 'Experience',
    'merchandise': 'Merchandise',
    'course': 'Course',
    'gift_card': 'Gift Card',
  };

  static const _currencySymbols = {'INR': '₹', 'USD': '\$', 'AED': 'AED '};

  static OfferModel fromListItem(OfferListItemDto dto, {String? logoUrl}) {
    return OfferModel(
      id: dto.id,
      brandName: dto.brandName.isNotEmpty ? dto.brandName : dto.brandUsername,
      brandLogoUrl: logoUrl ?? dto.brandLogoUrl ?? '',
      title: dto.title,
      estimatedValueLabel: _formatValue(dto.estimatedValue, dto.currency),
      offerTypeLabel: _typeLabels[dto.type] ?? dto.type,
      verifiedLabel: 'Verified',
      requirementTags: _tagsFromContentAsk(dto.contentAsk),
      heroImageUrl: null,
    );
  }

  static OfferModel fromDetail(OfferDetailDto dto) {
    final hero = dto.images.isNotEmpty ? dto.images.first : dto.brandCoverUrl;
    return OfferModel(
      id: dto.id,
      brandName: dto.brandCompanyName ?? dto.brandName,
      brandLogoUrl: dto.brandLogoUrl ?? hero ?? '',
      title: dto.title,
      estimatedValueLabel: _formatValue(dto.estimatedValue, dto.currency),
      offerTypeLabel: _typeLabels[dto.type] ?? dto.type,
      verifiedLabel: dto.isDrops ? 'Drops' : 'Verified',
      requirementTags: _tagsFromContentAsk(dto.contentAsk),
      heroImageUrl: hero,
      heroSubtitle: dto.description.length > 80
          ? '${dto.description.substring(0, 80)}...'
          : dto.description,
    );
  }

  static String _formatValue(String value, String currency) {
    final sym = _currencySymbols[currency] ?? '$currency ';
    final numVal = double.tryParse(value);
    if (numVal == null) return '$sym$value';
    if (numVal >= 1000) {
      return '$sym${numVal.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          )}';
    }
    return '$sym${numVal.toStringAsFixed(0)}';
  }

  static List<String> _tagsFromContentAsk(Map<String, dynamic> ask) {
    final tags = <String>[];
    final types = ask['types'];
    if (types is List) {
      for (final t in types) {
        tags.add(t.toString());
      }
    }
    final platforms = ask['platforms'];
    if (platforms is List) {
      for (final p in platforms) {
        tags.add(p.toString());
      }
    }
    final count = ask['count'];
    if (count != null) tags.add('${count}x deliverables');
    return tags.isEmpty ? const ['See offer details'] : tags;
  }
}
