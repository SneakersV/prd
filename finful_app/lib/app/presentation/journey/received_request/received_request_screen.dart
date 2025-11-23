import 'package:finful_app/app/constants/icons.dart';
import 'package:finful_app/app/constants/images.dart';
import 'package:finful_app/app/presentation/blocs/common/session/session.dart';
import 'package:finful_app/app/presentation/journey/received_request/received_request_router.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceivedRequestScreen extends StatefulWidget {
  const ReceivedRequestScreen({super.key});

  @override
  State<ReceivedRequestScreen> createState() => _ReceivedRequestScreenState();
}

class _ReceivedRequestScreenState extends State<ReceivedRequestScreen>
    with BaseScreenMixin<ReceivedRequestScreen, ReceivedRequestRouter> {

  void _onBackPressed() {
    router.pop();
  }

  void _onBackDashboardPressed() {
    router.goBackDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FinfulAppBar(
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
                    top: Dimens.p_91,
                    left: FinfulDimens.md,
                    right: FinfulDimens.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      child: FinfulImage(
                        type: FinfulImageType.asset,
                        source: ImageConstants.imgReceivedRequest,
                        width: Dimens.p_205,
                        height: Dimens.p_205,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: Dimens.p_63,
                    left: Dimens.p_50,
                    right: Dimens.p_50,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          L10n.of(context)
                              .translate('received_request_title'),
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: Dimens.p_29,
                          ),
                          child: Text(
                            L10n.of(context)
                                .translate('received_request_desc'),
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
            ),
          ),
          BlocBuilder<SessionBloc, SessionState>(
            builder: (_, state) {
              if (state.loggedInUser == null) {
                return Positioned(
                  bottom: Dimens.p_12 + context.queryPaddingBottom,
                  left: FinfulDimens.md,
                  right: FinfulDimens.md,
                  child: const SizedBox(),
                );
              }

              return Positioned(
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
                            .translate('common_cta_back_dashboard_btn'),
                        onPressed: _onBackDashboardPressed,
                      ),
                      const SizedBox(height: Dimens.p_12),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
