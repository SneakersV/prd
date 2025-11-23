import 'package:finful_app/app/constants/route.dart';
import 'package:finful_app/app/presentation/journey/authentication/sign_in_router.dart';
import 'package:finful_app/app/routes/app_routes.dart';
import 'package:finful_app/core/presentation/base_router.dart';

abstract interface class ISignUpRouter {
  void gotoSignInAuto({
    required String email,
    required String password,
  });

  void gotoSignIn();
}

class SignUpRouter extends BaseRouter implements ISignUpRouter {
  SignUpRouter() : super(navigatorKey: AppRoutes.shared.navigatorKey);

  @override
  void gotoSignInAuto({
    required String email,
    required String password,
  }) {
    final router = SignInRouter(
      email: email,
      password: password,
      entryFrom: SignInEntryFrom.signUp,
    );
    router.start();
  }

  @override
  void gotoSignIn() {
    final router = SignInRouter(
      entryFrom: SignInEntryFrom.signUp,
    );
    router.start();
  }

  @override
  Future<T?> start<T extends Object?>() {
    return pushNamed(RouteConstant.signUp, router: this);
  }

}

