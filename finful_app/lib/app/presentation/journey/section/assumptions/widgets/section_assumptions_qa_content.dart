import 'package:finful_app/app/constants/images.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/data/model/response/section_response.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/section/assumptions/assumptions.dart';
import 'package:finful_app/app/presentation/journey/section/assumptions/widgets/section_assumptions_option_card.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/presentation/widgets/section/section_qa_content_loading.dart';
import 'package:finful_app/app/presentation/widgets/section/section_question_text.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/app/theme/dimens.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/extension/extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'section_assumptions_calculate_result.dart';

class SectionAssumptionsQAContent extends StatelessWidget {
  const SectionAssumptionsQAContent({
    super.key,
    required this.sliderValueSelected,
    required this.onSliderValueChanged,
    required this.radioValueSelected,
    required this.onRadioValueChanged,
  });

  final int sliderValueSelected;
  final Function(int value) onSliderValueChanged;
  final SectionPayloadOptionResponse? radioValueSelected;
  final Function(SectionPayloadOptionResponse option) onRadioValueChanged;

  int? getDivisions(double min, double max) {
    final diff = (max - min).abs();
    if (diff <= 1) return null;
    return diff.toInt();
  }

  Widget _renderSliderContent(BuildContext context, SectionModel data) {
    final questionTxt = data.section.payload?.label ?? "";
    final listExplanations = data.section.payload?.explanations ??
        <SectionPayloadExplanationResponse>[];
    final minValue = data.section.payload?.min ?? 0;
    final maxValue = data.section.payload?.max ?? 100;
    final divisionsValue = getDivisions(
        minValue.toDouble(), maxValue.toDouble());

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: FinfulDimens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimens.p_56),
          SectionQuestionText(
            value: questionTxt,
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
          // todo: chart
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
          SectionQuestionText(
            value: questionTxt,
            textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
              height: Dimens.p_25 / Dimens.p_16,
            ),
          ),
          const SizedBox(height: Dimens.p_10),
          if (listOption.isNotEmpty)
            Column(
              children: listOption.map((option) {
                final isSelected = radioValueSelected != null &&
                    radioValueSelected!.value == option.value;
                return Padding(
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
                );
              }).toList(),
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
