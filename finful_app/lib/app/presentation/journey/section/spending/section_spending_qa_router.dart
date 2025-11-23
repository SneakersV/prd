import 'package:finful_app/app/constants/route.dart';
import 'package:finful_app/app/presentation/journey/dashboard/dashboard_router.dart';
import 'package:finful_app/app/presentation/journey/section/assumptions/section_assumptions_router.dart';
import 'package:finful_app/app/routes/app_routes.dart';
import 'package:finful_app/core/presentation/base_router.dart';

abstract interface class ISectionSpendingQARouter {
  void gotoSectionAssumptions();

  void goBackDashboard();
}

class SectionSpendingQARouter extends BaseRouter implements ISectionSpendingQARouter {
  SectionSpendingQARouter({
    required this.planId,
  }) : super(navigatorKey: AppRoutes.shared.navigatorKey);

  final String planId;

  @override
  void gotoSectionAssumptions() {
    final router = SectionAssumptionsRouter(
      entryFrom: SectionAssumptionsEntryFrom.spending,
      planId: planId,
    );
    router.start();
  }

  @override
  Future<T?> start<T extends Object?>() {
    return pushNamed(RouteConstant.sectionSpendingQA, router: this);
  }

  @override
  void goBackDashboard() {
    final router = DashboardRouter();
    router.startAndRemoveUntil(null);
  }

}