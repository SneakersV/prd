import 'package:finful_app/app/constants/icons.dart';
import 'package:finful_app/app/constants/images.dart';
import 'package:finful_app/app/presentation/widgets/app_button/FinfulButton.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/app/theme/dimens.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/common/widgets/app_bar/finful_app_bar.dart';
import 'package:finful_app/common/widgets/app_icon/app_icon.dart';
import 'package:finful_app/core/extension/context_extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:finful_app/core/presentation/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'section_spending_router.dart';

class _ContentView extends StatelessWidget {
  const _ContentView({
    super.key,
    required this.showAppBar,
  });

  final bool showAppBar;

  double getPaddingTop(BuildContext context) {
    if (showAppBar) {
      return context.queryPaddingTop + Dimens.p_60;
    }

    return context.queryPaddingTop + Dimens.p_100;
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.p_50,
                  ),
                  child: Text(
                    'Mục 2/3',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: Dimens.p_24,
                      height: Dimens.p_24 / Dimens.p_24,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: Dimens.p_44),
                FinfulImage(
                  type: FinfulImageType.asset,
                  source: ImageConstants.imgFamilySupport,
                  width: Dimens.p_114,
                  height: Dimens.p_114,
                ),
                const SizedBox(height: Dimens.p_48),
                Text(
                  L10n.of(context)
                      .translate('section_spending_title'),
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: Dimens.p_28,
                    height: Dimens.p_24 / Dimens.p_28,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimens.p_18),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.p_36,
                  ),
                  child: Text(
                    L10n.of(context)
                        .translate('section_spending_description'),
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      height: Dimens.p_18 / Dimens.p_14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: Dimens.p_64 + context.queryPaddingBottom,
          ),
        ),
      ],
    );
  }
}

class SectionSpendingScreen extends StatefulWidget {
  const SectionSpendingScreen({
    super.key,
  });

  @override
  State<SectionSpendingScreen> createState() => _SectionSpendingScreenState();
}

class _SectionSpendingScreenState extends State<SectionSpendingScreen>
    with BaseScreenMixin<SectionSpendingScreen, SectionSpendingRouter> {

  void _onBackPressed() {
    if (router.entryFrom == SectionSpendingEntryFrom.familySupport) {
      router.goBackDashboard();
    } else if (router.entryFrom == SectionSpendingEntryFrom.dashboard) {
      router.pop();
    }
  }

  void _onStartFlowPressed() {
    router.gotoQA();
  }

  bool get showAppBar {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) {
          if (didPop) return;

          _onBackPressed();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: FinfulImage(
                type: FinfulImageType.asset,
                source: ImageConstants.imgSpendingBg,
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
              bottom: Dimens.p_12 + context.queryPaddingBottom,
              left: FinfulDimens.md,
              right: FinfulDimens.md,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FinfulButton.secondary(
                      title: L10n.of(context)
                          .translate('section_spending_cta_btn'),
                      onPressed: _onStartFlowPressed,
                    ),
                    SizedBox(height: Dimens.p_18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
