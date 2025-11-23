import 'package:finful_app/app/constants/route.dart';
import 'package:finful_app/app/presentation/journey/authentication/sign_in_router.dart';
import 'package:finful_app/app/presentation/journey/dashboard/dashboard_router.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/section_onboarding_router.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/section_onboarding_screen.dart';
import 'package:finful_app/app/routes/app_routes.dart';
import 'package:finful_app/core/presentation/base_router.dart';

abstract interface class ISplashRouter {
  void gotoOnboarding();

  void gotoDashboard();

  void gotoSignIn();
}

class SplashRouter extends BaseRouter implements ISplashRouter {
  SplashRouter() : super(navigatorKey: AppRoutes.shared.navigatorKey);

  @override
  void gotoDashboard() {
    final router = DashboardRouter();
    router.startAndRemoveUntil(null);
  }

  @override
  void gotoOnboarding() {
    final router = SectionOnboardingRouter(
      entryFrom: SectionOnboardingEntryFrom.splash,
    );
    router.startAndRemoveUntil(null);
  }

  @override
  void gotoSignIn() {
    final router = SignInRouter(
      entryFrom: SignInEntryFrom.other,
    );
    router.startAndRemoveUntil(null);
  }

  @override
  Future<T?> start<T extends Object?>() {
    return pushNamed(RouteConstant.splash, router: this);
  }
}
