import 'package:finful_app/app/constants/images.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/theme/theme.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/extension/context_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SectionAssumptionsBarchart1 extends StatefulWidget {
  const SectionAssumptionsBarchart1({super.key});

  @override
  State<SectionAssumptionsBarchart1> createState() => _SectionAssumptionsBarchart1State();
}

class _SectionAssumptionsBarchart1State extends State<SectionAssumptionsBarchart1> {
  final List<double> salary = const [1.2, 1.3, 1.4];
  final List<double> borrow = const [1.8, 2.0, 2.3];
  final List<double> totalLine = const [3.0, 3.3, 3.7];

  final int startYear = DateTime.now().year; // current year

  double get chartContainerWidth => context.queryWidth;

  double get chartContainerHeight => chartContainerWidth * 0.8575;

  Widget _legendItem(
      BuildContext context,
      Color color,
      String text,
      bool showImage) {
    return Row(
      children: [
        if (!showImage)
          Container(
            width: Dimens.p_10,
            height: Dimens.p_10,
            color: Colors.white,
            margin: EdgeInsets.all(Dimens.p_4),
            padding: EdgeInsets.all(Dimens.p_1),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: color,
            ),
          ) else FinfulImage(
          type: FinfulImageType.asset,
          source: ImageConstants.imgBarChartDot,
          width: Dimens.p_16,
          height: Dimens.p_16,
        ),
        const SizedBox(width: Dimens.p_4),
        Text(
          text,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: FinfulColor.barChartText,
            height: Dimens.p_15 / Dimens.p_12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartMaxY = totalLine.reduce((a, b) => a > b ? a : b) * 1.1;
    const chartMinY = 0.0;

    const lineChartMinX = -0.9;
    const lineChartMaxX = 2.7;

    const int dashValue = 4;

    final leftAxisTitles = AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            return SideTitleWidget(
              meta: meta,
              child: Text(
                '${value.toInt()}',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: FinfulColor.barChartText,
                  height: Dimens.p_15 / Dimens.p_12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        )
    );

    final bottomAxisTitles = AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final years = [startYear, startYear + 1, startYear + 2];
          return Padding(
            padding: EdgeInsets.only(
              top: Dimens.p_5,
            ),
            child: Text(
              "${years[value.toInt()]}",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: FinfulColor.barChartText,
                height: Dimens.p_15 / Dimens.p_12,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );

    final barChartExtraLinesData = ExtraLinesData(
      extraLinesOnTop: false,
      horizontalLines: [
        HorizontalLine(
          y: chartMinY,
          color: FinfulColor.barChartDot,
          strokeWidth: Dimens.p_1,
        ),
        HorizontalLine(
          y: chartMaxY,
          color: FinfulColor.barChartDot,
          strokeWidth: Dimens.p_1,
          dashArray: [dashValue, dashValue],
        ),
      ],
    );
    final gridLineNormal = FlLine(
      color: FinfulColor.barChartDot,
      strokeWidth: Dimens.p_1,
      dashArray: [dashValue, dashValue],
    );
    final barChartGridData = FlGridData(
      show: true,
      drawHorizontalLine: true,
      drawVerticalLine: false,
      horizontalInterval: chartMaxY / 4,
      getDrawingHorizontalLine: (_) => gridLineNormal,
    );
    final barChartTitlesData = FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: leftAxisTitles,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: bottomAxisTitles,
    );
    final barChartBarGroups = List.generate(3, (i) => BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: salary[i] + borrow[i],
          width: Dimens.p_60,
          borderRadius: BorderRadius.zero,
          rodStackItems: [
            BarChartRodStackItem(
              0, salary[i], FinfulColor.brandPrimary,
              borderSide: BorderSide.none,
              label: "${salary[i]}",
              labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: FinfulColor.black12,
                height: Dimens.p_15 / Dimens.p_12,
                fontWeight: FontWeight.w400,
              ),
            ),
            BarChartRodStackItem(
              salary[i], salary[i] + borrow[i], FinfulColor.barChartContentBorrow,
              borderSide: BorderSide.none,
              label: "${borrow[i]}",
              labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: FinfulColor.black12,
                height: Dimens.p_15 / Dimens.p_12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    ));

    final lineChartDotData = FlDotData(
      show: true,
      getDotPainter: (spot, percent, bar, index) =>
          FlDotCirclePainter(
            radius: Dimens.p_6,
            color: Colors.white,
            strokeColor: Colors.white,
            strokeWidth: Dimens.p_0,
          ),
    );
    final lineChartLineBarsData = [
      LineChartBarData(
        spots: totalLine.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
        isCurved: true,
        curveSmoothness: 0.3,
        color: Colors.white,
        barWidth: Dimens.p_2,
        dotData: lineChartDotData,
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
    final showingTooltipIndicators = totalLine.asMap().entries.map((e) {
      final flSpotItem = FlSpot(e.key.toDouble(), e.value);
      return ShowingTooltipIndicators([
        LineBarSpot(
          LineChartBarData(
            spots: [flSpotItem],
          ),
          0,
          flSpotItem,
        ),
      ]);
    }).toList();
    final lineChartLineTouchData = LineTouchData(
      enabled: true,
      handleBuiltInTouches: false,
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            const FlLine(
              color: Colors.transparent,
            ),
            lineChartDotData,
          );
        }).toList();
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (LineBarSpot touchedSpot) => Colors.transparent,
        tooltipPadding: EdgeInsets.only(
          bottom: Dimens.p_4 + Dimens.p_6,
        ),
        tooltipMargin: Dimens.p_0,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            return LineTooltipItem(
              '${spot.y}',
              Theme.of(context).textTheme.titleLarge!.copyWith(
                color: FinfulColor.barChartText,
                height: Dimens.p_15 / Dimens.p_12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            );
          }).toList();
        },
      ),
    );
    final lineChartExtraLinesData = ExtraLinesData(
      horizontalLines: [],
      verticalLines: [],
    );
    final lineChartTitlesData = FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );

    return Container(
      width: chartContainerWidth,
      height: chartContainerHeight,
      padding: const EdgeInsets.symmetric(
        vertical:  Dimens.p_16,
        horizontal: Dimens.p_16,
      ),
      decoration: BoxDecoration(color: FinfulColor.cardBg),
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.5943,
              child: Stack(
                children: [
                  // 1. Bar Chart
                  BarChart(
                    BarChartData(
                      backgroundColor: Colors.transparent,
                      alignment: BarChartAlignment.spaceEvenly,
                      maxY: chartMaxY,
                      minY: chartMinY,
                      gridData: barChartGridData,
                      borderData: FlBorderData(show: false),
                      extraLinesData: barChartExtraLinesData,
                      titlesData: barChartTitlesData,
                      barGroups: barChartBarGroups,
                      barTouchData: BarTouchData(
                        enabled: false,
                      ),
                    ),
                  ),

                  // 2. Line Chart (chỉ vẽ line + dot + số)
                  LineChart(
                    LineChartData(
                      showingTooltipIndicators: showingTooltipIndicators,
                      lineBarsData: lineChartLineBarsData,
                      extraLinesData: lineChartExtraLinesData,
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: lineChartTitlesData,
                      lineTouchData: lineChartLineTouchData,
                      minX: lineChartMinX,
                      maxX: lineChartMaxX,
                      minY: chartMinY,
                      maxY: chartMaxY,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Dimens.p_12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem(
                context,
                FinfulColor.brandPrimary,
                'Tích lũy',
                false,
              ),
              const SizedBox(width: Dimens.p_12),
              _legendItem(
                context,
                FinfulColor.barChartContentBorrow,
                'Đi vay',
                false,
              ),
              const SizedBox(width: Dimens.p_12),
              _legendItem(
                context,
                Colors.white,
                'Giá nhà',
                true,
              ),
            ],
          ),
          const SizedBox(height: Dimens.p_12),
        ],
      ),
    );
  }
}