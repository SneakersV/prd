import 'package:finful_app/app/constants/route.dart';
import 'package:finful_app/app/presentation/journey/dashboard/dashboard_router.dart';
import 'package:finful_app/app/routes/app_routes.dart';
import 'package:finful_app/core/presentation/base_router.dart';

import 'section_assumptions_qa_router.dart';

enum SectionAssumptionsEntryFrom { spending, dashboard }

abstract interface class ISectionAssumptionsRouter {
  void gotoQA();

  void goBackDashboard();
}

class SectionAssumptionsRouter extends BaseRouter implements ISectionAssumptionsRouter {
  SectionAssumptionsRouter({
    required this.entryFrom,
    required this.planId,
  }) : super(navigatorKey: AppRoutes.shared.navigatorKey);

  final SectionAssumptionsEntryFrom entryFrom;
  final String planId;

  @override
  void gotoQA() {
    final router = SectionAssumptionsQARouter(
      planId: planId,
    );
    router.start();
  }

  @override
  Future<T?> start<T extends Object?>() {
    return pushNamed(RouteConstant.sectionAssumptions, router: this);
  }

  @override
  void goBackDashboard() {
    final router = DashboardRouter();
    router.startAndRemoveUntil(null);
  }
}