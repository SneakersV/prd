
import 'package:finful_app/app/constants/constants.dart';
import 'package:finful_app/app/presentation/journey/authentication/signup_intro_router.dart';
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

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    super.key,
    required this.title,
    required this.desc,
    required this.image,
  });

  final String title;
  final String desc;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FinfulColor.cardBg,
        borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusLg)),
        border: Border.all(
          width: Dimens.p_1,
          color: FinfulColor.cardBorder,
          style: BorderStyle.solid,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.p_20,
        vertical: Dimens.p_12,
      ),
      child: Row(
        children: [
          FinfulImage(
            type: FinfulImageType.asset,
            source: image,
            width: Dimens.p_36,
            height: Dimens.p_36,
          ),
          const SizedBox(width: Dimens.p_20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    height: Dimens.p_14 / Dimens.p_14,
                  ),
                ),
                const SizedBox(height: Dimens.p_6),
                Text(
                  desc,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: FinfulColor.grey3,
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


class SignUpIntroScreen extends StatefulWidget {
  const SignUpIntroScreen({super.key});

  @override
  State<SignUpIntroScreen> createState() => _SignUpIntroScreenState();
}

class _SignUpIntroScreenState extends State<SignUpIntroScreen>
  with BaseScreenMixin<SignUpIntroScreen, SignUpIntroRouter> {

  void _onBackPressed() {
    router.pop();
  }

  void _onPressed() {
    router.gotoSignUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: FinfulAppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        leadingIcon: AppSvgIcon(
          IconConstants.icBack,
          width: FinfulDimens.iconMd,
          height: FinfulDimens.iconMd,
          color: FinfulColor.white,
        ),
        onLeadingPressed: _onBackPressed,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: FinfulDimens.xl,
                    left: FinfulDimens.md,
                    right: FinfulDimens.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.p_36,
                          ),
                          child: Text(
                            L10n.of(context)
                                .translate('signup_intro_title'),
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: FinfulColor.grey3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Dimens.p_50,
                            right: Dimens.p_50,
                            top: Dimens.p_16,
                          ),
                          child: Text(
                            L10n.of(context)
                                .translate('signup_intro_subtitle'),
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: Dimens.p_64,
                    left: FinfulDimens.md,
                    right: FinfulDimens.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _ContentCard(
                          title: L10n.of(context)
                              .translate('signup_intro_card_1_title'),
                          desc: L10n.of(context)
                              .translate('signup_intro_card_1_desc'),
                          image: ImageConstants.imgSignUpIntroCard1,
                        ),
                        const SizedBox(height: Dimens.p_12),
                        _ContentCard(
                          title: L10n.of(context)
                              .translate('signup_intro_card_2_title'),
                          desc: L10n.of(context)
                              .translate('signup_intro_card_2_desc'),
                          image: ImageConstants.imgSignUpIntroCard2,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                      height: FinfulDimens.sm + Dimens.p_46 + context.queryPaddingBottom,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: FinfulDimens.md,
            right: FinfulDimens.md,
            bottom: Dimens.p_12 + context.queryPaddingBottom,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FinfulButton.primary(
                  title: L10n.of(context)
                      .translate('signup_intro_cta_btn'),
                  color: FinfulColor.btnPrimary,
                  onPressed: _onPressed,
                ),
                const SizedBox(height: FinfulDimens.sm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
