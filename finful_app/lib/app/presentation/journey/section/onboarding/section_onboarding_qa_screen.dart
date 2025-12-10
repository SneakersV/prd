import 'package:finful_app/app/constants/icons.dart';
import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/constants/lotties.dart';
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
import 'package:lottie/lottie.dart';
import 'package:collection/collection.dart';
import 'widgets/section_onboarding_qa_content.dart';

class SectionOnboardingQAScreen extends StatefulWidget {
  const SectionOnboardingQAScreen({super.key});

  @override
  State<SectionOnboardingQAScreen> createState() => _SectionOnboardingQAScreenState();
}

class _SectionOnboardingQAScreenState extends State<SectionOnboardingQAScreen>
    with TickerProviderStateMixin,
        BaseScreenMixin<SectionOnboardingQAScreen, SectionOnboardingQARouter>,
        ShowMessageBlocMixin, SessionBlocMixin, OnboardingBlocMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  late TextEditingController _inputController;
  final FocusNode _inputNode = FocusNode();
  bool _showUserGuide = true;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
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
    _controller.dispose();
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

  void _updateTextInputController(String value) {
    _inputController.text = value;
  }

  void _processAfterFilledAnswer(OnboardingFillAnswerSuccess state) {
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
    if (questionKey.isNullOrEmpty) return;
    if (quesType != SectionQuestionType.number) return;

    final inputValid = _formKey.currentState!.validate();
    if (!inputValid) return;

    _handleUnFocus();

    final isBillion = unit?.isBillion ?? false;
    final finalAnswer = isBillion ? double.tryParse(answerStr) : int.tryParse(answerStr);
    if (finalAnswer == -1 || finalAnswer == null) {
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
    _controller.reset();
    setState(() {
      _showUserGuide = true;
    });
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

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(
      bytes,
      filePicker: (files) {
        return files.firstWhereOrNull((f) =>
        f.name.startsWith('animations/') &&
            f.name.endsWith('.json'),
        );
      },
    );
  }


  void _processSubmitCalculate() {
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
      if (currentAnswer != null) {
        _updateTextInputController(currentAnswer.toString());
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

  String _headerTitleText() {
    return L10n.of(context)
        .translate('section_onboarding_qa_header_title');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: _mapBlocListeners,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) {
          if (didPop) return;

          _onBackPressed();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                resizeToAvoidBottomInset: true,
                appBar: FinfulAppBar(
                  backgroundColor: Colors.transparent,
                  forceMaterialTransparency: true,
                  title: _headerTitleText(),
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
                                        } else if (stepType == SectionStepType.education) {
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
                            bottom: Dimens.p_0,
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
                                    return Container(
                                      color: Theme.of(context).scaffoldBackgroundColor,
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
                                          SizedBox(
                                            height: Dimens.p_12 + context.queryPaddingBottom,
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return const SizedBox();
                                }

                                if (stepType == SectionStepType.education) {
                                  return const SizedBox();
                                }

                                if (currentStep == totalStep) {
                                  return Container(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: FinfulDimens.md,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FinfulButton.primary(
                                          title: L10n.of(context)
                                              .translate('section_onboarding_cta_final_btn'),
                                          isLoading: state is OnboardingCalculateInProgress,
                                          onPressed: () {
                                            if (stepType == SectionStepType.question) {
                                              _onAnswerSelected(questionKey, quesType, unit);
                                            }
                                          },
                                        ),
                                        const SizedBox(height: Dimens.p_12),
                                        SizedBox(
                                          height: Dimens.p_12 + context.queryPaddingBottom,
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                if (quesType == SectionQuestionType.number) {
                                  return Container(
                                    color: Theme.of(context).scaffoldBackgroundColor,
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
                                              _onAnswerSelected(questionKey, quesType, unit);
                                            }
                                          },
                                        ),
                                        const SizedBox(height: Dimens.p_12),
                                        SizedBox(
                                          height: Dimens.p_12 + context.queryPaddingBottom,
                                        ),
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
            // user guide
            BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (_, state) {
                final currentSection = state.sectionOnboardings.isNotEmpty
                    ? state.sectionOnboardings.last : null;
                final stepType = SectionStepTypeExt.fromValue(currentSection?.section.stepType);
                if (_showUserGuide && stepType == SectionStepType.education) {
                  return Positioned.fill(
                    child: GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        print('primaryVelocity--->${details.primaryVelocity}');
                        if (details.primaryVelocity! < -200) {
                          if (_showUserGuide) {
                            setState(() {
                              _showUserGuide = false;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: FinfulColor.userGuideBg,
                        child: Center(
                          child: Container(
                            width: Dimens.p_150,
                            height: Dimens.p_200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(Dimens.p_10)),
                              border: Border.all(
                                width: Dimens.p_1,
                                color: FinfulColor.white,
                                style: BorderStyle.solid,
                              ),
                              color: FinfulColor.userGuideCardBg,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Lottie.asset(
                                    LottieConstants.educationUserGuide,
                                    controller: _controller,
                                    width: double.infinity,
                                    height: Dimens.p_57,
                                    fit: BoxFit.contain,
                                    decoder: customDecoder,
                                    onLoaded: (composition) {
                                      _controller
                                        ..duration = composition.duration
                                        ..repeat();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: Dimens.p_29,
                                      left: Dimens.p_10,
                                      right: Dimens.p_10,
                                    ),
                                    child: Text(
                                      "Vuốt sang trái để chuyển sang trang tiếp theo",
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
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

                return Positioned.fill(
                  child: SizedBox(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
