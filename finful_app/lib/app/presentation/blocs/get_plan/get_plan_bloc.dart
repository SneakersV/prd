import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/interactor/plan_interactor.dart';
import 'package:finful_app/app/presentation/blocs/get_plan/get_plan_event.dart';
import 'package:finful_app/app/presentation/blocs/get_plan/get_plan_state.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPlanBloc extends BaseBloc<GetPlanEvent, GetPlanState>
    with LoaderBlocMixin, ShowMessageBlocMixin {
  late final PlanInteractor _planInteractor;

  GetPlanBloc(Key key, {
    required PlanInteractor planInteractor,
  })
      : _planInteractor = planInteractor,
        super(
        key,
        initialState: GetPlanInitial(
          initPlan: null,
        ),
      ) {
    on<GetPlanGetCurrentPlanStarted>(_onGetPlanGetCurrentPlanStarted);
  }

  factory GetPlanBloc.instance() {
    return BlocManager().newBloc<GetPlanBloc>(BlocConstants.getPlan);
  }

  Future<void> _onGetPlanGetCurrentPlanStarted(
      GetPlanGetCurrentPlanStarted event,
      Emitter<GetPlanState> emit,
      ) async {
    emit(GetPlanGetCurrentPlanInProgress(state));

    try {
      final currentPlan = await _planInteractor.getCurrentPlan();
      if (currentPlan != null) {
        emit(GetPlanGetCurrentPlanSuccess(
            currentPlan: currentPlan));
      }
    } catch(err) {
      emit(GetPlanGetCurrentPlanFailure(state));
    } finally {
      // broadcast
      // always to fetch latest section progress after call
      // getCurrentPlan without result of this
      BlocManager().broadcast(
        BlocBroadcastEventConstants.justGetSectionProgressRequired,
        params: {},
      );
    }
  }
}