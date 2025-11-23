import 'package:finful_app/app/constants/route.dart';
import 'package:finful_app/app/presentation/journey/authentication/sign_in_router.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/section_onboarding_qa_router.dart';
import 'package:finful_app/app/routes/app_routes.dart';
import 'package:finful_app/core/presentation/base_router.dart';
import 'package:flutter/material.dart';

import 'section_onboarding_screen.dart';

abstract interface class ISectionOnboardingRouter {
  void gotoQA();

  void gotoSignIn();
}

class SectionOnboardingRouter extends BaseRouter implements ISectionOnboardingRouter {
  SectionOnboardingRouter({
    required this.entryFrom,
  }) : super(navigatorKey: AppRoutes.shared.navigatorKey);

  final SectionOnboardingEntryFrom entryFrom;

  @override
  void gotoQA() {
    final router = SectionOnboardingQARouter(
      entryFrom: entryFrom
    );
    router.start();
  }

  @override
  void gotoSignIn() {
    final router = SignInRouter(
      entryFrom: SignInEntryFrom.other,
    );
    router.start();
  }

  @override
  Future<T?> start<T extends Object?>() {
    return pushNamed(RouteConstant.sectionOnboarding, router: this);
  }

  void startAndRemoveUntil(bool Function(Route p1)? predicate) {
    pushNamedAndRemoveUntil(
      RouteConstant.sectionOnboarding,
      predicate ?? (route) => false,
      router: this,
    );
  }

}

