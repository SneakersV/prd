
import 'package:finful_app/app/constants/route.dart';
import 'package:finful_app/app/routes/app_routes.dart';
import 'package:finful_app/core/presentation/base_router.dart';

abstract interface class IScheduleExpertRouter {
  void goReceivedRequest();
}

class ScheduleExpertRouter extends BaseRouter implements IScheduleExpertRouter {
  ScheduleExpertRouter() : super(navigatorKey: AppRoutes.shared.navigatorKey);

  @override
  void goReceivedRequest() {
    // TODO: implement goReceivedRequest
  }

  @override
  Future<T?> start<T extends Object?>() {
    return pushNamed(RouteConstant.scheduleExpert, router: this);
  }

}