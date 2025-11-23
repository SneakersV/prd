import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/constants/route.dart';
import 'package:finful_app/app/presentation/blocs/create_plan/create_plan.dart';
import 'package:finful_app/app/presentation/blocs/section/assumptions/assumptions_bloc.dart';
import 'package:finful_app/app/presentation/blocs/section/family_support/family_support_bloc.dart';
import 'package:finful_app/app/presentation/blocs/section/onboarding/onboarding.dart';
import 'package:finful_app/app/presentation/blocs/section/spending/spending.dart';
import 'package:finful_app/app/presentation/blocs/signin/signin.dart';
import 'package:finful_app/app/presentation/blocs/signup/signup.dart';
import 'package:finful_app/app/presentation/journey/authentication/sign_in_screen.dart';
import 'package:finful_app/app/presentation/journey/authentication/sign_up_screen.dart';
import 'package:finful_app/app/presentation/journey/authentication/signup_intro_screen.dart';
import 'package:finful_app/app/presentation/journey/dashboard/dashboard_screen.dart';
import 'package:finful_app/app/presentation/journey/dev_mode_screen.dart';
import 'package:finful_app/app/presentation/journey/received_request/received_request_screen.dart';
import 'package:finful_app/app/presentation/journey/schedule_expert/schedule_expert_screen.dart';
import 'package:finful_app/app/presentation/journey/section/assumptions/section_assumptions_qa_screen.dart';
import 'package:finful_app/app/presentation/journey/section/assumptions/section_assumptions_screen.dart';
import 'package:finful_app/app/presentation/journey/section/family_support/section_family_support_qa_screen.dart';
import 'package:finful_app/app/presentation/journey/section/family_support/section_family_support_screen.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/section_onboarding_qa_screen.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/section_onboarding_screen.dart';
import 'package:finful_app/app/presentation/journey/section/spending/section_spending_qa_screen.dart';
import 'package:finful_app/app/presentation/journey/section/spending/section_spending_screen.dart';
import 'package:finful_app/app/presentation/journey/splash/splash_router.dart';
import 'package:finful_app/app/presentation/journey/splash/splash_screen.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  late final GlobalKey<NavigatorState> navigatorKey;

  factory AppRoutes() => _instance;

  static final _instance = AppRoutes._();

  AppRoutes._() : navigatorKey = GlobalKey<NavigatorState>();

  static AppRoutes get shared => _instance;

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstant.splash:
        return const SplashScreen().buildPage(
          settings: RouteSettings(
            name: settings.name,
            arguments: SplashRouter(),
          ),
        );
      case RouteConstant.signUpIntro:
        return const SignUpIntroScreen().buildPage(settings: settings);
      case RouteConstant.signUp:
        return BlocProvider<SignUpBloc>(
          create: (_) => SignUpBloc.instance(),
          child: const SignUpScreen(),
        ).buildPage(settings: settings);
      case RouteConstant.signIn:
        final createPlanBloc = BlocManager().blocFromKey<CreatePlanBloc>(
            BlocConstants.createPlan);
        return MultiBlocProvider(
            providers: [
              BlocProvider<SignInBloc>(
                create: (_) => SignInBloc.instance(),
              ),
              BlocProvider<CreatePlanBloc>.value(
                value: createPlanBloc!,
              ),
            ],
            child: const SignInScreen()
        ).buildPage(settings: settings);
      case RouteConstant.sectionOnboarding:
        return const SectionOnboardingScreen().buildPage(settings: settings);
      case RouteConstant.sectionOnboardingQA:
        final createPlanBloc = BlocManager().blocFromKey<CreatePlanBloc>(
            BlocConstants.createPlan);
        return MultiBlocProvider(
            providers: [
              BlocProvider<OnboardingBloc>(
                create: (_) => OnboardingBloc.instance(),
              ),
              BlocProvider<CreatePlanBloc>.value(
                value: createPlanBloc!,
              ),
            ],
            child: const SectionOnboardingQAScreen()
        ).buildPage(settings: settings);
      case RouteConstant.sectionFamilySupport:
        return const SectionFamilySupportScreen().buildPage(settings: settings);
      case RouteConstant.sectionFamilySupportQA:
        return BlocProvider<FamilySupportBloc>(
          create: (_) => FamilySupportBloc.instance(),
          child: const SectionFamilySupportQAScreen(),
        ).buildPage(settings: settings);
      case RouteConstant.sectionSpending:
        return const SectionSpendingScreen().buildPage(settings: settings);
      case RouteConstant.sectionSpendingQA:
        return BlocProvider<SpendingBloc>(
          create: (_) => SpendingBloc.instance(),
          child: const SectionSpendingQAScreen(),
        ).buildPage(settings: settings);
      case RouteConstant.sectionAssumptions:
        return const SectionAssumptionsScreen().buildPage(settings: settings);
      case RouteConstant.sectionAssumptionsQA:
        return BlocProvider<AssumptionsBloc>(
          create: (_) => AssumptionsBloc.instance(),
          child: const SectionAssumptionsQAScreen(),
        ).buildPage(settings: settings);
      case RouteConstant.receivedRequest:
        return const ReceivedRequestScreen().buildPage(settings: settings);
      case RouteConstant.scheduleExpert:
        return const ScheduleExpertScreen().buildPage(settings: settings);
      case RouteConstant.dashboard:
        return const DashboardScreen().buildPage(settings: settings);
      case RouteConstant.devMode:
        return const DevModeScreen().buildPage(settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route found for ${settings.name}'),
            ),
          ),
        );
    }
  }
}