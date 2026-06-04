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

class AnalyticsPayload {
  const AnalyticsPayload({
    required this.kpis,
    required this.contentPerformanceTitle,
  });

  final List<AnalyticsKpiModel> kpis;
  final String contentPerformanceTitle;

  factory AnalyticsPayload.fromJson(Map<String, dynamic> j) {
    return AnalyticsPayload(
      kpis: (j['kpis'] as List<dynamic>)
          .map((e) => AnalyticsKpiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      contentPerformanceTitle: j['contentPerformanceTitle'] as String,
    );
  }
}

Color parseHexColor(String hex) {
  var s = hex.replaceFirst('#', '');
  if (s.length == 6) s = 'FF$s';
  return Color(int.parse(s, radix: 16));
}
