import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/interactor/auth_interactor.dart';
import 'package:finful_app/app/presentation/blocs/common/show_message/show_message_event.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/app/presentation/blocs/signup/signup.dart';
import 'package:finful_app/core/bloc/base/base_bloc.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends BaseBloc<SignUpEvent, SignUpState>
    with LoaderBlocMixin, ShowMessageBlocMixin {
  late final AuthInteractor _authInteractor;

  SignUpBloc(Key key, {
    required AuthInteractor authInteractor,
  })
      : _authInteractor = authInteractor,
        super(
        key,
        initialState: SignUpInitial(),
      ) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  factory SignUpBloc.instance() {
    return BlocManager().newBloc<SignUpBloc>(BlocConstants.signUp);
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event,
      Emitter<SignUpState> emit,
      ) async {
    emit(SignUpInProgress());
    showAppLoading();

    try {
      final result = await _authInteractor.submitSignUp(
          email: event.email,
          password: event.password,
          firstName: event.firstName,
          lastName: event.lastName
      );
      if (result.userId.isNotNullAndEmpty) {
        emit(SignUpSuccess(
          email: event.email,
          password: event.password,
        ));
      } else {
        showSnackBarMessage(
          type: ShowMessageSnackBarType.error,
          title: 'sign_up_failed',
          message: 'common_error_something_went_wrong_message',
        );
        emit(SignUpFailure());
      }
    } catch (err) {
      handleError(err);
      emit(SignUpFailure());
    } finally {
      hideAppLoading();
    }
  }
}
