import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/interactor/user_interactor.dart';
import 'package:finful_app/app/presentation/blocs/account_tab/account_tab_event.dart';
import 'package:finful_app/app/presentation/blocs/account_tab/account_tab_state.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/session_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/exception/api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountTabBloc extends BaseBloc<AccountTabEvent, AccountTabState>
  with ShowMessageBlocMixin, LoaderBlocMixin, SessionBlocMixin {
  late final UserInteractor _userInteractor;

  AccountTabBloc(Key key, {
    required UserInteractor userInteractor,
  })
      :_userInteractor = userInteractor,
        super(
        key,
        initialState: AccountTabInitial(),
      ) {
    on<AccountTabGetUserExtraInfoStarted>(_onAccountTabGetUserExtraInfoStarted);
    on<AccountTabDeleteAccountSubmitted>(_onAccountTabDeleteAccountSubmitted);
  }

  factory AccountTabBloc.instance() {
    return BlocManager().newBloc<AccountTabBloc>(BlocConstants.accountTabBar);
  }

  Future<void> _onAccountTabGetUserExtraInfoStarted(
      AccountTabGetUserExtraInfoStarted event,
      Emitter<AccountTabState> emit,
      ) async {
    emit(AccountTabGetUserExtraInfoInProgress());

    try {
      final result = await _userInteractor.getCurrentUserExtraInfo();
      emit(AccountTabGetUserExtraInfoSuccess(data: result));
    } catch (err) {
      emit(AccountTabGetUserExtraInfoFailure());
      if (err is UnauthorisedException) {
        forceUserToLogin401();
      }
    }
  }

  Future<void> _onAccountTabDeleteAccountSubmitted(
      AccountTabDeleteAccountSubmitted event,
      Emitter<AccountTabState> emit,
      ) async {
    showAppLoading();
    emit(AccountTabDeleteAccountInProgress(state));
    try {
      final success = await _userInteractor.submitDeleteAccount();
      if (success) {
        emit(AccountTabDeleteAccountSuccess());
        forceUserToLoginAfterLogoutOrDeleteAccountSucceed();
      }
    } catch (err) {
      handleError(err);
      emit(AccountTabDeleteAccountFailure(state));
      if (err is UnauthorisedException) {
        forceUserToLogin401();
      }
    } finally {
      hideAppLoading();
    }
  }
}