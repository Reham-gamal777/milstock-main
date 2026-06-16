import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../../core/localization/app_localizations.dart';

class StockChart extends StatelessWidget {
  final bool isArabic;

  const StockChart({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(isArabic);
    final days = [
      loc.translate('mon'),
      loc.translate('tue'),
      loc.translate('wed'),
      loc.translate('thu'),
      loc.translate('fri'),
      loc.translate('sat'),
      loc.translate('sun'),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: AppColors.borderLight,
              strokeWidth: 0.8,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              getTitlesWidget: (value, meta) {
                if (value >= 60 && value <= 100) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text(
                      '${value.toInt()}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
              reservedSize: 32,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < days.length) {
                  return SideTitleWidget(
                    meta: meta,
                    space: 8,
                    child: Text(
                      days[index],
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: 6,
        minY: 60,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 88), // Mon
              FlSpot(1, 84), // Tue
              FlSpot(2, 80), // Wed
              FlSpot(3, 85), // Thu
              FlSpot(4, 82), // Fri
              FlSpot(5, 78), // Sat
              FlSpot(6, 75), // Sun
            ],
            isCurved: true,
            color: AppColors.secondaryGreen,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.secondaryGreen,
                  strokeWidth: 2,
                  strokeColor: AppColors.cardBg,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.secondaryGreen.withOpacity(0.3),
                  AppColors.secondaryGreen.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
