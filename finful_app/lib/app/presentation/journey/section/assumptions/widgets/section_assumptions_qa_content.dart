import 'package:finful_app/app/constants/images.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/data/model/response/section_response.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/section/assumptions/assumptions.dart';
import 'package:finful_app/app/presentation/journey/section/assumptions/widgets/charts/section_assumptions_barchart1.dart';
import 'package:finful_app/app/presentation/journey/section/assumptions/widgets/section_assumptions_option_card.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/presentation/widgets/section/section_options_wrapper.dart';
import 'package:finful_app/app/presentation/widgets/section/section_qa_content_loading.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/app/theme/dimens.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'charts/section_assumptions_linechart1.dart';
import 'section_assumptions_calculate_result.dart';

class SectionAssumptionsQAContent extends StatelessWidget {
  const SectionAssumptionsQAContent({
    super.key,
    required this.sliderValueSelected,
    required this.onSliderValueChanged,
    required this.radioValueSelected,
    required this.onRadioValueChanged,
    required this.hasUserChanged,
  });

  final int sliderValueSelected;
  final Function(int value) onSliderValueChanged;
  final SectionPayloadOptionResponse? radioValueSelected;
  final Function(SectionPayloadOptionResponse option) onRadioValueChanged;
  final bool hasUserChanged;

  int? getDivisions(double min, double max) {
    final diff = (max - min).abs();
    if (diff <= 1) return null;
    return diff.toInt();
  }

  List<FlSpot> allSpots(bool isSalary, int chartDefaultValue) {
    final double dummy = isSalary ? 30000000 : 3000000000;
    final double rate = chartDefaultValue / 100;  // phần trăm → tỷ lệ (0.02 cho 2%)
    // Năm hiện tại = dummy * (1 + rate)^0 = dummy
    // Năm ngoái = dummy / (1 + rate) nếu rate > 0, hoặc dummy nếu rate = 0
    // +1 = dummy * (1 + rate)
    // +2 = dummy * (1 + rate)^2
    // +3 = dummy * (1 + rate)^3
    final double yearMinus1 = rate == 0 ? dummy : dummy / (1 + rate);
    final double year0 = dummy;
    final double yearPlus1 = dummy * (1 + rate);
    final double yearPlus2 = yearPlus1 * (1 + rate);
    final double yearPlus3 = yearPlus2 * (1 + rate);
    return [
      FlSpot(0, yearMinus1),  // năm ngoái
      FlSpot(1, year0),       // năm nay
      FlSpot(2, yearPlus1),   // +1
      FlSpot(3, yearPlus2),   // +2
      FlSpot(4, yearPlus3),   // +3
    ];
  }

