import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/data/model/user.dart';
import 'package:finful_app/app/domain/interactor/auth_interactor.dart';
import 'package:finful_app/app/domain/interactor/session_interactor.dart';
import 'package:finful_app/app/domain/interactor/user_interactor.dart';
import 'package:finful_app/app/injection/injection.dart';
import 'package:finful_app/app/presentation/blocs/common/show_message/show_message_event.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/session_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/bloc/base/broadcast.dart';
import 'package:finful_app/core/exception/api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends BaseBloc<SessionEvent, SessionState>
    with LoaderBlocMixin, ShowMessageBlocMixin, SessionBlocMixin {
  late final SessionInteractor _sessionInteractor;
  late final UserInteractor _userInteractor;
  late final AuthInteractor _authInteractor;

  SessionBloc(Key key, {
    required SessionInteractor sessionInteractor,
    required UserInteractor userInteractor,
    required AuthInteractor authInteractor,
  })
      : _sessionInteractor = sessionInteractor,
        _userInteractor = userInteractor,
        _authInteractor = authInteractor,
        super(
        key,
        initialState: SessionRunInitial(),
      ) {
    on<SessionLoaded>(_onSessionLoaded);
    on<SessionUserLoggedIn>(_onSessionUserLoggedIn);
    on<SessionUserLogOutSubmitted>(_onSessionUserLogOutSubmitted);
    on<SessionForceUserSignInStarted>(_onSessionForceUserSignInStarted);
  }

  factory SessionBloc.instance() {
    return BlocManager().newBloc<SessionBloc>(BlocConstants.session);
  }

  @override
  List<Broadcast> subscribes() {
    return [
      Broadcast(
        blocKey: key,
        event: BlocBroadcastEventConstants.justLoggedIn,
        onNext: (data) {
          final User loggedInUser = data[BlocBroadcastEventConstants.userData];

          add(SessionUserLoggedIn(loggedInUser));
        },
      ),
    ];
  }

  Future<void> _onSessionLoaded(
      SessionLoaded event,
      Emitter<SessionState> emit,
      ) async {
    final authorization = _sessionInteractor.getLoggedInAuthorization();
    final userLocal = _userInteractor.getLoggedInUserFromLocal();
    if (authorization != null && userLocal != null) {
      Injection().authorization = authorization;
      debugPrint('''
              SESSION LOADED
                >> TOKEN >> ${Injection().authorization!.accessToken}
            ''');
      try {
        final loggedInUser = await _userInteractor.getLoggedInUser(
          forceToUpdate: true,
          userId: userLocal.userId,
        );
        emit(SessionGetUserInfoRunSuccess(loggedInUser));
      } catch (err) {
        if (err is UnauthorisedException) {
          emit(SessionForceUserSignInInProgress(state));
          emit(SessionForceUserSignInSuccess());
        } else {
          final loggedInUser = await _userInteractor.getLoggedInUser(
            forceToUpdate: false,
            userId: null,
          );
          emit(SessionGetUserInfoRunSuccess(loggedInUser));
        }
      }
    } else {
      emit(SessionReadyToLogInSuccess());
    }
  }

  Future<void> _onSessionUserLoggedIn(
      SessionUserLoggedIn event,
      Emitter<SessionState> emit,
      ) async {
    emit(SessionUserLoggedInInProgress(state));
    emit(SessionUserLoggedInSuccess(state, user: event.loggedInUser));
  }

  Future<void> _onSessionUserLogOutSubmitted(
      SessionUserLogOutSubmitted event,
      Emitter<SessionState> emit,
      ) async {
    showAppLoading();
    emit(SessionSignOutInProgress(state));
    try {
      final success = await _authInteractor.submitLogout();
      if (success) {
        emit(SessionSignOutSuccess());
        forceUserToLoginAfterLogoutOrDeleteAccountSucceed();
      } else {
        showSnackBarMessage(
          type: ShowMessageSnackBarType.error,
          title: 'common_error_logout_failed',
          message: 'common_error_logout_failed_message',
        );
        emit(SessionSignOutFailure(state));
      }
    } catch (err) {
      handleError(err);
      emit(SessionSignOutFailure(state));
    } finally {
      hideAppLoading();
    }
  }

  Future<void> _onSessionForceUserSignInStarted(
      SessionForceUserSignInStarted event,
      Emitter<SessionState> emit,
      ) async {
    showAppLoading();
    emit(SessionForceUserSignInInProgress(state));
    try {
      await _sessionInteractor.clearSessionDataAtLocal();
      emit(SessionForceUserSignInSuccess());
    } catch (err) {
      emit(SessionForceUserSignInFailure(state));
    } finally {
      hideAppLoading();
    }
  }

}