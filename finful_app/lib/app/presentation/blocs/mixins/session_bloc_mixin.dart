import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';

import '../common/session/session.dart';

mixin SessionBlocMixin {
  void forceUserToLoginAfterRefreshTokenFailed() {
    BlocManager().event<SessionBloc>(
      BlocConstants.session,
      SessionForceUserSignInStarted(),
    );
  }

  void forceUserToLogin401() {
    BlocManager().event<SessionBloc>(
      BlocConstants.session,
      SessionForceUserSignInStarted(),
    );
  }

  void forceUserToLoginAfterLogoutOrDeleteAccountSucceed() {
    BlocManager().event<SessionBloc>(
      BlocConstants.session,
      SessionForceUserSignInStarted(),
    );
  }

  SessionState get getSessionState {
    return BlocManager().blocFromKey<SessionBloc>(
        BlocConstants.session)!.state;
  }
}