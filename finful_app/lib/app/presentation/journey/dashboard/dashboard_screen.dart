import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/domain/model/extension/section_progress_ext.dart';
import 'package:finful_app/app/presentation/blocs/common/session/session_bloc.dart';
import 'package:finful_app/app/presentation/blocs/common/session/session_state.dart';
import 'package:finful_app/app/presentation/blocs/common/show_message/show_message_event.dart';
import 'package:finful_app/app/presentation/blocs/get_plan/get_plan.dart';
import 'package:finful_app/app/presentation/blocs/get_section_progress/get_section_progress.dart';
import 'package:finful_app/app/presentation/blocs/mixins/get_plan_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/get_section_progress_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/session_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/show_message_mixin.dart';
import 'package:finful_app/app/presentation/journey/dashboard/dashboard_router.dart';
import 'package:finful_app/app/presentation/journey/dashboard/widgets/dashboard_none_final_plan_content.dart';
import 'package:finful_app/app/utils/utils.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/presentation/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui_model/section_dashboard_item.dart';
import 'package:url_launcher/url_launcher.dart';

class _TabBarItem {
  final String icon;
  final String activeIcon;
  final String label;

  _TabBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with BaseScreenMixin<DashboardScreen, DashboardRouter>,
        SessionBlocMixin, GetPlanBlocMixin, GetSectionProgressMixin,
        ShowMessageBlocMixin {
  int _currentTabIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  bool _isFinalPlan = false;
  List<SectionDashboardItem> _sectionItems = [];

  List<SectionDashboardItem> get _defaultInitSectionItems {
    return [
      SectionDashboardItem(
        isCompleted: false,
        isActivated: true,
        sectionType: SectionType.onboarding,
      ),
      SectionDashboardItem(
        isCompleted: false,
        isActivated: false,
        sectionType: SectionType.familySupport,
      ),
      SectionDashboardItem(
        isCompleted: false,
        isActivated: false,
        sectionType: SectionType.spending,
      ),
      SectionDashboardItem(
        isCompleted: false,
        isActivated: false,
        sectionType: SectionType.assumptions,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _sectionItems = _defaultInitSectionItems;
  }

  @override
  void didMountWidget() {
    _startGetCurrentPlan();
    super.didMountWidget();
  }

  @override
  void didResume() {
    super.didResume();
    _startGetCurrentPlan();
  }

  void _startGetCurrentPlan() {
    final sessionState = getSessionState;
    final loggedInUser = sessionState.loggedInUser;
    if (loggedInUser != null) {
      BlocManager().event<GetPlanBloc>(
        BlocConstants.getPlan,
        GetPlanGetCurrentPlanStarted(),
      );
    }
  }

  void _onSectionItemPressed(SectionDashboardItem item) {
    final planState = getPlanState;
    final sectionProgressState = getSectionProgressState;
    final currentPlan = planState.currentPlan;
    // neu ko co planId o getPlanState thi lay planId o getSectionProgressState
    final currentPlanId = currentPlan?.planId ??
        sectionProgressState.currentProgress?.planId;
    switch (item.sectionType) {
      case SectionType.onboarding:
        if (currentPlanId.isNullOrEmpty) {
          router.gotoOnboarding();
        }
        break;
      case SectionType.familySupport:
        if (currentPlanId.isNotNullAndEmpty) {
          router.gotoFamilySupport(
            planId: currentPlanId!,
          );
        }
        break;
      case SectionType.spending:
        if (currentPlanId.isNotNullAndEmpty) {
          router.gotoSpending(
            planId: currentPlanId!,
          );
        }
        break;
      case SectionType.assumptions:
        if (currentPlanId.isNotNullAndEmpty) {
          router.gotoAssumptions(
            planId: currentPlanId!,
          );
        }
      default:
    }
  }

  Future<void> _onStaticSchedulePressed() async {
    final meetingLink = "https://cal.com/tuan-nguyen-finful/45min";
    final url = Uri.tryParse(meetingLink);
    if (url == null) return;

    if (!await launchUrl(url)) {
      showSnackBarMessage(
        type: ShowMessageSnackBarType.error,
        title: 'common_link_error_title',
        message: 'common_link_error_message',
      );
      return;
    }
  }

  void _handleGetCurrentSectionProgressSuccess(GetSectionProgressGetCurrentSuccess state) {
    final currentProgress = state.currentProgress;
    if (currentProgress != null) {
      final updatedSectionItems = [
        SectionDashboardItem(
          isCompleted: currentProgress.isSectionOnboardingCompleted,
          isActivated: currentProgress.isSectionOnboardingActivated,
          sectionType: SectionType.onboarding,
        ),
        SectionDashboardItem(
          isCompleted: currentProgress.isSectionFamilySupportCompleted,
          isActivated: currentProgress.isSectionFamilySupportActivated,
          sectionType: SectionType.familySupport,
        ),
        SectionDashboardItem(
          isCompleted: currentProgress.isSectionSpendingCompleted,
          isActivated: currentProgress.isSectionSpendingActivated,
          sectionType: SectionType.spending,
        ),
        SectionDashboardItem(
          isCompleted: currentProgress.isSectionAssumptionsCompleted,
          isActivated: currentProgress.isSectionAssumptionsActivated,
          sectionType: SectionType.assumptions,
        ),
      ];
      setState(() {
        _sectionItems = updatedSectionItems;
      });
    }
  }

  void _noneFinalPlanRefresh() {
    _startGetCurrentPlan();
  }

  void _finalPlanRefresh() {

  }

  Future<void> _onRefresh() async {
    await forceDelay();
    if (!_isFinalPlan) {
      _noneFinalPlanRefresh();
      return;
    }

    _finalPlanRefresh();
  }

  void _sessionBlocListener(BuildContext context, SessionState state) {
    switch (state.runtimeType) {
      case SessionForceUserSignInSuccess:
        router.replaceWithSignIn();
        break;
      default:
    }
  }

  void _getPlanBlocListener(BuildContext context, GetPlanState state) {
  }

  void _getSectionProgressBlocListener(BuildContext context, GetSectionProgressState state) {
    switch (state.runtimeType) {
      case GetSectionProgressGetCurrentSuccess:
        _handleGetCurrentSectionProgressSuccess(state as GetSectionProgressGetCurrentSuccess);
        break;
      default:
    }
  }

  List<BlocListener> get _mapToBlocListeners {
    return [
      BlocListener<SessionBloc, SessionState>(
        listener: _sessionBlocListener,
      ),
      BlocListener<GetPlanBloc, GetPlanState>(
        listener: _getPlanBlocListener,
      ),
      BlocListener<GetSectionProgressBloc, GetSectionProgressState>(
        listener: _getSectionProgressBlocListener,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetPlanBloc>(
          create: (_) => GetPlanBloc.instance(),
        ),
        BlocProvider<GetSectionProgressBloc>(
          create: (_) => GetSectionProgressBloc.instance(),
        ),
      ],
      child: MultiBlocListener(
        listeners: _mapToBlocListeners,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
          drawerEdgeDragWidth: 0.0,
          endDrawerEnableOpenDragGesture: false,
          drawerEnableOpenDragGesture: false,
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: !_isFinalPlan ?
            DashboardNoneFinalPlanContent(
              sectionItems: _sectionItems,
              onSectionItemPressed: _onSectionItemPressed,
              onStaticSchedulePressed: _onStaticSchedulePressed,
            ) : Container(),
          ),
        ),
      ),
    );
  }
}




