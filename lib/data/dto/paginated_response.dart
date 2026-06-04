class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  final int count;
  final List<T> results;
  final String? next;
  final String? previous;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final raw = json['results'] as List<dynamic>? ?? const [];
    return PaginatedResponse(
      count: (json['count'] as num?)?.toInt() ?? raw.length,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: raw
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