  Widget _renderSliderContent(BuildContext context, SectionModel data) {
    final questionTxt = data.section.payload?.label ?? "";
    final listExplanations = data.section.payload?.explanations ??
        <SectionPayloadExplanationResponse>[];
    final minValue = data.section.payload?.min ?? 0;
    final maxValue = data.section.payload?.max ?? 100;
    final chartDataKey = data.section.payload?.chartDataKey;
    final isSalary = chartDataKey == "pctSalaryGrowth";
    final isHousePrice = chartDataKey == "pctHouseGrowth";
    final showLineChart = isSalary || isHousePrice;
    final showBarChart = chartDataKey == "pctInvestmentReturn";
    final divisionsValue = getDivisions(
        minValue.toDouble(), maxValue.toDouble());
    final chartLegendTitle = !isSalary ?
    L10n.of(context).translate('section_chart_dot_housePrice_label') :
    L10n.of(context).translate('section_chart_dot_salary_label');
    int chartDefaultValue = 0;
    if (!hasUserChanged) {
      final defaultValue = data.section.payload?.defaultValue;
      if (defaultValue != null && defaultValue > 0) {
        chartDefaultValue = defaultValue;
      }
    } else {
      if (showLineChart) {
        chartDefaultValue = sliderValueSelected;
      } else if (showBarChart) {
        chartDefaultValue = sliderValueSelected;
      }
    }

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: FinfulDimens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimens.p_56),
          Text(
            questionTxt,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: Dimens.p_27),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    padding: EdgeInsets.zero,
                    trackHeight: Dimens.p_8,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: Dimens.p_14),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: Dimens.p_24),
                    activeTrackColor: FinfulColor.sliderActiveTrack,
                    inactiveTrackColor: FinfulColor.sliderInactiveTrack,
                    thumbColor: FinfulColor.sliderThumbColor,
                    overlayColor: FinfulColor.sliderOverlayColor,
                  ),
                  child: Slider(
                    value: sliderValueSelected.toDouble(),
                    min: minValue.toDouble(),
                    max: maxValue.toDouble(),
                    divisions: divisionsValue,
                    onChanged: (newValue) {
                      final formattedValue = newValue.round();
                      onSliderValueChanged.call(formattedValue);
                    },
                  ),
                ),
              ),
              const SizedBox(width: Dimens.p_14),
              Text(
                "${sliderValueSelected.toInt()}%",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: Dimens.p_20,
                  height: Dimens.p_20 / Dimens.p_20,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.p_34),
          if (showLineChart) SectionAssumptionsLineChart1(
            spots: allSpots(isSalary, chartDefaultValue),
            title: chartLegendTitle,
          ) else const SizedBox(),
          if (showBarChart) SectionAssumptionsBarchart1(
            chartDefaultValue: chartDefaultValue,
          ) else const SizedBox(),
          const SizedBox(height: Dimens.p_40),
          if (listExplanations.isNotEmpty)
            Column(
              children: listExplanations.map((explanation) {
                if (explanation.main.isNotNullAndEmpty ||
                    explanation.sub.isNotNullAndEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.p_12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (explanation.sub.isNotNullAndEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: Dimens.p_10,
                            ),
                            child: Text(
                              explanation.sub!,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: FinfulColor.brandPrimary,
                                height: Dimens.p_17 / Dimens.p_12,
                              ),
                            ),
                          ),
                        if (explanation.main.isNotNullAndEmpty)
                          Text(
                            explanation.main!,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              height: Dimens.p_17 / Dimens.p_12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              }).toList(),
            ) else const SizedBox(),
        ],
      ),
    );
  }

  Widget _renderRadioContent(BuildContext context, SectionModel data) {
    final questionTxt = data.section.payload?.title ??
        data.section.payload?.label ?? "";
    final listOption = data.section.payload?.options ??
        <SectionPayloadOptionResponse>[];
    final listExplanations = data.section.payload?.explanations ??
        <SectionPayloadExplanationResponse>[];

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: FinfulDimens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimens.p_16),
          Container(
            decoration: BoxDecoration(
              color: FinfulColor.cardBg,
              borderRadius: BorderRadius.all(
                  Radius.circular(FinfulDimens.radiusLg)),
            ),
            padding: EdgeInsets.symmetric(
              vertical: Dimens.p_10,
              horizontal: Dimens.p_24,
            ),
            child: Center(
              child: Column(
                children: [
                  FinfulImage(
                    type: FinfulImageType.asset,
                    source: ImageConstants.imgAssumptionsIncrease,
                    width: Dimens.p_53,
                    height: Dimens.p_53,
                  ),
                  const SizedBox(height: Dimens.p_15),
                  if (listExplanations.isNotEmpty)
                    Column(
                      children: listExplanations.map((explanation) {
                        if (explanation.main.isNotNullAndEmpty ||
                        explanation.sub.isNotNullAndEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: Dimens.p_12),
                            child: Column(
                              children: [
                                if (explanation.main.isNotNullAndEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: Dimens.p_10,
                                    ),
                                    child: Text(
                                      explanation.main!,
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        fontSize: Dimens.p_13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                if (explanation.sub.isNotNullAndEmpty)
                                  Text(
                                    explanation.sub!,
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      fontSize: Dimens.p_13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          );
                        }

                        return const SizedBox();
                      }).toList(),
                    ) else const SizedBox(),
                ],
              ),
            ),
          ),
          const SizedBox(height: Dimens.p_24),
          Text(
            questionTxt,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              height: Dimens.p_25 / Dimens.p_16,
            ),
          ),
          const SizedBox(height: Dimens.p_10),
          if (listOption.isNotEmpty)
            SectionOptionsWrapper(
              itemCount: listOption.length,
              itemBuilder: (context, index, animation) {
                final option = listOption[index];
                final isSelected = radioValueSelected != null &&
                    radioValueSelected!.value == option.value;
                return SectionOptionWrapperItem(
                  animation: animation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.p_12),
                    child: SectionAssumptionsOptionCard(
                      headerTitle: option.title ?? "",
                      leftTitle: option.targetReturn ?? "",
                      rightLabel: option.sub ?? "",
                      rightTitle: option.description ?? "",
                      isSelected: isSelected,
                      onPressed: () {
                        onRadioValueChanged.call(option);
                      },
                    ),
                  ),
                );
              },
            ) else const SizedBox(),
        ],
      ),
    );
  }

  Widget _renderContent(
      BuildContext context,
      SectionModel data,
      AssumptionsState state) {
    final stepType = SectionStepTypeExt.fromValue(data.section.stepType);
    if (state is AssumptionsGetNextStepInProgress) {
      return SectionQaContentLoading();
    } else if (state is AssumptionsCalculateFailure) {
      return SectionQaContentLoading();
    } else {
      if (stepType == SectionStepType.question) {
        final quesType = SectionQuestionTypeExt.fromValue(
            data.section.payload?.questionType);
        switch (quesType) {
          case SectionQuestionType.radio:
            return _renderRadioContent(context, data);
          case SectionQuestionType.slider:
            return _renderSliderContent(context, data);
          default:
            return const SizedBox();
        }
      } else if (stepType == SectionStepType.Final) {
        return const SectionAssumptionsCalculateResult();
      } else {
        return const SizedBox();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssumptionsBloc, AssumptionsState>(
      builder: (_, state) {
        if (state.sectionAssumptions.isEmpty) {
          return const SectionQaContentLoading();
        }

        final currentSection = state.sectionAssumptions.last;
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          child: _renderContent(context, currentSection, state),
        );
      },
    );
  }
}
