import 'package:finful_app/app/constants/route.dart';
import 'package:finful_app/app/presentation/journey/dashboard/dashboard_router.dart';
import 'package:finful_app/app/presentation/journey/section/spending/section_spending_router.dart';
import 'package:finful_app/app/routes/app_routes.dart';
import 'package:finful_app/core/presentation/base_router.dart';

abstract interface class ISectionFamilySupportQARouter {
  void gotoSectionSpending();

  void goBackDashboard();
}

class SectionFamilySupportQARouter extends BaseRouter implements ISectionFamilySupportQARouter {
  SectionFamilySupportQARouter({
    required this.planId,
  }) : super(navigatorKey: AppRoutes.shared.navigatorKey);

  final String planId;

  @override
  void gotoSectionSpending() {
    final router = SectionSpendingRouter(
      entryFrom: SectionSpendingEntryFrom.familySupport,
      planId: planId,
    );
    router.start();
  }

  @override
  Future<T?> start<T extends Object?>() {
    return pushNamed(RouteConstant.sectionFamilySupportQA, router: this);
  }

  @override
  void goBackDashboard() {
    final router = DashboardRouter();
    router.startAndRemoveUntil(null);
  }
}