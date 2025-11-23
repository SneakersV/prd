import 'package:finful_app/app/constants/icons.dart';
import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/common/show_message/show_message_event.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/spending_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/section/spending/spending.dart';
import 'package:finful_app/app/presentation/journey/section/spending/section_spending_qa_router.dart';
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

import 'widgets/section_spending_qa_content.dart';

class SectionSpendingQAScreen extends StatefulWidget {
  const SectionSpendingQAScreen({super.key});

  @override
  State<SectionSpendingQAScreen> createState() => _SectionSpendingQAScreenState();
}

class _SectionSpendingQAScreenState extends State<SectionSpendingQAScreen>
    with BaseScreenMixin<SectionSpendingQAScreen, SectionSpendingQARouter>,
        ShowMessageBlocMixin, SpendingBlocMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  late TextEditingController _inputController;
  final FocusNode _inputNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void didMountWidget() {
    super.didMountWidget();
    final state = getSpendingState;
    if (state.sectionSpendings.isEmpty) {
      BlocManager().event<SpendingBloc>(
        BlocConstants.sectionSpending,
        SpendingGetNextStepStarted(nextStep: 1),
      );
    }
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    _inputController.dispose();
    _inputNode.dispose();
    super.dispose();
  }

  void _handleUnFocus() {
    if (_focusScopeNode.hasFocus) {
      _focusScopeNode.unfocus();
    }
  }

  void _requestFocus() {
    _inputNode.requestFocus();
  }

  void _resetTextInputController() {
    _inputController.text = '';
    _inputController.clear();
  }

  void _processAfterFilledAnswer(SpendingFillAnswerSuccess state) {
    final nextStep = state.sectionSpendings.length + 1;
    BlocManager().event<SpendingBloc>(
      BlocConstants.sectionSpending,
      SpendingGetNextStepStarted(nextStep: nextStep),
    );
  }

  void _educationContinuePressed(SpendingState state) {
    final nextStep = state.sectionSpendings.length + 1;
    BlocManager().event<SpendingBloc>(
      BlocConstants.sectionSpending,
      SpendingGetNextStepStarted(nextStep: nextStep),
    );
  }

  void _onAnswerSelected(
      String? questionKey,
      SectionQuestionType quesType,
      String? unit) {
    final answerStr = _inputController.text.trim();
    if (questionKey.isNullOrEmpty) {
      return;
    }
    if (quesType != SectionQuestionType.number) {
      return;
    }
    if (answerStr.isNullOrEmpty) {
      return;
    }

    _handleUnFocus();

    final finalAnswer = answerStr.toMillionByUnit(unit);
    if (finalAnswer == -1) {
      showSnackBarMessage(
        type: ShowMessageSnackBarType.warning,
        title: 'common_section_input_currency_invalid_title',
        message: 'common_section_input_currency_invalid_message',
      );
      return;
    }

    final answerFilled = SectionAnswerModel(
      questionKey: questionKey!,
      answer: finalAnswer,
    );
    BlocManager().event<SpendingBloc>(
      BlocConstants.sectionSpending,
      SpendingAnswerFilled(
        answer: answerFilled,
      ),
    );
  }

  Future<void> _onBackPressed() async {
    final state = getSpendingState;
    if (state.sectionSpendings.isEmpty) {
      router.pop();
      return;
    }
    if (state.sectionSpendings.length == 1) {
      router.pop();
      return;
    }

    final currentSection = state.sectionSpendings.last;
    final quesType = SectionQuestionTypeExt.fromValue(
        currentSection.section.payload?.questionType);
    if (quesType == SectionQuestionType.number) {
      _handleUnFocus();
    }
    BlocManager().event<SpendingBloc>(
      BlocConstants.sectionSpending,
      SpendingGetPreviousStepStarted(),
    );
  }

  void _processSubmitCalculate() {
    showSnackBarMessage(
      type: ShowMessageSnackBarType.info,
      title: 'common_section_completed_title',
      message: 'common_section_completed_message',
    );

    BlocManager().event<SpendingBloc>(
      BlocConstants.sectionSpending,
      SpendingCalculateStarted(
        planId: router.planId,
      ),
    );
  }

  void _processGotoAssumptionsFlow() {
    router.gotoSectionAssumptions();
  }

  void _processGoBackDashboard() {
    router.goBackDashboard();
  }

  void _processGetNextStepSuccess(SpendingGetNextStepSuccess state) {
    final currentSection = state.sectionSpendings.last;
    final stepType = SectionStepTypeExt.fromValue(
        currentSection.section.stepType);
    if (stepType == SectionStepType.Final) {
      _processSubmitCalculate();
      return;
    }

    final quesType = SectionQuestionTypeExt.fromValue(
        currentSection.section.payload?.questionType);
    if (quesType == SectionQuestionType.number) {
      _resetTextInputController();
      _requestFocus();
    }
  }

  void _processGetPreviousStepSuccess(SpendingGetPreviousStepSuccess state) {
    final currentSection = state.sectionSpendings.last;
    final quesType = SectionQuestionTypeExt.fromValue(
        currentSection.section.payload?.questionType);
    if (quesType == SectionQuestionType.number) {
      final currentAnswer = currentSection.answerFilled?.answer;
      if (currentAnswer is String) {
        _inputController.text = currentAnswer;
        _requestFocus();
      }
    } else {
      _resetTextInputController();
    }
  }

  void _listenerSpendingBloc(SpendingState state) {
    if (state is SpendingFillAnswerSuccess) {
      _processAfterFilledAnswer(state);
    } else if (state is SpendingGetNextStepSuccess) {
      _processGetNextStepSuccess(state);
    } else if (state is SpendingGetPreviousStepSuccess) {
      _processGetPreviousStepSuccess(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpendingBloc, SpendingState>(
      listener: (_, state) {
        _listenerSpendingBloc(state);
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, _) {
            if (didPop) return;

            _onBackPressed();
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            resizeToAvoidBottomInset: true,
            appBar: FinfulAppBar(
              backgroundColor: Colors.transparent,
              forceMaterialTransparency: true,
              title: L10n.of(context)
                  .translate('section_spending_qa_header_title'),
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
            body: GestureDetector(
              onTap: _handleUnFocus,
              child: Form(
                key: _formKey,
                child: FocusScope(
                  node: _focusScopeNode,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.only(
                                top: Dimens.p_4,
                              ),
                              sliver: SliverToBoxAdapter(
                                child: BlocBuilder<SpendingBloc, SpendingState>(
                                  builder: (_, state) {
                                    if (state.sectionSpendings.isEmpty) {
                                      return const SizedBox();
                                    }

                                    final currentSection = state.sectionSpendings.last;
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
                                top: Dimens.p_56,
                                bottom: Dimens.p_64 + context.queryPaddingBottom,
                              ),
                              sliver: SliverToBoxAdapter(
                                child: SectionSpendingQAContent(
                                  inputController: _inputController,
                                  inputNode: _inputNode,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: Dimens.p_12 + context.queryPaddingBottom,
                        left: Dimens.p_0,
                        right: Dimens.p_0,
                        child: BlocBuilder<SpendingBloc, SpendingState>(
                          builder: (_, state) {
                            if (state.sectionSpendings.isEmpty) {
                              return const SizedBox();
                            }

                            final currentSection = state.sectionSpendings.last;
                            final quesType = SectionQuestionTypeExt.fromValue(
                                currentSection.section.payload?.questionType);
                            final stepType = SectionStepTypeExt.fromValue(
                                currentSection.section.stepType);
                            final currentStep = currentSection.section.currentStep;
                            final totalStep = currentSection.section.totalStep;
                            final questionKey = currentSection.section.payload?.key;
                            final unit = currentSection.section.payload?.unit;

                            if (stepType == SectionStepType.Final) {
                              if (state is SpendingCalculateInProgress) {
                                return const SizedBox();
                              } else if (state is SpendingCalculateSuccess) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: FinfulDimens.md,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FinfulButton.secondary(
                                        title: L10n.of(context)
                                            .translate('common_cta_back_dashboard_btn'),
                                        onPressed: _processGoBackDashboard,
                                      ),
                                      const SizedBox(height: Dimens.p_18),
                                      FinfulButton.primary(
                                        title: L10n.of(context)
                                            .translate('section_spending_result_go_assumptions_btn'),
                                        onPressed: _processGotoAssumptionsFlow,
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
                                          .translate('section_spending_cta_final_btn'),
                                      onPressed: () {
                                        if (stepType == SectionStepType.education) {
                                          _educationContinuePressed(state);
                                        } else if (stepType == SectionStepType.question) {
                                          _onAnswerSelected(questionKey, quesType, unit);
                                        }
                                      },
                                    ),
                                    const SizedBox(height: Dimens.p_12),
                                  ],
                                ),
                              );
                            }

                            if (stepType == SectionStepType.education ||
                                quesType == SectionQuestionType.number) {
                              final ctaText = currentSection.section.payload?.ctaText ?? "";
                              String btnCtaTitle = L10n.of(context)
                                  .translate('common_cta_continue');
                              if (stepType == SectionStepType.education && ctaText.isNotEmpty) {
                                btnCtaTitle = ctaText;
                              }
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: FinfulDimens.md,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FinfulButton.secondary(
                                      title: btnCtaTitle,
                                      onPressed: () {
                                        if (stepType == SectionStepType.education) {
                                          _educationContinuePressed(state);
                                        } else if (stepType == SectionStepType.question) {
                                          _onAnswerSelected(questionKey, quesType, unit);
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
