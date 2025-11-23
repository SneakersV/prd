import 'package:finful_app/app/constants/route.dart';
import 'package:finful_app/app/presentation/journey/authentication/sign_up_router.dart';
import 'package:finful_app/app/routes/app_routes.dart';
import 'package:finful_app/core/presentation/base_router.dart';

abstract interface class ISignUpIntroRouter {
  void gotoSignUp();
}

class SignUpIntroRouter extends BaseRouter implements ISignUpIntroRouter {
  SignUpIntroRouter() : super(navigatorKey: AppRoutes.shared.navigatorKey);

  @override
  void gotoSignUp() {
    final router = SignUpRouter();
    router.start();
  }

  @override
  Future<T?> start<T extends Object?>() {
    return pushNamed(RouteConstant.signUpIntro, router: this);
  }


}