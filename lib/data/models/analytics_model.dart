import 'package:flutter/material.dart';

class AnalyticsKpiModel {
  const AnalyticsKpiModel({
    required this.id,
    required this.label,
    required this.value,
    this.valueSuffix,
    this.trendLabel,
    this.trendUp,
    this.progress,
  });

  final String id;
  final String label;
  final String value;
  final String? valueSuffix;
  final String? trendLabel;
  final bool? trendUp;
  final double? progress;

  factory AnalyticsKpiModel.fromJson(Map<String, dynamic> j) {
    return AnalyticsKpiModel(
      id: j['id'] as String,
      label: j['label'] as String,
      value: j['value'] as String,
      valueSuffix: j['valueSuffix'] as String?,
      trendLabel: j['trendLabel'] as String?,
      trendUp: j['trendUp'] as bool?,
      progress: (j['progress'] as num?)?.toDouble(),
    );
  }
}

class AnalyticsChartPoint {
  const AnalyticsChartPoint({required this.label, required this.value});
  final String label;
  final double value;
}

class AnalyticsPlatformSlice {
  const AnalyticsPlatformSlice({required this.platform, required this.percentage, required this.colorHex});
  final String platform;
  final double percentage;
  final String colorHex;
}

class AnalyticsContentRow {
  const AnalyticsContentRow({required this.title, required this.reach, required this.engagement, required this.deals});
  final String title;
  final String reach;
  final String engagement;
  final int deals;
}

class AnalyticsTopCreator {
  const AnalyticsTopCreator({required this.name, required this.username, required this.avatarUrl, required this.deals, required this.score});
  final String name;
  final String username;
  final String avatarUrl;
  final int deals;
  final int score;
}

class AnalyticsPayload {
  const AnalyticsPayload({
    required this.kpis,
    required this.contentPerformanceTitle,
    this.reachChartTitle = '',
    this.reachChart = const [],
    this.engagementChart = const [],
    this.platformBreakdown = const [],
    this.contentPerformance = const [],
    this.topCreators = const [],
  });

  final List<AnalyticsKpiModel> kpis;
  final String contentPerformanceTitle;
  final String reachChartTitle;
  final List<AnalyticsChartPoint> reachChart;
  final List<AnalyticsChartPoint> engagementChart;
  final List<AnalyticsPlatformSlice> platformBreakdown;
  final List<AnalyticsContentRow> contentPerformance;
  final List<AnalyticsTopCreator> topCreators;

  factory AnalyticsPayload.fromJson(Map<String, dynamic> j) {
    return AnalyticsPayload(
      kpis: (j['kpis'] as List<dynamic>)
          .map((e) => AnalyticsKpiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      contentPerformanceTitle: j['contentPerformanceTitle'] as String? ?? '',
    );
  }
}

Color parseHexColor(String hex) {
  var s = hex.replaceFirst('#', '');
  if (s.length == 6) s = 'FF$s';
  return Color(int.parse(s, radix: 16));
}
