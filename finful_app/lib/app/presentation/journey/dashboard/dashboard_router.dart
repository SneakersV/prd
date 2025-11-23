import 'package:finful_app/app/constants/route.dart';
import 'package:finful_app/app/presentation/journey/authentication/sign_in_router.dart';
import 'package:finful_app/app/presentation/journey/section/assumptions/section_assumptions_router.dart';
import 'package:finful_app/app/presentation/journey/section/family_support/section_family_support_router.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/section_onboarding_router.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/section_onboarding_screen.dart';
import 'package:finful_app/app/presentation/journey/section/spending/section_spending_router.dart';
import 'package:finful_app/app/routes/app_routes.dart';
import 'package:finful_app/core/presentation/base_router.dart';
import 'package:flutter/material.dart';

abstract interface class IDashboardRouter {
  void gotoOnboarding();

  void gotoFamilySupport({
    required String planId,
  });

  void gotoSpending({
    required String planId,
  });

  void gotoAssumptions({
    required String planId,
  });

  void replaceWithSignIn();
}

class DashboardRouter extends BaseRouter implements IDashboardRouter {
  DashboardRouter() : super(navigatorKey: AppRoutes.shared.navigatorKey);

  @override
  void gotoFamilySupport({
    required String planId,
  }) {
    final router = SectionFamilySupportRouter(
      planId: planId,
    );
    router.start();
  }

  @override
  void gotoSpending({
    required String planId,
  }) {
    final router = SectionSpendingRouter(
      entryFrom: SectionSpendingEntryFrom.dashboard,
      planId: planId,
    );
    router.start();
  }

  @override
  void gotoAssumptions({
    required String planId,
  }) {
    final router = SectionAssumptionsRouter(
      planId: planId,
      entryFrom: SectionAssumptionsEntryFrom.spending,
    );
    router.start();
  }

  @override
  void gotoOnboarding() {
    final router = SectionOnboardingRouter(
        entryFrom: SectionOnboardingEntryFrom.dashboard,
    );
    router.start();
  }

  @override
  void replaceWithSignIn() {
    final router = SignInRouter(
      entryFrom: SignInEntryFrom.other,
    );
    router.startAndRemoveUntil(null);
  }

  @override
  Future<T?> start<T extends Object?>() {
    throw UnimplementedError();
  }

  void startAndRemoveUntil(bool Function(Route p1)? predicate) {
    pushNamedAndRemoveUntil(
      RouteConstant.dashboard,
      predicate ?? (route) => false,
      router: this,
    );
  }
}