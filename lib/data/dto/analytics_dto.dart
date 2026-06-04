class DealsAnalyticsDto {
  const DealsAnalyticsDto({
    required this.totalDeals,
    required this.activeDeals,
    required this.completedDeals,
    required this.completionRate,
    this.avgDealValue,
    this.recentDeals30Days = 0,
  });

  final int totalDeals;
  final int activeDeals;
  final int completedDeals;
  final double completionRate;
  final dynamic avgDealValue;
  final int recentDeals30Days;

  factory DealsAnalyticsDto.fromJson(Map<String, dynamic> json) => DealsAnalyticsDto(
        totalDeals: _parseInt(json['total_deals']),
        activeDeals: _parseInt(json['active_deals']),
        completedDeals: _parseInt(json['completed_deals']),
        completionRate: _parseDouble(json['completion_rate']),
        avgDealValue: json['avg_deal_value'],
        recentDeals30Days: _parseInt(json['recent_deals_30_days']),
      );

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
