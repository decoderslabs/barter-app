class DealsAnalyticsDto {
  const DealsAnalyticsDto({
    required this.totalDeals,
    required this.activeDeals,
    required this.completedDeals,
    required this.completionRate,
    this.avgDealValue,
    this.recentDeals30Days = 0,
    this.kpis = const [],
    this.reachChartTitle = '',
    this.reachChart = const [],
    this.engagementChart = const [],
    this.platformBreakdown = const [],
    this.contentPerformanceTitle = '',
    this.contentPerformance = const [],
    this.topCreators = const [],
  });

  final int totalDeals;
  final int activeDeals;
  final int completedDeals;
  final double completionRate;
  final dynamic avgDealValue;
  final int recentDeals30Days;
  final List<Map<String, dynamic>> kpis;
  final String reachChartTitle;
  final List<Map<String, dynamic>> reachChart;
  final List<Map<String, dynamic>> engagementChart;
  final List<Map<String, dynamic>> platformBreakdown;
  final String contentPerformanceTitle;
  final List<Map<String, dynamic>> contentPerformance;
  final List<Map<String, dynamic>> topCreators;

  factory DealsAnalyticsDto.fromJson(Map<String, dynamic> json) => DealsAnalyticsDto(
        totalDeals: _parseInt(json['total_deals']),
        activeDeals: _parseInt(json['active_deals']),
        completedDeals: _parseInt(json['completed_deals']),
        completionRate: _parseDouble(json['completion_rate']),
        avgDealValue: json['avg_deal_value'],
        recentDeals30Days: _parseInt(json['recent_deals_30_days']),
        kpis: _parseListOfMaps(json['kpis']),
        reachChartTitle: json['reach_chart_title'] as String? ?? '',
        reachChart: _parseListOfMaps(json['reach_chart']),
        engagementChart: _parseListOfMaps(json['engagement_chart']),
        platformBreakdown: _parseListOfMaps(json['platform_breakdown']),
        contentPerformanceTitle: json['content_performance_title'] as String? ?? '',
        contentPerformance: _parseListOfMaps(json['content_performance']),
        topCreators: _parseListOfMaps(json['top_creators']),
      );

  static List<Map<String, dynamic>> _parseListOfMaps(dynamic value) {
    if (value is List) {
      return value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return const [];
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
