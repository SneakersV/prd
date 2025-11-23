import 'package:finful_app/app/constants/icons.dart';
import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/common/show_message/show_message_event.dart';
import 'package:finful_app/app/presentation/blocs/mixins/family_support_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/app/presentation/blocs/section/family_support/family_support.dart';
import 'package:finful_app/app/presentation/journey/section/family_support/section_family_support_qa_router.dart';
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

import 'widgets/section_family_support_qa_content.dart';

class SectionFamilySupportQAScreen extends StatefulWidget {
  const SectionFamilySupportQAScreen({super.key});

  @override
  State<SectionFamilySupportQAScreen> createState() => _SectionFamilySupportQAScreenState();
}

class _SectionFamilySupportQAScreenState extends State<SectionFamilySupportQAScreen>
with BaseScreenMixin<SectionFamilySupportQAScreen, SectionFamilySupportQARouter>,
    ShowMessageBlocMixin, FamilySupportBlocMixin {
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
    final state = getFamilySupportState;
    if (state.sectionFamilySupports.isEmpty) {
      BlocManager().event<FamilySupportBloc>(
        BlocConstants.sectionFamilySupport,
        FamilySupportGetNextStepStarted(nextStep: 1),
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

  void _processAfterFilledAnswer(FamilySupportFillAnswerSuccess state) {
    final nextStep = state.sectionFamilySupports.length + 1;
    BlocManager().event<FamilySupportBloc>(
      BlocConstants.sectionFamilySupport,
      FamilySupportGetNextStepStarted(nextStep: nextStep),
    );
  }

  void _educationContinuePressed(FamilySupportState state) {
    final nextStep = state.sectionFamilySupports.length + 1;
    BlocManager().event<FamilySupportBloc>(
      BlocConstants.sectionFamilySupport,
      FamilySupportGetNextStepStarted(nextStep: nextStep),
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
    BlocManager().event<FamilySupportBloc>(
      BlocConstants.sectionFamilySupport,
      FamilySupportAnswerFilled(
        answer: answerFilled,
      ),
    );
  }

  Future<void> _onBackPressed() async {
    final state = getFamilySupportState;
    if (state.sectionFamilySupports.isEmpty) {
      router.pop();
      return;
    }
    if (state.sectionFamilySupports.length == 1) {
      router.pop();
      return;
    }

    final currentSection = state.sectionFamilySupports.last;
    final quesType = SectionQuestionTypeExt.fromValue(
        currentSection.section.payload?.questionType);
    if (quesType == SectionQuestionType.number) {
      _handleUnFocus();
    }
    BlocManager().event<FamilySupportBloc>(
      BlocConstants.sectionFamilySupport,
      FamilySupportGetPreviousStepStarted(),
    );
  }

  void _processGotoSpendingFlow() {
    router.gotoSectionSpending();
  }

  void _processGoBackDashboard() {
    router.goBackDashboard();
  }

  void _processSubmitAnswers() {
    showSnackBarMessage(
      type: ShowMessageSnackBarType.info,
      title: 'common_section_completed_title',
      message: 'common_section_completed_message',
    );
    BlocManager().event<FamilySupportBloc>(
      BlocConstants.sectionFamilySupport,
      FamilySupportSubmitAnswerStarted(
        planId: router.planId,
      ),
    );
  }

  void _processGetNextStepSuccess(FamilySupportGetNextStepSuccess state) {
    final currentSection = state.sectionFamilySupports.last;
    final stepType = SectionStepTypeExt.fromValue(
        currentSection.section.stepType);
    if (stepType == SectionStepType.Final) {
      _processSubmitAnswers();
      return;
    }

    final quesType = SectionQuestionTypeExt.fromValue(
        currentSection.section.payload?.questionType);
    if (quesType == SectionQuestionType.number) {
      _resetTextInputController();
      _requestFocus();
    }
  }

  void _processGetPreviousStepSuccess(FamilySupportGetPreviousStepSuccess state) {
    final currentSection = state.sectionFamilySupports.last;
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

  void _listenerFamilySupportBloc(FamilySupportState state) {
    if (state is FamilySupportFillAnswerSuccess) {
      _processAfterFilledAnswer(state);
    } else if (state is FamilySupportGetNextStepSuccess) {
      _processGetNextStepSuccess(state);
    } else if (state is FamilySupportGetPreviousStepSuccess) {
      _processGetPreviousStepSuccess(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FamilySupportBloc, FamilySupportState>(
      listener: (_, state) {
        _listenerFamilySupportBloc(state);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: FinfulAppBar(
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          title: L10n.of(context)
              .translate('section_familySupport_qa_header_title'),
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
                            child: BlocBuilder<FamilySupportBloc, FamilySupportState>(
                              builder: (_, state) {
                                if (state.sectionFamilySupports.isEmpty) {
                                  return const SizedBox();
                                }

                                final currentSection = state.sectionFamilySupports.last;
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
                            child: SectionFamilySupportQAContent(
                              inputController: _inputController,
                              inputNode: _inputNode,
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
                    child: BlocBuilder<FamilySupportBloc, FamilySupportState>(
                      builder: (_, state) {
                        if (state.sectionFamilySupports.isEmpty) {
                          return const SizedBox();
                        }

                        final currentSection = state.sectionFamilySupports.last;
                        final quesType = SectionQuestionTypeExt.fromValue(
                            currentSection.section.payload?.questionType);
                        final stepType = SectionStepTypeExt.fromValue(
                            currentSection.section.stepType);
                        final currentStep = currentSection.section.currentStep;
                        final totalStep = currentSection.section.totalStep;
                        final questionKey = currentSection.section.payload?.key;
                        final unit = currentSection.section.payload?.unit;

                        if (state is FamilySupportSubmitAnswerInProgress) {
                          return const SizedBox();
                        } else if (state is FamilySupportSubmitAnswerSuccess) {
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
                                const SizedBox(height: Dimens.p_12),
                                FinfulButton.primary(
                                  title: L10n.of(context)
                                      .translate('section_familySupport_result_go_spending_btn'),
                                  onPressed: _processGotoSpendingFlow,
                                ),
                                const SizedBox(height: Dimens.p_12),
                              ],
                            ),
                          );
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
                                      .translate('common_cta_submit'),
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
    );
  }
}
