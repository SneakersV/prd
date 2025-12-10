import 'package:equatable/equatable.dart';
import 'package:finful_app/app/domain/model/user_ext_model.dart';

abstract class AccountTabState extends Equatable {
  final UserExtModel? loggedInUserExtraInfo;

  const AccountTabState({
    this.loggedInUserExtraInfo,
  });

  @override
  List<Object?> get props => [
    loggedInUserExtraInfo,
  ];
}

class AccountTabInitial extends AccountTabState {}

class AccountTabGetUserExtraInfoInProgress extends AccountTabState {}

class AccountTabGetUserExtraInfoSuccess extends AccountTabState {
  const AccountTabGetUserExtraInfoSuccess({
    required UserExtModel data,
  }) : super(
      loggedInUserExtraInfo: data,
  );
}

class AccountTabGetUserExtraInfoFailure extends AccountTabState {}

class AccountTabDeleteAccountInProgress extends AccountTabState {
  AccountTabDeleteAccountInProgress(AccountTabState state) : super(
    loggedInUserExtraInfo: state.loggedInUserExtraInfo,
  );
}

class AccountTabDeleteAccountSuccess extends AccountTabState {
  const AccountTabDeleteAccountSuccess() : super(
    loggedInUserExtraInfo: null,
  );
}

class AccountTabDeleteAccountFailure extends AccountTabState {
  AccountTabDeleteAccountFailure(AccountTabState state) : super(
    loggedInUserExtraInfo: state.loggedInUserExtraInfo,
  );
}