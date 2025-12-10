import 'package:equatable/equatable.dart';
import 'package:finful_app/app/data/model/user.dart';

abstract class SessionState extends Equatable {
  final User? loggedInUser;

  const SessionState({
    this.loggedInUser,
  });

  @override
  List<Object?> get props => [
    loggedInUser,
  ];
}

class SessionRunInitial extends SessionState {
  const SessionRunInitial() : super();
}

class SessionGetUserInfoRunSuccess extends SessionState {
  const SessionGetUserInfoRunSuccess(User? user) : super(
      loggedInUser: user,
  );
}

class SessionUserLoggedInInProgress extends SessionState {
  SessionUserLoggedInInProgress(SessionState state) : super(
      loggedInUser: state.loggedInUser,
  );
}

class SessionUserLoggedInSuccess extends SessionState {
  const SessionUserLoggedInSuccess(SessionState state, {
    required User user
  }) : super(
    loggedInUser: user,
  );
}

class SessionReadyToLogInSuccess extends SessionState {
  const SessionReadyToLogInSuccess() : super();
}

class SessionSignOutInProgress extends SessionState {
  SessionSignOutInProgress(SessionState state) : super(
    loggedInUser: state.loggedInUser,
  );
}

class SessionSignOutSuccess extends SessionState {
  const SessionSignOutSuccess() : super(
    loggedInUser: null,
  );
}

class SessionSignOutFailure extends SessionState {
  SessionSignOutFailure(SessionState state) : super(
    loggedInUser: state.loggedInUser,
  );
}

// expired token
class SessionForceUserSignInInProgress extends SessionState {
  SessionForceUserSignInInProgress(SessionState state) : super(
    loggedInUser: state.loggedInUser
  );
}

class SessionForceUserSignInSuccess extends SessionState {
  const SessionForceUserSignInSuccess() : super(
    loggedInUser: null,
  );
}

class SessionForceUserSignInFailure extends SessionState {
  SessionForceUserSignInFailure(SessionState state) : super(
      loggedInUser: state.loggedInUser
  );
}
