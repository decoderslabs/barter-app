import '../dto/analytics_dto.dart';
import '../models/analytics_model.dart';

class AnalyticsMapper {
  static AnalyticsPayload fromDealsAnalytics(DealsAnalyticsDto dto) {
    final kpis = dto.kpis.isNotEmpty
        ? dto.kpis.map(_kpiFromMap).toList()
        : _derivedKpis(dto);

    return AnalyticsPayload(
      contentPerformanceTitle: dto.contentPerformanceTitle.isNotEmpty
          ? dto.contentPerformanceTitle
          : 'Deal performance',
      kpis: kpis,
      reachChartTitle: dto.reachChartTitle,
      reachChart: dto.reachChart.map(_chartPoint).toList(),
      engagementChart: dto.engagementChart.map(_chartPoint).toList(),
      platformBreakdown: dto.platformBreakdown.map(_platformSlice).toList(),
      contentPerformance: dto.contentPerformance.map(_contentRow).toList(),
      topCreators: dto.topCreators.map(_topCreator).toList(),
    );
  }

  static AnalyticsKpiModel _kpiFromMap(Map<String, dynamic> m) {
    final raw = m['value'];
    final value = raw?.toString() ?? '0';
    final trend = m['trend'] as String?;
    return AnalyticsKpiModel(
      id: m['id']?.toString() ?? m['label']?.toString() ?? '',
      label: m['label'] as String? ?? '',
      value: value,
      valueSuffix: m['suffix'] as String?,
      trendLabel: m['trend_label'] as String?,
      trendUp: trend == 'up' ? true : trend == 'down' ? false : null,
      progress: (m['progress'] as num?)?.toDouble(),
    );
  }

  static List<AnalyticsKpiModel> _derivedKpis(DealsAnalyticsDto dto) => [
        AnalyticsKpiModel(id: 'total', label: 'Total deals', value: '${dto.totalDeals}'),
        AnalyticsKpiModel(id: 'active', label: 'Active deals', value: '${dto.activeDeals}', trendUp: dto.activeDeals > 0),
        AnalyticsKpiModel(id: 'completed', label: 'Completed', value: '${dto.completedDeals}'),
        AnalyticsKpiModel(id: 'rate', label: 'Completion rate', value: dto.completionRate.toStringAsFixed(0), valueSuffix: '%', progress: dto.completionRate / 100),
        AnalyticsKpiModel(id: 'recent', label: 'Last 30 days', value: '${dto.recentDeals30Days}', trendLabel: 'new deals'),
      ];

  static AnalyticsChartPoint _chartPoint(Map<String, dynamic> m) => AnalyticsChartPoint(
        label: m['month']?.toString() ?? m['label']?.toString() ?? '',
        value: (m['value'] as num?)?.toDouble() ?? (m['reach'] as num?)?.toDouble() ?? 0,
      );

  static AnalyticsPlatformSlice _platformSlice(Map<String, dynamic> m) => AnalyticsPlatformSlice(
        platform: m['platform'] as String? ?? '',
        percentage: (m['percentage'] as num?)?.toDouble() ?? 0,
        colorHex: m['color'] as String? ?? '#C4A574',
      );

  static AnalyticsContentRow _contentRow(Map<String, dynamic> m) => AnalyticsContentRow(
        title: m['title'] as String? ?? m['content_type'] as String? ?? '',
        reach: m['reach']?.toString() ?? '0',
        engagement: m['engagement_rate']?.toString() ?? '0',
        deals: (m['deals'] as num?)?.toInt() ?? 0,
      );

  static AnalyticsTopCreator _topCreator(Map<String, dynamic> m) => AnalyticsTopCreator(
        name: m['name'] as String? ?? '',
        username: m['username'] as String? ?? '',
        avatarUrl: m['avatar_url'] as String? ?? '',
        deals: (m['deals'] as num?)?.toInt() ?? 0,
        score: (m['barter_score'] as num?)?.toInt() ?? 0,
      );
}
