import 'package:finful_app/app/constants/icons.dart';
import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/domain/model/extension/section_ext.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/common/show_message/show_message_event.dart';
import 'package:finful_app/app/presentation/blocs/create_plan/create_plan.dart';
import 'package:finful_app/app/presentation/blocs/mixins/onboarding_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/session_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/app/presentation/blocs/section/onboarding/onboarding.dart';
import 'package:finful_app/app/presentation/blocs/stored_draft/stored_draft.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/section_onboarding_qa_router.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/section_onboarding_screen.dart';
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

import 'widgets/section_onboarding_qa_content.dart';

class SectionOnboardingQAScreen extends StatefulWidget {
  const SectionOnboardingQAScreen({super.key});

  @override
  State<SectionOnboardingQAScreen> createState() => _SectionOnboardingQAScreenState();
}

class _SectionOnboardingQAScreenState extends State<SectionOnboardingQAScreen>
    with BaseScreenMixin<SectionOnboardingQAScreen, SectionOnboardingQARouter>,
        ShowMessageBlocMixin, SessionBlocMixin, OnboardingBlocMixin {
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
    final state = getOnboardingState;
    if (state.sectionOnboardings.isEmpty) {
      BlocManager().event<OnboardingBloc>(
        BlocConstants.sectionOnboarding,
        OnboardingGetNextStepStarted(nextStep: 1),
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

  void _processAfterFilledAnswer(OnboardingFillAnswerSuccess state) {
    final nextStep = state.sectionOnboardings.length + 1;
    BlocManager().event<OnboardingBloc>(
      BlocConstants.sectionOnboarding,
      OnboardingGetNextStepStarted(nextStep: nextStep),
    );
  }

  void _educationContinuePressed(OnboardingState state) {
    final nextStep = state.sectionOnboardings.length + 1;
    BlocManager().event<OnboardingBloc>(
      BlocConstants.sectionOnboarding,
      OnboardingGetNextStepStarted(nextStep: nextStep),
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
    BlocManager().event<OnboardingBloc>(
      BlocConstants.sectionOnboarding,
      OnboardingAnswerFilled(
        answer: answerFilled,
      ),
    );
  }

  Future<void> _onBackPressed() async {
    final state = getOnboardingState;
    if (state.sectionOnboardings.isEmpty) {
      router.pop();
      return;
    }
    if (state.sectionOnboardings.length == 1) {
      router.pop();
      return;
    }

    final currentSection = state.sectionOnboardings.last;
    final quesType = SectionQuestionTypeExt.fromValue(
        currentSection.section.payload?.questionType);
    if (quesType == SectionQuestionType.number) {
      _handleUnFocus();
    }
    BlocManager().event<OnboardingBloc>(
      BlocConstants.sectionOnboarding,
      OnboardingGetPreviousStepStarted(),
    );
  }

  void _processSubmitCalculate() {
    showSnackBarMessage(
      type: ShowMessageSnackBarType.info,
      title: 'common_section_completed_title',
      message: 'common_section_completed_message',
    );
    BlocManager().event<OnboardingBloc>(
      BlocConstants.sectionOnboarding,
      OnboardingCalculateStarted(),
    );
  }

  void _processGetNextStepSuccess(OnboardingGetNextStepSuccess state) {
    final currentSection = state.sectionOnboardings.last;
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

  void _processGetPreviousStepSuccess(OnboardingGetPreviousStepSuccess state) {
    final currentSection = state.sectionOnboardings.last;
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

  void _listenerOnboardingBloc(OnboardingState state) {
    if (state is OnboardingFillAnswerSuccess) {
      _processAfterFilledAnswer(state);
    } else if (state is OnboardingGetNextStepSuccess) {
      _processGetNextStepSuccess(state);
    } else if (state is OnboardingGetPreviousStepSuccess) {
      _processGetPreviousStepSuccess(state);
    } else if (state is OnboardingCalculateSuccess) {
      switch (router.entryFrom) {
        case (SectionOnboardingEntryFrom.dashboard):
          _handleCreatePlan(state);
          break;
        case (SectionOnboardingEntryFrom.splash):
          _handleSaveAnswersToStoreDraft(state);
          break;
      }
    }
  }

  void _handleSaveAnswersToStoreDraft(OnboardingCalculateSuccess state) {
    final validAnswersFilled = state.sectionOnboardings.toValidAnswersFilled;
    BlocManager().event<StoredDraftBloc>(
      BlocConstants.storedDraft,
      StoredDraftUpdateOnboardingDataStarted(
        onboardingAnswers: validAnswersFilled,
      ),
    );
  }

  void _handleCreatePlan(OnboardingCalculateSuccess state) {
    final loggedInUser = getSessionState.loggedInUser;
    if (loggedInUser == null) return;
    final validAnswersFilled = state.sectionOnboardings.toValidAnswersFilled;
    BlocManager().event<CreatePlanBloc>(
      BlocConstants.createPlan,
      CreatePlanStarted(
        answersFilled: validAnswersFilled,
      ),
    );
  }

  void _onCalculateResultPressed() {
    if (router.entryFrom == SectionOnboardingEntryFrom.dashboard) {
      router.goBackDashboard();
    } else if (router.entryFrom == SectionOnboardingEntryFrom.splash) {
      router.gotoSignUpIntro();
    }
  }

  List<BlocListener> get _mapBlocListeners {
    return [
      BlocListener<OnboardingBloc, OnboardingState>(
        listener: (_, state) {
          _listenerOnboardingBloc(state);
        },
      ),
      BlocListener<CreatePlanBloc, CreatePlanState>(
        listener: (_, state) {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: _mapBlocListeners,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) {
          _onBackPressed();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: FinfulAppBar(
            backgroundColor: Colors.transparent,
            forceMaterialTransparency: true,
            title: L10n.of(context)
                .translate('section_onboarding_qa_header_title'),
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
                              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                                builder: (_, state) {
                                  if (state.sectionOnboardings.isEmpty) {
                                    return const SizedBox();
                                  }

                                  final currentSection = state.sectionOnboardings.last;
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
                              child: SectionOnboardingQAContent(
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
                      child: BlocBuilder<OnboardingBloc, OnboardingState>(
                        builder: (_, state) {
                          if (state.sectionOnboardings.isEmpty) {
                            return const SizedBox();
                          }

                          final currentSection = state.sectionOnboardings.last;
                          final quesType = SectionQuestionTypeExt.fromValue(
                              currentSection.section.payload?.questionType);
                          final stepType = SectionStepTypeExt.fromValue(
                              currentSection.section.stepType);
                          final currentStep = currentSection.section.currentStep;
                          final totalStep = currentSection.section.totalStep;
                          final questionKey = currentSection.section.payload?.key;
                          final unit = currentSection.section.payload?.unit;

                          if (stepType == SectionStepType.Final) {
                            if (state is OnboardingCalculateInProgress) {
                              return const SizedBox();
                            }

                            if (state is OnboardingCalculateSuccess) {
                              String discoveryTxt = L10n.of(context)
                                  .translate('common_cta_discovery_btn');
                              String backDashboardTxt = L10n.of(context)
                                  .translate('common_cta_back_dashboard_btn');
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: FinfulDimens.md,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FinfulButton.secondary(
                                      title: router.entryFrom == SectionOnboardingEntryFrom.dashboard
                                          ? backDashboardTxt : discoveryTxt,
                                      onPressed: () {
                                        _onCalculateResultPressed();
                                      },
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
                                        .translate('section_onboarding_cta_final_btn'),
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
    );
  }
}
