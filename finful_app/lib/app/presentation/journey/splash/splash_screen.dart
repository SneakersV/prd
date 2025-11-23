import 'package:finful_app/app/constants/constants.dart';
import 'package:finful_app/app/presentation/blocs/common/session/session.dart';
import 'package:finful_app/app/presentation/journey/splash/splash_router.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/common/widgets/app_icon/app_icon.dart';
import 'package:finful_app/core/presentation/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with BaseScreenMixin<SplashScreen, SplashRouter> {

  void _processAfterUserLoggedInSuccess() {
    router.gotoDashboard();
  }

  void _processGotoOnBoarding() {
    router.gotoOnboarding();
  }

  void _processGotoSignIn() {
    router.gotoSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (_, state) {
        if (state is SessionGetUserInfoRunSuccess) {
          _processAfterUserLoggedInSuccess();
        } else if (state is SessionReadyToLogInSuccess) {
          _processGotoOnBoarding();
        } else if (state is SessionForceUserSignInSuccess) {
          _processGotoSignIn();
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: FinfulColor.brandPrimary,
            child: const Center(
              child: AppSvgIcon(
                IconConstants.icEmail,
                width: Dimens.p_194,
                height: Dimens.p_198,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
