import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/interactor/plan_interactor.dart';
import 'package:finful_app/app/domain/interactor/section_interactor.dart';
import 'package:finful_app/app/domain/model/extension/extension.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'spending_event.dart';
import 'spending_state.dart';

class SpendingBloc extends BaseBloc<SpendingEvent, SpendingState>
    with LoaderBlocMixin, ShowMessageBlocMixin {
  late final SectionInteractor _sectionInteractor;
  late final PlanInteractor _planInteractor;

  SpendingBloc(Key key, {
    required SectionInteractor sectionInteractor,
    required PlanInteractor planInteractor,
  })
      : _sectionInteractor = sectionInteractor,
        _planInteractor = planInteractor,
        super(
        key,
        initialState: SpendingInitial(
          initSection: <SectionModel>[],
          initCalculateResult: null,
        ),
      ) {
    on<SpendingGetNextStepStarted>(_onSpendingGetNextStepStarted);
    on<SpendingGetPreviousStepStarted>(_onSpendingGetPreviousStepStarted);
    on<SpendingAnswerFilled>(_onSpendingAnswerFilled);
    on<SpendingCalculateStarted>(_onSpendingCalculateStarted);
  }

  factory SpendingBloc.instance() {
    return BlocManager().newBloc<SpendingBloc>(
        BlocConstants.sectionSpending);
  }

  Future<void> _onSpendingGetNextStepStarted(
      SpendingGetNextStepStarted event,
      Emitter<SpendingState> emit,
      ) async {
    emit(SpendingGetNextStepInProgress(state));

    try {
      List<SectionAnswerModel> currentAnswerFilled = [];
      if (event.nextStep > 1) {
        final validData = state.sectionSpendings.where((e) => e.answerFilled != null).toList();
        if (validData.isNotEmpty) {
          currentAnswerFilled = validData.map((e) => e.answerFilled!).toList();
        }
      }
      final nextSection = await _sectionInteractor.getSectionSpendingQA(
        nextStep: event.nextStep,
        answersFilled: currentAnswerFilled,
      );
      List<SectionModel> latestSections = state.sectionSpendings;
      latestSections.add(nextSection);
      latestSections.toList();

      emit(SpendingGetNextStepSuccess(
        latestSections: latestSections,
      ));
    } catch (err) {
      handleError(err);
      emit(SpendingGetNextStepFailure(state));
    }
  }

  Future<void> _onSpendingGetPreviousStepStarted(
      SpendingGetPreviousStepStarted event,
      Emitter<SpendingState> emit,
      ) async {
    emit(SpendingGetPreviousStepInProgress(state));

    List<SectionModel> latestSections = state.sectionSpendings;
    if (latestSections.isNotEmpty) {
      latestSections.removeLast();
      latestSections.toList();
    }

    emit(SpendingGetPreviousStepSuccess(
      latestSections: latestSections,
    ));
  }

  Future<void> _onSpendingAnswerFilled(
      SpendingAnswerFilled event,
      Emitter<SpendingState> emit,
      ) async {
    emit(SpendingFillAnswerInProgress(state));

    List<SectionModel> latestSections = state.sectionSpendings;
    if (latestSections.isNotEmpty) {
      SectionModel currentQA = latestSections.last;
      currentQA = currentQA.copyWith(
          answerFilled: event.answer
      );
      latestSections.removeLast();
      latestSections.toList();
      latestSections.add(currentQA);
      latestSections.toList();

      emit(SpendingFillAnswerSuccess(
        latestSections: latestSections,
      ));
    }
  }

  Future<void> _onSpendingCalculateStarted(
      SpendingCalculateStarted event,
      Emitter<SpendingState> emit,
      ) async {
    emit(SpendingCalculateInProgress(state));
    final planId = event.planId;
    if (planId.isNullOrEmpty) {
      emit(SpendingCalculateFailure(
        state: state,
        failedType: SpendingCalculateFailureType.missingPlanId,
      ));
      return;
    }

    try {
      final validAnswersFilled = state.sectionSpendings.toValidAnswersFilled;
      if (validAnswersFilled.isNotEmpty) {
        final calculateResult = await _planInteractor.updateSectionSpendingOfPlan(
          planId: planId!,
          answersFilled: validAnswersFilled,
        );
        if (calculateResult != null) {
          emit(SpendingCalculateSuccess(
            state: state,
            calculateResult: calculateResult,
          ));
        }
      }
    } catch (err) {
      handleError(err);
      emit(SpendingCalculateFailure(
        state: state,
        failedType: SpendingCalculateFailureType.api,
      ));
    }
  }
}