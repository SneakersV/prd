import 'package:finful_app/app/constants/constants.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/theme/theme.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/extension/context_extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _CustomGlowDotPainter extends FlDotPainter {
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    // Glow layer 1
    canvas.drawCircle(
      offsetInCanvas,
      12.0,
      Paint()..color = FinfulColor.dotGlowLayer1,
    );

    // Core
    canvas.drawCircle(
      offsetInCanvas,
      5.0,
      Paint()..color = FinfulColor.brandPrimary,
    );

    // Viền den (stroke)
    canvas.drawCircle(
      offsetInCanvas,
      6.0,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  Size getSize(FlSpot spot) => const Size(12.0, 12.0);

  @override
  Color get mainColor => const Color(0xFF00E0FF);

  @override
  List<Object?> get props => [
    mainColor,
  ];

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    return this;
  }
}

class SectionAssumptionsLineChart1 extends StatefulWidget {
  const SectionAssumptionsLineChart1({
    super.key,
    required this.spots,

  });

  final List<FlSpot> spots;

  @override
  State<SectionAssumptionsLineChart1> createState() => _SectionAssumptionsLineChart1State();
}


class _SectionAssumptionsLineChart1State extends State<SectionAssumptionsLineChart1> {
  final int startYear = DateTime.now().year - 1; // last year

  double get chartContainerWidth => context.queryWidth;

  double get chartContainerHeight => chartContainerWidth * 0.7575;

  @override
  Widget build(BuildContext context) {
    final visibleSpots = [widget.spots[1], widget.spots[2], widget.spots[3]];

    final lineTouchData = LineTouchData(
      enabled: true,
      handleBuiltInTouches: false,
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            const FlLine(
              color: Colors.transparent,
            ),
            FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) =>
                  _CustomGlowDotPainter(),
            ),
          );
        }).toList();
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (LineBarSpot touchedSpot) => Colors.transparent,
        tooltipPadding: EdgeInsets.only(
          bottom: Dimens.p_4 + Dimens.p_12,
        ),
        tooltipMargin: Dimens.p_0,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final moneyText = NumberFormat.currency(
              locale: 'vi_VN',
              symbol: '',
              decimalDigits: 0,
            ).format(spot.y);

            return LineTooltipItem(
              moneyText,
              Theme.of(context).textTheme.titleLarge!.copyWith(
                height: Dimens.p_15 / Dimens.p_12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            );
          }).toList();
        },
      ),
    );

    final lineBarsData = [
      LineChartBarData(
        spots: [widget.spots.first],
        isCurved: true,
        curveSmoothness: 0.3,
        color: Colors.transparent,
        barWidth: Dimens.p_2,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: visibleSpots,
        isCurved: true,
        curveSmoothness: 0.3,
        color: FinfulColor.brandPrimary,
        barWidth: Dimens.p_2,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, bar, index) {
            return _CustomGlowDotPainter();
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              FinfulColor.brandPrimary.withValues(alpha: 0.3),
              FinfulColor.brandPrimary.withValues(alpha: 0.05),
            ],
            stops: const [0.3, 1.0],
          ),
        ),
      ),
      LineChartBarData(
        spots: [widget.spots.last],
        isCurved: true,
        curveSmoothness: 0.3,
        color: Colors.transparent,
        barWidth: Dimens.p_2,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];

    final titlesData = FlTitlesData(
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            if (value < 1 || value > 3) {
              return const SizedBox();
            }

            final index = value.toInt();
            return Padding(
              padding: EdgeInsets.only(
                top: Dimens.p_5,
              ),
              child: Text(
                '${startYear + index}',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  height: Dimens.p_15 / Dimens.p_12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ),
      ),
    );

    const int dashValue = 4;

    final gridLineNormal = FlLine(
      color: FinfulColor.dotGlowLayer1,
      strokeWidth: Dimens.p_1,
      dashArray: [dashValue, dashValue],
    );
    final gridLineHide = FlLine(
      color: Colors.transparent,
      strokeWidth: Dimens.p_1,
      dashArray: [dashValue, dashValue],
    );
    final gridData = FlGridData(
      show: true,
      drawHorizontalLine: true,
      drawVerticalLine: true,
      horizontalInterval: widget.spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) / 4,
      getDrawingVerticalLine: (value) {
        if (value == 1.5 || value == 2.5) {
          return gridLineNormal;
        }
        return gridLineHide;
      },
      getDrawingHorizontalLine: (_) => gridLineNormal,
    );

    final borderData = FlBorderData(
      show: false,
    );

    const double minX = 0.5;
    const double maxX = 3.5;
    const double minY = 0.0;
    final double maxY = widget.spots.last.y;
    final extraLinesData = ExtraLinesData(
      horizontalLines: [
        HorizontalLine(
          y: minY,
          color: FinfulColor.dotGlowLayer1,
          strokeWidth: Dimens.p_1,
        ),
        HorizontalLine(
          y: maxY,
          color: FinfulColor.dotGlowLayer1,
          strokeWidth: Dimens.p_1,
          dashArray: [dashValue, dashValue],
        ),
      ],
      verticalLines: [
        VerticalLine(
          x: minX,
          color: FinfulColor.dotGlowLayer1,
          strokeWidth: Dimens.p_1,
          dashArray: [dashValue, dashValue],
        ),
        VerticalLine(
          x: maxX,
          color: FinfulColor.dotGlowLayer1,
          strokeWidth: Dimens.p_1,
          dashArray: [dashValue, dashValue],
        ),
      ],
    );

    final showingTooltipIndicators = [1, 2, 3].map((globalIndex) {
      final barIndex = 1;
      final localIndex = globalIndex - 1; // 1→0, 2→1, 3→2 trong visibleSpots
      return ShowingTooltipIndicators([
        LineBarSpot(
          lineBarsData[barIndex],
          barIndex,
          lineBarsData[barIndex].spots[localIndex],
        ),
      ]);
    }).toList();

    return Container(
      width: chartContainerWidth,
      height: chartContainerHeight,
      decoration: BoxDecoration(
        color: FinfulColor.cardBg,
      ),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.p_16,
        horizontal: Dimens.p_16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 1.5718,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return LineChart(
                    LineChartData(
                      showingTooltipIndicators: showingTooltipIndicators,
                      lineTouchData: lineTouchData,
                      lineBarsData: lineBarsData,
                      titlesData: titlesData,
                      gridData: gridData,
                      borderData: borderData,
                      extraLinesData: extraLinesData,
                      minY: minY,
                      maxY: maxY,
                      minX: minX,
                      maxX: maxX,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: Dimens.p_12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FinfulImage(
                type: FinfulImageType.asset,
                source: ImageConstants.imgChartDot,
                width: Dimens.p_16,
                height: Dimens.p_16,
              ),
              const SizedBox(width: Dimens.p_4),
              Text(
                L10n.of(context)
                    .translate('section_chart_dot_salary_label'),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  height: Dimens.p_15 / Dimens.p_12,
                  fontWeight: FontWeight.w400,
                )
              ),
            ],
          ),
          const SizedBox(height: Dimens.p_12),
        ],
      ),
    );
  }
}
