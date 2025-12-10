import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/interactor/section_interactor.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/session_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/bloc/base/broadcast.dart';
import 'package:finful_app/core/exception/api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_section_progress_event.dart';
import 'get_section_progress_state.dart';

class GetSectionProgressBloc extends BaseBloc<GetSectionProgressEvent, GetSectionProgressState>
    with LoaderBlocMixin, ShowMessageBlocMixin, SessionBlocMixin {
  late final SectionInteractor _sectionInteractor;

  GetSectionProgressBloc(Key key, {
    required SectionInteractor sectionInteractor,
  })
      : _sectionInteractor = sectionInteractor,
        super(
        key,
        closeWithBlocKey: BlocConstants.session,
        initialState: GetSectionProgressInitial(
          initCurrentProgress: null,
        ),
      ) {
    on<GetSectionProgressGetCurrentStarted>(_onGetSectionProgressGetCurrentStarted);
  }

  factory GetSectionProgressBloc.instance() {
    return BlocManager().newBloc<GetSectionProgressBloc>(
        BlocConstants.getSectionProgress);
  }

  @override
  List<Broadcast> subscribes() {
    return [
      Broadcast(
        blocKey: key,
        event: BlocBroadcastEventConstants.justGetSectionProgressRequired,
        onNext: (data) {
          add(GetSectionProgressGetCurrentStarted());
        },
      ),
    ];
  }

  Future<void> _onGetSectionProgressGetCurrentStarted(
      GetSectionProgressGetCurrentStarted event,
      Emitter<GetSectionProgressState> emit,
      ) async {
    emit(GetSectionProgressGetCurrentInProgress(state));

    try {
      final result = await _sectionInteractor.getCurrentSectionProgress();
      emit(GetSectionProgressGetCurrentSuccess(
          currentProgress: result));
    } catch(err) {
      emit(GetSectionProgressGetCurrentFailure(state));
      if (err is UnauthorisedException) {
        forceUserToLogin401();
      }
    }
  }
}