import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/interactor/plan_interactor.dart';
import 'package:finful_app/app/domain/interactor/section_interactor.dart';
import 'package:finful_app/app/domain/model/extension/section_ext.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/session_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/app/presentation/blocs/section/family_support/family_support_event.dart';
import 'package:finful_app/app/presentation/blocs/section/family_support/family_support_state.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/exception/api_exception.dart';
import 'package:finful_app/core/extension/string_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FamilySupportBloc extends BaseBloc<FamilySupportEvent, FamilySupportState>
    with LoaderBlocMixin, ShowMessageBlocMixin, SessionBlocMixin {
  late final SectionInteractor _sectionInteractor;
  late final PlanInteractor _planInteractor;

  FamilySupportBloc(Key key, {
    required SectionInteractor sectionInteractor,
    required PlanInteractor planInteractor,
  })
      : _sectionInteractor = sectionInteractor,
        _planInteractor = planInteractor,
        super(
        key,
        initialState: FamilySupportInitial(
          initSection: <SectionModel>[],
        ),
      ) {
    on<FamilySupportGetNextStepStarted>(_onFamilySupportGetNextStepStarted);
    on<FamilySupportGetPreviousStepStarted>(_onFamilySupportGetPreviousStepStarted);
    on<FamilySupportAnswerFilled>(_onFamilySupportAnswerFilled);
    on<FamilySupportSubmitAnswerStarted>(_onFamilySupportSubmitAnswerStarted);
  }

  factory FamilySupportBloc.instance() {
    return BlocManager().newBloc<FamilySupportBloc>(
        BlocConstants.sectionFamilySupport);
  }

  Future<void> _onFamilySupportGetNextStepStarted(
      FamilySupportGetNextStepStarted event,
      Emitter<FamilySupportState> emit,
      ) async {
    emit(FamilySupportGetNextStepInProgress(state));

    try {
      List<SectionAnswerModel> currentAnswerFilled = [];
      if (event.nextStep > 1) {
        final validData = state.sectionFamilySupports.where((e) => e.answerFilled != null).toList();
        if (validData.isNotEmpty) {
          currentAnswerFilled = validData.map((e) => e.answerFilled!).toList();
        }
      }
      final nextSection = await _sectionInteractor.getSectionFamilySupportQA(
        nextStep: event.nextStep,
        answersFilled: currentAnswerFilled,
      );
      List<SectionModel> latestSections = state.sectionFamilySupports;
      latestSections.add(nextSection);
      latestSections.toList();

      emit(FamilySupportGetNextStepSuccess(
        latestSections: latestSections,
      ));
    } catch (err) {
      handleError(err);
      emit(FamilySupportGetNextStepFailure(state));
    }
  }

  Future<void> _onFamilySupportGetPreviousStepStarted(
      FamilySupportGetPreviousStepStarted event,
      Emitter<FamilySupportState> emit,
      ) async {
    emit(FamilySupportGetPreviousStepInProgress(state));

    List<SectionModel> latestSections = state.sectionFamilySupports;
    if (latestSections.isNotEmpty) {
      latestSections.removeLast();
      latestSections.toList();
    }

    emit(FamilySupportGetPreviousStepSuccess(
      latestSections: latestSections,
    ));
  }

  Future<void> _onFamilySupportAnswerFilled(
      FamilySupportAnswerFilled event,
      Emitter<FamilySupportState> emit,
      ) async {
    emit(FamilySupportFillAnswerInProgress(state));

    List<SectionModel> latestSections = state.sectionFamilySupports;
    if (latestSections.isNotEmpty) {
      SectionModel currentQA = latestSections.last;
      currentQA = currentQA.copyWith(
          answerFilled: event.answer
      );
      latestSections.removeLast();
      latestSections.toList();
      latestSections.add(currentQA);
      latestSections.toList();

      emit(FamilySupportFillAnswerSuccess(
        latestSections: latestSections,
      ));
    }
  }

  Future<void> _onFamilySupportSubmitAnswerStarted(
      FamilySupportSubmitAnswerStarted event,
      Emitter<FamilySupportState> emit,
      ) async {
    emit(FamilySupportSubmitAnswerInProgress(state));
    final planId = event.planId;
    if (planId.isNullOrEmpty) {
      emit(FamilySupportSubmitAnswerFailure(
        state: state,
        failedType: FamilySupportSubmitAnswerFailureType.missingPlanId,
      ));
      return;
    }

    try {
      final validAnswersFilled = state.sectionFamilySupports.toValidAnswersFilled;
      if (validAnswersFilled.isNotEmpty) {
        await _planInteractor.updateSectionFamilySupportOfPlan(
          planId: planId!,
          answersFilled: validAnswersFilled,
        );
        emit(FamilySupportSubmitAnswerSuccess(state: state));
      }
    } catch (err) {
      handleError(err);
      emit(FamilySupportSubmitAnswerFailure(
        state: state,
        failedType: FamilySupportSubmitAnswerFailureType.api,
      ));
      if (err is UnauthorisedException) {
        forceUserToLogin401();
      }
    }
  }
}