import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/interactor/auth_interactor.dart';
import 'package:finful_app/app/domain/interactor/user_interactor.dart';
import 'package:finful_app/app/injection/injection.dart';
import 'package:finful_app/app/presentation/blocs/common/show_message/show_message_event.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/app/presentation/blocs/signin/signin_event.dart';
import 'package:finful_app/app/presentation/blocs/signin/signin_state.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/datasource/config.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBloc extends BaseBloc<SignInEvent, SignInState>
    with LoaderBlocMixin, ShowMessageBlocMixin {
  late final AuthInteractor _authInteractor;
  late final UserInteractor _userInteractor;

  SignInBloc(Key key, {
    required AuthInteractor authInteractor,
    required UserInteractor userInteractor,
  })
      : _authInteractor = authInteractor,
        _userInteractor = userInteractor,
        super(
        key,
        initialState: SignInInitial(),
      ) {
    on<SignInSubmitted>(_onSignInSubmitted);
  }

  factory SignInBloc.instance() {
    return BlocManager().newBloc<SignInBloc>(BlocConstants.signIn);
  }

  Future<void> _onSignInSubmitted(
      SignInSubmitted event,
      Emitter<SignInState> emit,
      ) async {
    showAppLoading();
    emit(SignInInProgress());
    try {
      final result = await _authInteractor.submitSignIn(
          email: event.email,
          password: event.password);
      if (result != null &&
          result.userId != null &&
          result.token.isNotNullAndEmpty) {
        final authorization = Authorization(
          accessToken: result.token,
          refreshToken: null,
          userId: result.userId,
        );
        Injection().authorization = authorization;
        await _authInteractor.saveAuthorizationToLocal(authorization: authorization);
        final userInfo = await _userInteractor.getLoggedInUser(
            forceToUpdate: true,
            userId: result.userId
        );
        if (userInfo != null) {
          await _userInteractor.saveLoggedInUserToLocal(userInfo);
          emit(SignInSuccess(
              email: event.email,
              userInfo: userInfo,
          ));
          // broadcast
          BlocManager().broadcast(
            BlocBroadcastEventConstants.justLoggedIn,
            params: {
              BlocBroadcastEventConstants.userData: userInfo,
            },
          );
        } else {
          showSnackBarMessage(
            type: ShowMessageSnackBarType.warning,
            title: 'log_in_succeed',
            message: 'log_in_succeed_message',
          );
          emit(SignInWithoutUserInfoSuccess(state));
        }
      }
    } catch (err) {
      handleError(err);
      emit(SignInFailure());
    } finally {
      hideAppLoading();
    }
  }
}