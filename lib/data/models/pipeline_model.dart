class PipelineCardModel {
  const PipelineCardModel({
    required this.creatorName,
    required this.offerTitle,
    required this.tags,
    required this.brandInitial,
  });

  final String creatorName;
  final String offerTitle;
  final List<String> tags;
  final String brandInitial;

  factory PipelineCardModel.fromJson(Map<String, dynamic> j) {
    return PipelineCardModel(
      creatorName: j['creatorName'] as String,
      offerTitle: j['offerTitle'] as String,
      tags: (j['tags'] as List<dynamic>).map((e) => e as String).toList(),
      brandInitial: j['brandInitial'] as String,
    );
  }
}

class PipelineColumnModel {
  const PipelineColumnModel({
    required this.id,
    required this.title,
    required this.accentHex,
    required this.cards,
  });

  final String id;
  final String title;
  final String accentHex;
  final List<PipelineCardModel> cards;

  factory PipelineColumnModel.fromJson(Map<String, dynamic> j) {
    return PipelineColumnModel(
      id: j['id'] as String,
      title: j['title'] as String,
      accentHex: j['accentHex'] as String,
      cards: (j['cards'] as List<dynamic>)
          .map((e) => PipelineCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PipelinePayload {
  const PipelinePayload({required this.columns});

  final List<PipelineColumnModel> columns;

  factory PipelinePayload.fromJson(Map<String, dynamic> j) {
    return PipelinePayload(
      columns: (j['columns'] as List<dynamic>)
          .map((e) => PipelineColumnModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
