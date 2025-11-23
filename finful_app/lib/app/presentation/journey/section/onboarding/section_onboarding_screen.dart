import 'package:finful_app/app/constants/constants.dart';
import 'package:finful_app/app/presentation/blocs/create_plan/create_plan_bloc.dart';
import 'package:finful_app/app/presentation/blocs/create_plan/create_plan_state.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/section_onboarding_router.dart';
import 'package:finful_app/app/presentation/widgets/app_button/FinfulButton.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/theme/theme.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/common/widgets/app_bar/finful_app_bar.dart';
import 'package:finful_app/common/widgets/app_icon/app_icon.dart';
import 'package:finful_app/core/extension/context_extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:finful_app/core/presentation/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FinfulColor.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusLg)),
        border: Border.all(
          color: FinfulColor.white,
          width: Dimens.p_1,
          style: BorderStyle.solid,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: FinfulDimens.xxs,
            right: FinfulDimens.xxs,
            child: FinfulImage(
              type: FinfulImageType.asset,
              source: image,
              width: Dimens.p_29,
              height: Dimens.p_29,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: Dimens.p_17,
              left: Dimens.p_22,
              right: Dimens.p_9,
              bottom: Dimens.p_15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: Dimens.p_17,
                    color: FinfulColor.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Dimens.p_5),
                Text(
                  description,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: Dimens.p_13,
                    height: Dimens.p_18 / Dimens.p_13,
                    color: FinfulColor.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView({
    super.key,
    required this.showAppBar,
  });

  final bool showAppBar;

  double getPaddingTop(BuildContext context) {
    if (showAppBar) {
      return context.queryPaddingTop + Dimens.p_38;
    }

    return context.queryPaddingTop + Dimens.p_78;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: getPaddingTop(context),
            left: FinfulDimens.md,
            right: FinfulDimens.md,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Text(
                  'Chào mừng bạn đến với Finful',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: Dimens.p_21,
                    height: Dimens.p_33 / Dimens.p_21,
                    color: FinfulColor.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Người đồng hành cùng bạn mua nhà',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: Dimens.p_33 / Dimens.p_18,
                    color: FinfulColor.white,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimens.p_15),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: FinfulImage(
                    type: FinfulImageType.asset,
                    source: ImageConstants.imgOnboarding,
                    width: Dimens.p_194,
                    height: Dimens.p_198,
                  ),
                ),
                const SizedBox(height: FinfulDimens.sm),
                _ContentCard(
                  title: 'Chúng tôi có thể',
                  description: 'Tính toán và chỉ ra tất cả các con đường giúp bạn mua được nhà, từ tiết kiệm đến đầu tư, vay vốn.',
                  image: ImageConstants.imgChecked,
                ),
                const SizedBox(height: FinfulDimens.sm),
                _ContentCard(
                  title: 'Chúng tôi không thể',
                  description: 'Quyết định thay bạn. Chúng tôi chỉ nhận nhu cầu, tình hình và để bạn tự chọn con đường phù hợp.',
                  image: ImageConstants.imgDeclined,
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: Dimens.p_104 + Dimens.p_12 + context.queryPaddingBottom,
          ),
        ),
      ],
    );
  }
}

enum SectionOnboardingEntryFrom { splash, dashboard }

class SectionOnboardingScreen extends StatefulWidget {
  const SectionOnboardingScreen({super.key});

  @override
  State<SectionOnboardingScreen> createState() => _SectionOnboardingScreenState();
}

class _SectionOnboardingScreenState extends State<SectionOnboardingScreen>
    with BaseScreenMixin<SectionOnboardingScreen, SectionOnboardingRouter> {

  void _onLoginPressed() {
    router.gotoSignIn();
  }

  void _onBackPressed() {
    router.pop();
  }

  void _onStartFlowPressed() {
    router.gotoQA();
  }

  bool get showAppBar {
    bool canPop = Navigator.canPop(context);
    return router.entryFrom == SectionOnboardingEntryFrom.dashboard && canPop;
  }

  bool get showSignUpFlowBtn {
    return router.entryFrom == SectionOnboardingEntryFrom.splash;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreatePlanBloc>(
          create: (_) => CreatePlanBloc.instance(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CreatePlanBloc, CreatePlanState>(
            listener: (_, state) {},
          ),
        ],
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, _) {
            _onBackPressed();
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: FinfulImage(
                  type: FinfulImageType.asset,
                  source: ImageConstants.imgOnboardingBg,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned.fill(
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.transparent,
                  appBar: showAppBar ? FinfulAppBar(
                    forceMaterialTransparency: true,
                    leadingIcon: AppSvgIcon(
                      IconConstants.icBack,
                      width: FinfulDimens.iconMd,
                      height: FinfulDimens.iconMd,
                      color: FinfulColor.white,
                    ),
                    onLeadingPressed: _onBackPressed,
                  ) : null,
                  body: _ContentView(
                    showAppBar: showAppBar,
                  ),
                ),
              ),
              Positioned(
                bottom: context.queryPaddingBottom,
                left: FinfulDimens.md,
                right: FinfulDimens.md,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FinfulButton.secondary(
                        title: L10n.of(context)
                            .translate('section_onboarding_start_btn'),
                        onPressed: _onStartFlowPressed,
                      ),
                      if (showSignUpFlowBtn)
                        Padding(
                          padding: EdgeInsets.only(
                            top: FinfulDimens.xs,
                            bottom: FinfulDimens.xs,
                          ),
                          child: FinfulButton.border(
                            title: L10n.of(context)
                                .translate('common_cta_signin'),
                            borderColor: FinfulColor.white,
                            isBare: true,
                            onPressed: _onLoginPressed,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
