import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/interactor/section_interactor.dart';
import 'package:finful_app/app/domain/model/extension/section_ext.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/app/presentation/blocs/section/onboarding/onboarding.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingBloc extends BaseBloc<OnboardingEvent, OnboardingState>
    with LoaderBlocMixin, ShowMessageBlocMixin {
  late final SectionInteractor _sectionInteractor;

  OnboardingBloc(Key key, {
    required SectionInteractor sectionInteractor,
  })
      : _sectionInteractor = sectionInteractor,
        super(
        key,
        initialState: OnboardingInitial(
            initSection: <SectionModel>[],
            initCalculateResult: null,
        ),
      ) {
    on<OnboardingGetNextStepStarted>(_onOnboardingGetNextStepStarted);
    on<OnboardingGetPreviousStepStarted>(_onOnboardingGetPreviousStepStarted);
    on<OnboardingAnswerFilled>(_onOnboardingAnswerFilled);
    on<OnboardingCalculateStarted>(_onOnboardingCalculateStarted);
  }

  factory OnboardingBloc.instance() {
    return BlocManager().newBloc<OnboardingBloc>(BlocConstants.sectionOnboarding);
  }

  Future<void> _onOnboardingGetNextStepStarted(
      OnboardingGetNextStepStarted event,
      Emitter<OnboardingState> emit,
      ) async {
    emit(OnboardingGetNextStepInProgress(state));

    try {
      List<SectionAnswerModel> currentAnswerFilled = [];
      if (event.nextStep > 1) {
        final validData = state.sectionOnboardings.where((e) => e.answerFilled != null).toList();
        if (validData.isNotEmpty) {
          currentAnswerFilled = validData.map((e) => e.answerFilled!).toList();
        }
      }
      final nextSection = await _sectionInteractor.getSectionOnboardingQA(
        nextStep: event.nextStep,
        answersFilled: currentAnswerFilled,
      );
      List<SectionModel> latestSections = state.sectionOnboardings;
      latestSections.add(nextSection);
      latestSections.toList();

      emit(OnboardingGetNextStepSuccess(
        latestSections: latestSections,
      ));
    } catch (err) {
      handleError(err);
      emit(OnboardingGetNextStepFailure(state));
    }
  }

  Future<void> _onOnboardingGetPreviousStepStarted(
      OnboardingGetPreviousStepStarted event,
      Emitter<OnboardingState> emit,
      ) async {
    emit(OnboardingGetPreviousStepInProgress(state));

    List<SectionModel> latestSections = state.sectionOnboardings;
    if (latestSections.isNotEmpty) {
      latestSections.removeLast();
      latestSections.toList();
    }

    emit(OnboardingGetPreviousStepSuccess(
      latestSections: latestSections,
    ));
  }

  Future<void> _onOnboardingAnswerFilled(
      OnboardingAnswerFilled event,
      Emitter<OnboardingState> emit,
      ) async {
    emit(OnboardingFillAnswerInProgress(state));

    List<SectionModel> latestSections = state.sectionOnboardings;
    if (latestSections.isNotEmpty) {
      SectionModel currentQA = latestSections.last;
      currentQA = currentQA.copyWith(
          answerFilled: event.answer
      );
      latestSections.removeLast();
      latestSections.toList();
      latestSections.add(currentQA);
      latestSections.toList();

      emit(OnboardingFillAnswerSuccess(
        latestSections: latestSections,
      ));
    }
  }

  Future<void> _onOnboardingCalculateStarted(
      OnboardingCalculateStarted event,
      Emitter<OnboardingState> emit,
      ) async {
    emit(OnboardingCalculateInProgress(state));
    try {
      final validAnswersFilled = state.sectionOnboardings.toValidAnswersFilled;
      if (validAnswersFilled.isNotEmpty) {
        final calculateResult = await _sectionInteractor.submitSectionOnboardingCalculate(
          answersFilled: validAnswersFilled,
        );
        emit(OnboardingCalculateSuccess(
            state: state,
            calculateResult: calculateResult,
        ));
      }
    } catch (err) {
      handleError(err);
      emit(OnboardingCalculateFailure(state));
    }
  }
}