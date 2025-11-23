import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/data/model/response/section_response.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/injection/injection.dart';
import 'package:finful_app/app/presentation/blocs/section/family_support/family_support.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/presentation/widgets/app_input/FinfulTextInput.dart';
import 'package:finful_app/app/presentation/widgets/section/section_option_card.dart';
import 'package:finful_app/app/presentation/widgets/section/section_options_wrapper.dart';
import 'package:finful_app/app/presentation/widgets/section/section_qa_content_loading.dart';
import 'package:finful_app/app/presentation/widgets/section/section_question_text.dart';
import 'package:finful_app/app/theme/theme.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'section_family_support_qa_submit_result.dart';

class SectionFamilySupportQAContent extends StatelessWidget {
  const SectionFamilySupportQAContent({
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
    BlocManager().event<FamilySupportBloc>(
      BlocConstants.sectionFamilySupport,
      FamilySupportAnswerFilled(
        answer: answerFilled,
      ),
    );
  }

  Widget _renderInput(BuildContext context, SectionModel data) {
    final questionTxt = data.section.payload?.text ?? "";
    final unit = data.section.payload?.unit ?? "";
    String currencyValueTxt = "${inputController.text} $unit";

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: FinfulDimens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SectionQuestionText(
            value: questionTxt,
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
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: Dimens.p_4),
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
          SectionQuestionText(
            value: questionTxt,
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

  Widget _renderEducationContent(BuildContext context, SectionModel data) {
    final payload = data.section.payload;

    if (payload == null) {
      return const SizedBox();
    }

    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: FinfulDimens.md,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.p_80,
            ),
            child: Text(
              L10n.of(context)
                  .translate('section_familySupport_qa_education_title'),
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Dimens.p_21,
              bottom: Dimens.p_32,
            ),
            child: Text(
              payload.title ?? "",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (payload.image.isNotNullAndEmpty)
            FinfulImage(
              type: FinfulImageType.network,
              source: payload.image!.getNormalImageUrlFromHost(Injection().getMediaHost),
              width: mediaWidth(context),
              height: mediaHeight(context),
            ) else const SizedBox(),
          const SizedBox(height: Dimens.p_32),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.p_22,
            ),
            child: Text(
              payload.text ?? "",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: Dimens.p_64 + context.queryPaddingBottom),
        ],
      ),
    );
  }

  Widget _renderContent(
      BuildContext context,
      SectionModel data,
      FamilySupportState state) {
    final stepType = SectionStepTypeExt.fromValue(data.section.stepType);
    if (state is FamilySupportGetNextStepInProgress) {
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
        return _renderEducationContent(context, data);
      } else if (stepType == SectionStepType.Final) {
        String resultMessage = L10n.of(context)
            .translate('section_familySupport_result_submitting');
        if (state is FamilySupportSubmitAnswerSuccess) {
          resultMessage = L10n.of(context)
              .translate('section_familySupport_result_submit_success');
        }
        return SectionFamilySupportQaSubmitResult(
          message: resultMessage,
        );
      } else {
        return const SizedBox();
      }
    }
  }

  double mediaWidth(BuildContext context) => context.queryWidth;

  double mediaHeight(BuildContext context) => mediaWidth(context) * 0.8646;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilySupportBloc, FamilySupportState>(
      builder: (_, state) {
        if (state.sectionFamilySupports.isEmpty) {
          return const SectionQaContentLoading();
        }

        final currentSection = state.sectionFamilySupports.last;
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          child: _renderContent(context, currentSection, state),
        );
      },
    );
  }
}
