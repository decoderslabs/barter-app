import '../dto/analytics_dto.dart';
import '../models/analytics_model.dart';

class AnalyticsMapper {
  static AnalyticsPayload fromDealsAnalytics(DealsAnalyticsDto dto) {
    return AnalyticsPayload(
      contentPerformanceTitle: 'Deal performance',
      kpis: [
        AnalyticsKpiModel(
          id: 'total',
          label: 'Total deals',
          value: '${dto.totalDeals}',
        ),
        AnalyticsKpiModel(
          id: 'active',
          label: 'Active deals',
          value: '${dto.activeDeals}',
          trendUp: dto.activeDeals > 0,
        ),
        AnalyticsKpiModel(
          id: 'completed',
          label: 'Completed',
          value: '${dto.completedDeals}',
        ),
        AnalyticsKpiModel(
          id: 'rate',
          label: 'Completion rate',
          value: '${dto.completionRate.toStringAsFixed(0)}',
          valueSuffix: '%',
          progress: dto.completionRate / 100,
        ),
        AnalyticsKpiModel(
          id: 'recent',
          label: 'Last 30 days',
          value: '${dto.recentDeals30Days}',
          trendLabel: 'new deals',
        ),
      ],
    );
  }
}
