import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/interactor/plan_interactor.dart';
import 'package:finful_app/app/presentation/blocs/create_plan/create_plan_event.dart';
import 'package:finful_app/app/presentation/blocs/create_plan/create_plan_state.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/session_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/exception/api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePlanBloc extends BaseBloc<CreatePlanEvent, CreatePlanState>
    with LoaderBlocMixin, ShowMessageBlocMixin, SessionBlocMixin {
  late final PlanInteractor _planInteractor;

  CreatePlanBloc(Key key, {
    required PlanInteractor planInteractor,
  })
      : _planInteractor = planInteractor,
        super(
        key,
        closeWithBlocKey: BlocConstants.session,
        initialState: CreatePlanInitial(),
      ) {
    on<CreatePlanStarted>(_onCreatePlanStarted);
    on<CreatePlanFromDraftDataStarted>(_onCreatePlanFromDraftDataStarted);
  }

  factory CreatePlanBloc.instance() {
    return BlocManager().newBloc<CreatePlanBloc>(BlocConstants.createPlan);
  }

  Future<void> _onCreatePlanStarted(
      CreatePlanStarted event,
      Emitter<CreatePlanState> emit,
      ) async {
    emit(CreatePlanInProgress());

    try {
      final newPlan = await _planInteractor.submitCreatePlan(
          answersFilled: event.answersFilled);
      if (newPlan != null) {
        emit(CreatePlanSuccess(createdPlan: newPlan));
      }
    } catch (err) {
      emit(CreatePlanFailure());
    }
  }

  Future<void> _onCreatePlanFromDraftDataStarted(
      CreatePlanFromDraftDataStarted event,
      Emitter<CreatePlanState> emit,
      ) async {
    emit(CreatePlanFromDraftDataInProgress());

    try {
      final newPlan = await _planInteractor.submitCreatePlan(
        answersFilled: event.answersFilled,
      );
      if (newPlan != null) {
        emit(CreatePlanFromDraftDataSuccess(createdPlan: newPlan));
      }
    } catch (err) {
      emit(CreatePlanFromDraftDataFailure());
      if (err is UnauthorisedException) {
        forceUserToLogin401();
      }
    }
  }
}