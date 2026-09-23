import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../home/presentation/theme/dashboard_colors.dart';
import '../../../home/presentation/theme/dashboard_text_styles.dart';
import '../../domain/models/daily_totals.dart';

/// One Trends chart card: a title, an "avg / target" subline, and an
/// fl_chart line chart with a dashed target reference line and tap
/// tooltips. No axis labels or "Target" text, matching the Trends.dc.html
/// design. Reused once for Calories and once per macro.
class TrendsLineChartCard extends StatelessWidget {
  const TrendsLineChartCard({
    required this.title,
    required this.color,
    required this.dailyTotals,
    required this.valueOf,
    required this.target,
    required this.average,
    required this.unit,
    super.key,
  });

  final String title;
  final Color color;
  final List<DailyTotals> dailyTotals;
  final double Function(DailyTotals) valueOf;
  final double target;
  final double average;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final spots = [
      for (var i = 0; i < dailyTotals.length; i++)
        FlSpot(i.toDouble(), valueOf(dailyTotals[i])),
    ];
    final highest = spots.fold<double>(
      target,
      (max, spot) => spot.y > max ? spot.y : max,
    );
    final maxY = highest <= 0 ? 1.0 : highest * 1.08;
    // Calories uses the neutral text color (it's the odd one out with no
    // legend dot); the macro/water cards pass their own series color.
    final showLegendDot = color != DashboardColors.textPrimary;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLegendDot) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(title, style: DashboardTextStyles.macroName),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Avg ${_formatValue(average)}$unit/day · Target ${_formatValue(target)}$unit',
            style: DashboardTextStyles.macroNums.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 108,
            child: spots.length < 2
                ? const SizedBox.shrink()
                : LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: (spots.length - 1).toDouble(),
                      minY: 0,
                      maxY: maxY,
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: target,
                            color: color.withValues(alpha: 0.4),
                            strokeWidth: 1.5,
                            dashArray: const [4, 4],
                          ),
                        ],
                      ),
                      lineTouchData: LineTouchData(
                        // Default threshold (10px) only registers a touch
                        // within a few pixels of the dot itself. The
                        // distance calculator already only looks at the x
                        // axis (fl_chart's default), so raising the
                        // threshold makes the whole vertical column above a
                        // day tappable, not just the dot.
                        touchSpotThreshold: double.infinity,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (_) =>
                              DashboardColors.tooltipBackground,
                          getTooltipItems: (touchedSpots) => [
                            for (final spot in touchedSpots)
                              LineTooltipItem(
                                '${_formatValue(spot.y)}$unit',
                                DashboardTextStyles.tooltipBody.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                          ],
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          color: color,
                          barWidth: 2.5,
                          // Dots read fine at 7 days but overlap into a mess
                          // once the chart has to fit weeks or months of
                          // points into 306px — the line + area fill already
                          // carry the trend, and the tap-anywhere tooltip
                          // (touchSpotThreshold above) doesn't depend on them.
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                color.withValues(alpha: 0.18),
                                color.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

String _formatValue(double value) {
  return value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}
