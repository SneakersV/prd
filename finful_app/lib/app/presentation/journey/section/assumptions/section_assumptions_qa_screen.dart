import 'package:finful_app/app/constants/icons.dart';
import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/data/model/response/section_response.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/common/show_message/show_message_event.dart';
import 'package:finful_app/app/presentation/blocs/mixins/assumptions_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/app/presentation/blocs/section/assumptions/assumptions.dart';
import 'package:finful_app/app/presentation/journey/section/assumptions/section_assumptions_qa_router.dart';
import 'package:finful_app/app/presentation/widgets/app_button/FinfulButton.dart';
import 'package:finful_app/app/presentation/widgets/section/section_progress_bar.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/app/theme/dimens.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/common/widgets/app_bar/finful_app_bar.dart';
import 'package:finful_app/common/widgets/app_icon/app_icon.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/context_extension.dart';
import 'package:finful_app/core/extension/string_extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:finful_app/core/presentation/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

import 'widgets/section_assumptions_qa_content.dart';

class SectionAssumptionsQAScreen extends StatefulWidget {
  const SectionAssumptionsQAScreen({super.key});

  @override
  State<SectionAssumptionsQAScreen> createState() => _SectionAssumptionsQAScreenState();
}

class _SectionAssumptionsQAScreenState extends State<SectionAssumptionsQAScreen>
    with BaseScreenMixin<SectionAssumptionsQAScreen, SectionAssumptionsQARouter>,
        ShowMessageBlocMixin, AssumptionsBlocMixin {
  int _currentValue = 0; // for slider
  SectionPayloadOptionResponse? _currentOption; // for radio

  @override
  void didMountWidget() {
    super.didMountWidget();
    final state = getAssumptionsState;
    if (state.sectionAssumptions.isEmpty) {
      BlocManager().event<AssumptionsBloc>(
        BlocConstants.sectionAssumptions,
        AssumptionsGetNextStepStarted(nextStep: 1),
      );
    }
  }

  void _processAfterFilledAnswer(AssumptionsFillAnswerSuccess state) {
    final nextStep = state.sectionAssumptions.length + 1;
    BlocManager().event<AssumptionsBloc>(
      BlocConstants.sectionAssumptions,
      AssumptionsGetNextStepStarted(nextStep: nextStep),
    );
  }

  void _onAnswerSelected(
      String? questionKey,
      SectionQuestionType quesType,
  ) {
    if (questionKey.isNullOrEmpty) {
      return;
    }

    int finalAnswer = -1;
    if (quesType == SectionQuestionType.slider) {
      if (_currentValue == 0) {
        showSnackBarMessage(
          type: ShowMessageSnackBarType.warning,
          title: 'section_slider_invalid_title',
          message: 'section_slider_invalid_message',
        );
      } else if (_currentValue > 0) {
        finalAnswer = _currentValue;
      }
    } else if (quesType == SectionQuestionType.radio) {
      if (_currentOption == null) {
        showSnackBarMessage(
          type: ShowMessageSnackBarType.warning,
          title: 'section_radio_invalid_title',
          message: 'section_radio_invalid_message',
        );
      } else {
        final returnRate = _currentOption!.returnRate;
        if (returnRate != null && returnRate > 0) {
          finalAnswer = returnRate;
        }
      }
    }
    if (finalAnswer == -1) {
      return;
    }

    final answerFilled = SectionAnswerModel(
      questionKey: questionKey!,
      answer: finalAnswer,
    );
    BlocManager().event<AssumptionsBloc>(
      BlocConstants.sectionAssumptions,
      AssumptionsAnswerFilled(
        answer: answerFilled,
      ),
    );
  }

  Future<void> _onBackPressed() async {
    final state = getAssumptionsState;
    if (state.sectionAssumptions.isEmpty) {
      router.pop();
      return;
    }
    if (state.sectionAssumptions.length == 1) {
      router.pop();
      return;
    }

    BlocManager().event<AssumptionsBloc>(
      BlocConstants.sectionAssumptions,
      AssumptionsGetPreviousStepStarted(),
    );
  }

  void _processSubmitCalculate() {
    showSnackBarMessage(
      type: ShowMessageSnackBarType.info,
      title: 'common_section_completed_title',
      message: 'common_section_completed_message',
    );
    BlocManager().event<AssumptionsBloc>(
      BlocConstants.sectionAssumptions,
      AssumptionsCalculateStarted(
        planId: router.planId,
      ),
    );
  }

  void _onAfterCalculatePressed() {
    router.goBackDashboard();
  }

  void _onSliderValueChanged(int newValue) {
    setState(() {
      _currentValue = newValue;
    });
  }

  void _onRadioValueChanged(SectionPayloadOptionResponse newValue) {
    setState(() {
      _currentOption = newValue;
    });
  }

  void _processGetNextStepSuccess(AssumptionsGetNextStepSuccess state) {
    final currentSection = state.sectionAssumptions.last;
    final stepType = SectionStepTypeExt.fromValue(
        currentSection.section.stepType);
    if (stepType == SectionStepType.Final) {
      _processSubmitCalculate();
      return;
    }
    final quesType = SectionQuestionTypeExt.fromValue(
        currentSection.section.payload?.questionType);
    if (quesType == SectionQuestionType.slider) {
      final minValue = currentSection.section.payload?.min ?? 0;
      setState(() {
        _currentValue = minValue;
      });
    } else if (quesType == SectionQuestionType.radio) {
      setState(() {
        _currentOption = null;
      });
    }
  }
  
  void _processGetPreviousStepSuccess(AssumptionsGetPreviousStepSuccess state) {
    final currentSection = state.sectionAssumptions.last;
    final quesType = SectionQuestionTypeExt.fromValue(
        currentSection.section.payload?.questionType);
    final currentAnswer = currentSection.answerFilled?.answer;
    if (quesType == SectionQuestionType.slider) {
      if (currentAnswer is int) {
        setState(() {
          _currentValue = currentAnswer;
        });
      }
    } else if (quesType == SectionQuestionType.radio) {
      final options = currentSection.section.payload?.options;
      if (options != null && options.isNotEmpty) {
        final optionSelected = options.firstWhereOrNull(
                (e) => e.returnRate == currentAnswer);
        if (optionSelected != null) {
          setState(() {
            _currentOption = optionSelected;
          });
        }
      }
    }
  }

  void _listenerAssumptionsBloc(AssumptionsState state) {
    if (state is AssumptionsFillAnswerSuccess) {
      _processAfterFilledAnswer(state);
    } else if (state is AssumptionsGetNextStepSuccess) {
      _processGetNextStepSuccess(state);
    } else if (state is AssumptionsGetPreviousStepSuccess) {
      _processGetPreviousStepSuccess(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssumptionsBloc, AssumptionsState>(
      listener: (_, state) {
        _listenerAssumptionsBloc(state);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: FinfulAppBar(
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          title: L10n.of(context)
              .translate('section_assumptions_qa_header_title'),
          titleStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.w500,
          ),
          leadingIcon: AppSvgIcon(
            IconConstants.icBack,
            width: FinfulDimens.iconMd,
            height: FinfulDimens.iconMd,
            color: FinfulColor.white,
          ),
          onLeadingPressed: _onBackPressed,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top: Dimens.p_4,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: BlocBuilder<AssumptionsBloc, AssumptionsState>(
                        builder: (_, state) {
                          if (state.sectionAssumptions.isEmpty) {
                            return const SizedBox();
                          }

                          final currentSection = state.sectionAssumptions.last;
                          final currentStep = currentSection.section.currentStep;
                          final totalStep = currentSection.section.totalStep;

                          if (currentStep == null ||
                              totalStep == null) {
                            return const SizedBox();
                          }

                          final stepType = SectionStepTypeExt.fromValue(
                              currentSection.section.stepType);
                          if (stepType == SectionStepType.Final) {
                            return const SizedBox();
                          }

                          return SectionProgressBar(
                            current: currentStep - 1,
                            total: totalStep,
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: Dimens.p_64 + context.queryPaddingBottom,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: SectionAssumptionsQAContent(
                        sliderValueSelected: _currentValue,
                        onSliderValueChanged: _onSliderValueChanged,
                        radioValueSelected: _currentOption,
                        onRadioValueChanged: _onRadioValueChanged
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: context.queryPaddingBottom,
              left: Dimens.p_0,
              right: Dimens.p_0,
              child: BlocBuilder<AssumptionsBloc, AssumptionsState>(
                builder: (_, state) {
                  if (state.sectionAssumptions.isEmpty) {
                    return const SizedBox();
                  }

                  final currentSection = state.sectionAssumptions.last;
                  final quesType = SectionQuestionTypeExt.fromValue(
                      currentSection.section.payload?.questionType);
                  final stepType = SectionStepTypeExt.fromValue(
                      currentSection.section.stepType);
                  final currentStep = currentSection.section.currentStep;
                  final totalStep = currentSection.section.totalStep;
                  final questionKey = currentSection.section.payload?.key;

                  if (stepType == SectionStepType.Final) {
                    if (state is AssumptionsCalculateInProgress) {
                      return const SizedBox();
                    } else if (state is AssumptionsCalculateSuccess) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: FinfulDimens.md,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FinfulButton.primary(
                              title: L10n.of(context)
                                  .translate('common_cta_back_dashboard_btn'),
                              onPressed: _onAfterCalculatePressed,
                            ),
                            const SizedBox(height: Dimens.p_18),
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  }

                  if (currentStep == totalStep) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: FinfulDimens.md,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FinfulButton.primary(
                            title: L10n.of(context)
                                .translate('section_assumptions_cta_final_btn'),
                            onPressed: () {
                              if (stepType == SectionStepType.question) {
                                _onAnswerSelected(questionKey, quesType);
                              }
                            },
                          ),
                          const SizedBox(height: Dimens.p_12),
                        ],
                      ),
                    );
                  }

                  if (quesType == SectionQuestionType.slider ||
                      quesType == SectionQuestionType.radio) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: FinfulDimens.md,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FinfulButton.secondary(
                            title: L10n.of(context)
                                .translate('common_cta_continue'),
                            onPressed: () {
                              if (stepType == SectionStepType.question) {
                                _onAnswerSelected(questionKey, quesType);
                              }
                            },
                          ),
                          const SizedBox(height: Dimens.p_12),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
