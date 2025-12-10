import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/interactor/plan_interactor.dart';
import 'package:finful_app/app/domain/interactor/section_interactor.dart';
import 'package:finful_app/app/domain/model/extension/extension.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/session_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/exception/api_exception.dart';
import 'package:finful_app/core/extension/string_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'assumptions_event.dart';
import 'assumptions_state.dart';

class AssumptionsBloc extends BaseBloc<AssumptionsEvent, AssumptionsState>
    with LoaderBlocMixin, ShowMessageBlocMixin, SessionBlocMixin {
  late final SectionInteractor _sectionInteractor;
  late final PlanInteractor _planInteractor;

  AssumptionsBloc(Key key, {
    required SectionInteractor sectionInteractor,
    required PlanInteractor planInteractor,
  })
      : _sectionInteractor = sectionInteractor,
        _planInteractor = planInteractor,
        super(
        key,
        initialState: AssumptionsInitial(
          initSection: <SectionModel>[],
          initCalculateResult: null,
        ),
      ) {
    on<AssumptionsGetNextStepStarted>(_onAssumptionsGetNextStepStarted);
    on<AssumptionsGetPreviousStepStarted>(_onAssumptionsGetPreviousStepStarted);
    on<AssumptionsAnswerFilled>(_onAssumptionsAnswerFilled);
    on<AssumptionsCalculateStarted>(_onAssumptionsCalculateStarted);
  }

  factory AssumptionsBloc.instance() {
    return BlocManager().newBloc<AssumptionsBloc>(
        BlocConstants.sectionAssumptions);
  }

  Future<void> _onAssumptionsGetNextStepStarted(
      AssumptionsGetNextStepStarted event,
      Emitter<AssumptionsState> emit,
      ) async {
    emit(AssumptionsGetNextStepInProgress(state));

    try {
      List<SectionAnswerModel> currentAnswerFilled = [];
      if (event.nextStep > 1) {
        final validData = state.sectionAssumptions.where((e) => e.answerFilled != null).toList();
        if (validData.isNotEmpty) {
          currentAnswerFilled = validData.map((e) => e.answerFilled!).toList();
        }
      }
      final nextSection = await _sectionInteractor.getSectionAssumptionsQA(
        nextStep: event.nextStep,
        answersFilled: currentAnswerFilled,
      );
      List<SectionModel> latestSections = state.sectionAssumptions;
      latestSections.add(nextSection);
      latestSections.toList();

      emit(AssumptionsGetNextStepSuccess(
        latestSections: latestSections,
      ));
    } catch (err) {
      handleError(err);
      emit(AssumptionsGetNextStepFailure(state));
    }
  }

  Future<void> _onAssumptionsGetPreviousStepStarted(
      AssumptionsGetPreviousStepStarted event,
      Emitter<AssumptionsState> emit,
      ) async {
    emit(AssumptionsGetPreviousStepInProgress(state));

    List<SectionModel> latestSections = state.sectionAssumptions;
    if (latestSections.isNotEmpty) {
      latestSections.removeLast();
      latestSections.toList();
    }

    emit(AssumptionsGetPreviousStepSuccess(
      latestSections: latestSections,
    ));
  }

  Future<void> _onAssumptionsAnswerFilled(
      AssumptionsAnswerFilled event,
      Emitter<AssumptionsState> emit,
      ) async {
    emit(AssumptionsFillAnswerInProgress(state));

    List<SectionModel> latestSections = state.sectionAssumptions;
    if (latestSections.isNotEmpty) {
      SectionModel currentQA = latestSections.last;
      currentQA = currentQA.copyWith(
          answerFilled: event.answer
      );
      latestSections.removeLast();
      latestSections.toList();
      latestSections.add(currentQA);
      latestSections.toList();

      emit(AssumptionsFillAnswerSuccess(
        latestSections: latestSections,
      ));
    }
  }

  Future<void> _onAssumptionsCalculateStarted(
      AssumptionsCalculateStarted event,
      Emitter<AssumptionsState> emit,
      ) async {
    emit(AssumptionsCalculateInProgress(state));
    final planId = event.planId;
    if (planId.isNullOrEmpty) {
      emit(AssumptionsCalculateFailure(
        state: state,
        failedType: AssumptionsCalculateFailureType.missingPlanId,
      ));
      return;
    }

    try {
      final validAnswersFilled = state.sectionAssumptions.toValidAnswersFilled;
      if (validAnswersFilled.isNotEmpty) {
        final calculateResult = await _planInteractor.updateSectionAssumptionsOfPlan(
          planId: planId!,
          answersFilled: validAnswersFilled,
        );
        if (calculateResult != null) {
          emit(AssumptionsCalculateSuccess(
            state: state,
            calculateResult: calculateResult,
          ));
        }
      }
    } catch (err) {
      handleError(err);
      emit(AssumptionsCalculateFailure(
        state: state,
        failedType: AssumptionsCalculateFailureType.api,
      ));
      if (err is UnauthorisedException) {
        forceUserToLogin401();
      }
    }
  }
}