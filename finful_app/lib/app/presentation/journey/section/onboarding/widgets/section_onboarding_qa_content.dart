import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/data/model/response/section_response.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/section/onboarding/onboarding.dart';
import 'package:finful_app/app/presentation/widgets/app_input/FinfulTextInput.dart';
import 'package:finful_app/app/presentation/widgets/education/education_view.dart';
import 'package:finful_app/app/presentation/widgets/section/section_option_card.dart';
import 'package:finful_app/app/presentation/widgets/section/section_options_wrapper.dart';
import 'package:finful_app/app/presentation/widgets/section/section_qa_content_loading.dart';
import 'package:finful_app/app/theme/theme.dart';
import 'package:finful_app/app/utils/utils.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'section_onboarding_calculate_result.dart';
import 'section_onboarding_education_first.dart';

class SectionOnboardingQAContent extends StatelessWidget {
  const SectionOnboardingQAContent({
    super.key,
    required this.inputController,
    required this.inputNode,
  });

  final TextEditingController inputController;
  final FocusNode inputNode;

  void _onAnswerSelected(
      String? questionKey,
      SectionPayloadOptionResponse itemSelected) {
    if (questionKey.isNullOrEmpty) {
      return;
    }
    final answerFilled = SectionAnswerModel(
      questionKey: questionKey!,
      answer: itemSelected.value,
    );
    BlocManager().event<OnboardingBloc>(
      BlocConstants.sectionOnboarding,
      OnboardingAnswerFilled(
        answer: answerFilled,
      ),
    );
  }

  String? _onNumberInputValidator(BuildContext context, String? value) {
    if (value.isNullOrEmpty) {
      return L10n.of(context).translate('section_number_input_empty');
    }

    return null;
  }

  Widget _renderInput(BuildContext context, SectionModel data) {
    final questionTxt = data.section.payload?.text ?? "";
    final unit = data.section.payload?.unit ?? "";
    String currencyValueTxt = "${inputController.text} $unit";
    final isBillion = unit.isBillion;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: FinfulDimens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBillion)
            Text(
              L10n.of(context)
                  .translate('common_section_input_number_formatted_warning'),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w300,
                height: Dimens.p_19 / Dimens.p_14,
                fontStyle: FontStyle.italic,
              ),
            ),
          const SizedBox(height: Dimens.p_34),
          Text(
            questionTxt,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: Dimens.p_34),
          FinfulTextInput.single(
            controller: inputController,
            focusNode: inputNode,
            backgroundColor: Colors.transparent,
            height: FinfulTextInputHeight.md,
            hintText: L10n.of(context)
                .translate('common_section_input_hint'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.p_10,
              ),
              child: Text(
                unit,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: FinfulColor.grey,
                  fontWeight: FontWeight.w400,
                  height: Dimens.p_22 / Dimens.p_14,
                ),
              ),
            ),
            inputFormatter: sectionNumberInputFormatters,
            validator: (value) => _onNumberInputValidator(context, value),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: Dimens.p_8),
          Text(
            currencyValueTxt,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.w400,
              height: Dimens.p_28 / Dimens.p_20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderOptions(BuildContext context, SectionModel data) {
    final questionTxt = data.section.payload?.text ?? "";
    final listOption = data.section.payload?.options ??
        <SectionPayloadOptionResponse>[];
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: FinfulDimens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionTxt,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: Dimens.p_25),
          if (listOption.isNotEmpty)
            SectionOptionsWrapper(
              itemCount: listOption.length,
              itemBuilder: (context, index, animation) {
                final answer = data.answerFilled?.answer;
                final option = listOption[index];
                final isSelected = answer != null && option.value == answer;
                return SectionOptionWrapperItem(
                  animation: animation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.p_12),
                    child: SectionOptionCard(
                      title: option.label ?? "",
                      isSelected: isSelected,
                      onPressed: () {
                        final questionKey = data.section.payload?.key;
                        _onAnswerSelected(questionKey, option);
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
      OnboardingState state) {
    final stepType = SectionStepTypeExt.fromValue(data.section.stepType);
    if (state is OnboardingGetNextStepInProgress) {
      return SectionQaContentLoading();
    } else {
      if (stepType == SectionStepType.question) {
        final quesType = SectionQuestionTypeExt.fromValue(
            data.section.payload?.questionType);
        switch (quesType) {
          case SectionQuestionType.options:
            return _renderOptions(context, data);
          case SectionQuestionType.number:
            return _renderInput(context, data);
          default:
            return const SizedBox();
        }
      } else if (stepType == SectionStepType.education) {
        final length = state.sectionOnboardings.length;
        final typeIdx = length - 3;
        final locationIdx = length - 2;
        final type = state.sectionOnboardings[typeIdx].answerFilled?.answer;
        final location = state.sectionOnboardings[locationIdx].answerFilled?.answer;
        if (type != null && location != null) {
          return EducationView(
            type: type,
            location: location,
            currentSection: data,
          );
        }

        return SectionOnboardingEducationFirst(
          currentSection: data,
          showNextStepBtn: true,
        );
      } else if (stepType == SectionStepType.Final) {
        return SectionOnboardingCalculateResult();
      } else {
        return const SizedBox();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (_, state) {
        if (state.sectionOnboardings.isEmpty) {
          return const SectionQaContentLoading();
        }

        final currentSection = state.sectionOnboardings.last;
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          child: _renderContent(context, currentSection, state),
        );
      },
    );
  }
}
