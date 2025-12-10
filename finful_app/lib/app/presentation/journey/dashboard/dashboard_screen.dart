import 'package:finful_app/app/constants/icons.dart';
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
import 'package:finful_app/app/presentation/journey/account_tab/account_tab.dart';
import 'package:finful_app/app/presentation/journey/dashboard/dashboard_router.dart';
import 'package:finful_app/app/presentation/journey/dashboard/ui_model/dashboard_tabbar_item.dart';
import 'package:finful_app/app/presentation/journey/info_tab/info_tab.dart';
import 'package:finful_app/app/theme/theme.dart';
import 'package:finful_app/app/utils/utils.dart';
import 'package:finful_app/common/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:finful_app/core/presentation/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui_model/section_dashboard_item.dart';
import 'package:url_launcher/url_launcher.dart';

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

    _ensureGetLatestPlanData();
    super.didMountWidget();
  }

  @override
  void didResume() {
    super.didResume();
    _startGetCurrentPlan();
  }

  void _ensureGetLatestPlanData() {
    Future.delayed(const Duration(seconds: 3), () {
      _startGetCurrentPlan();
    });
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

  void _onSettingPressed() {
    router.gotoSettings();
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

  Future<void> _onRefresh() async {
    await forceDelay();
    _startGetCurrentPlan();
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

  List<DashboardTabBarItem> _tabBarItems() {
    return [
      DashboardTabBarItem(
        assetPath: IconConstants.icInfoTabBar,
        activeAssetPath: IconConstants.icInfoTabBar,
        label: L10n.of(context).translate('dashboard_info_tab'),
      ),
      // DashboardTabBarItem(
      //   assetPath: IconConstants.icPlanTabBar,
      //   activeAssetPath: IconConstants.icPlanTabBar,
      //   label: L10n.of(context).translate('dashboard_plan_tab'),
      // ),
      DashboardTabBarItem(
        assetPath: IconConstants.icAccountTabBar,
        activeAssetPath: IconConstants.icAccountTabBar,
        label: L10n.of(context).translate('dashboard_account_tab'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tabBarItems = _tabBarItems();

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
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                InfoTab(
                  sectionItems: _sectionItems,
                  onSectionItemPressed: _onSectionItemPressed,
                  onStaticSchedulePressed: _onStaticSchedulePressed,
                ),
                AccountTab(
                  onSettingPressed: _onSettingPressed,
                ),
              ],
            ),
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            iconSize: FinfulDimens.iconMd,
            selectedIndex: _currentTabIndex,
            showElevation: true,
            backgroundColor: FinfulColor.black12,
            onItemSelected: (index) => setState(() {
              _currentTabIndex = index;
              _pageController.jumpToPage(index);
            }),
            items: tabBarItems
                .map(
                  (item) => AppBottomNavBarItem.svg(
                assetPath: item.assetPath,
                activeAssetPath: item.activeAssetPath,
                title: item.label,
                activeColor: FinfulColor.tabBarActiveColor,
                inactiveColor: FinfulColor.tabBarInactiveColor,
              ),
            ).toList(),
          ),
        ),
      ),
    );
  }
}




