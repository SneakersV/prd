import 'package:finful_app/app/constants/icons.dart';
import 'package:finful_app/app/constants/images.dart';
import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/domain/model/extension/user_ext.dart';
import 'package:finful_app/app/presentation/blocs/account_tab/account_tab.dart';
import 'package:finful_app/app/presentation/blocs/common/session/session.dart';
import 'package:finful_app/app/presentation/journey/account_tab/settings/settings_router.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/app/theme/dimens.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/common/widgets/app_bar/finful_app_bar.dart';
import 'package:finful_app/common/widgets/app_icon/app_icon.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:finful_app/core/presentation/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _Divider extends StatelessWidget {
  const _Divider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Dimens.p_1,
      color: FinfulColor.white.withValues(alpha: 0.3),
    );
  }
}

class _ContentWrapper extends StatelessWidget {
  const _ContentWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FinfulColor.cardBg,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.p_8)),
      ),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.p_15,
        horizontal: Dimens.p_10,
      ),
      child: child,
    );
  }
}

class _ContentTile extends StatelessWidget {
  const _ContentTile({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: context.queryWidth * 0.23,
          child: Text(
            label,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: FinfulColor.textSetting,
              fontSize: Dimens.p_15,
              height: Dimens.p_14 / Dimens.p_15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: Dimens.p_24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: FinfulColor.textW,
                  fontSize: Dimens.p_17,
                  height: Dimens.p_14 / Dimens.p_17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: Dimens.p_8),
              _Divider(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContentFormHeader extends StatelessWidget {
  const _ContentFormHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: FinfulColor.textW,
            fontSize: Dimens.p_17,
            height: Dimens.p_14 / Dimens.p_17,
          ),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    super.key,
    required this.onPressed,
    required this.title,
    this.showIcon = true,
  });

  final VoidCallback onPressed;
  final String title;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.all(Radius.circular(Dimens.p_8)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.p_15,
          horizontal: Dimens.p_10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: FinfulColor.textSetting,
                fontSize: Dimens.p_15,
                height: Dimens.p_14 / Dimens.p_15,
              ),
            ),
            if (showIcon)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: FinfulColor.white.withValues(alpha: 0.8),
                size: Dimens.p_12,
              ) else const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with BaseScreenMixin<SettingsScreen, SettingsRouter> {

  void _onBackPressed() {
    router.pop();
  }

  void _onLogoutPressed() {
    BlocManager().event<SessionBloc>(
      BlocConstants.session,
      SessionUserLogOutSubmitted(),
    );
  }

  void _onDeleteAccountPressed() {
    BlocManager().event<AccountTabBloc>(
      BlocConstants.accountTabBar,
      AccountTabDeleteAccountSubmitted(),
    );
  }

  void _onPolicyPressed() {
    router.gotoPolicy();
  }

  void _onTermPressed() {
    router.gotoTerm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: FinfulAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        forceMaterialTransparency: true,
        title: L10n.of(context)
            .translate('setting_screen_header_title'),
        titleStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.w500,
        ),
        leadingIcon: AppSvgIcon(
          IconConstants.icBack,
          width: FinfulDimens.iconMd,
          height: FinfulDimens.iconMd,
          color: FinfulColor.white,
        ),
        onLeadingPressed: _onBackPressed,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              height: Dimens.p_3,
              color: FinfulColor.disabled,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: Dimens.p_20,
              right: Dimens.p_20,
              top: Dimens.p_20,
            ),
            sliver: SliverToBoxAdapter(
              child: BlocBuilder<SessionBloc, SessionState>(
                builder: (_, state) {
                  final imageUrl = state.loggedInUser?.imageUrl;
                  final avatar = imageUrl.isNotNullAndEmpty ?
                  imageUrl : ImageConstants.imgDefaultAvatar;
                  return Center(
                    child: FinfulImage(
                      type: FinfulImageType.asset,
                      source: avatar,
                      borderRadius: BorderRadius.circular(Dimens.p_60),
                      width: Dimens.p_120,
                      height: Dimens.p_120,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: Dimens.p_20,
              right: Dimens.p_20,
              top: Dimens.p_46,
            ),
            sliver: SliverToBoxAdapter(
              child: BlocBuilder<SessionBloc, SessionState>(
                builder: (_, state) {
                  final displayName = state.loggedInUser?.toFullName ?? "";
                  final username = state.loggedInUser?.email ?? "";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ContentFormHeader(
                        title: L10n.of(context)
                            .translate('setting_tile_info_header_label'),
                      ),
                      const SizedBox(height: Dimens.p_15),
                      _ContentWrapper(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ContentTile(
                              label: L10n.of(context)
                                  .translate('setting_tile_info_header_name'),
                              value: displayName,
                            ),
                            const SizedBox(height: Dimens.p_16),
                            _ContentTile(
                              label: L10n.of(context)
                                  .translate('setting_tile_info_header_username'),
                              value: username,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: Dimens.p_20,
              right: Dimens.p_20,
              top: Dimens.p_35,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ContentFormHeader(
                    title: L10n.of(context)
                        .translate('setting_tile_general_header_label'),
                  ),
                  const SizedBox(height: Dimens.p_15),
                  Container(
                    decoration: BoxDecoration(
                      color: FinfulColor.cardBg,
                      borderRadius: BorderRadius.all(Radius.circular(Dimens.p_8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SettingTile(
                          title: L10n.of(context)
                              .translate('setting_tile_general_header_policy'),
                          onPressed: _onPolicyPressed,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.p_10,
                          ),
                          child: _Divider(),
                        ),
                        _SettingTile(
                          title: L10n.of(context)
                              .translate('setting_tile_general_header_term'),
                          onPressed: _onTermPressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: Dimens.p_20,
              right: Dimens.p_20,
              top: Dimens.p_35,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ContentFormHeader(
                    title: L10n.of(context)
                        .translate('setting_tile_account_header_label'),
                  ),
                  const SizedBox(height: Dimens.p_15),
                  Container(
                    decoration: BoxDecoration(
                      color: FinfulColor.cardBg,
                      borderRadius: BorderRadius.all(Radius.circular(Dimens.p_8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SettingTile(
                          title: L10n.of(context)
                              .translate('setting_tile_account_header_logout'),
                          showIcon: false,
                          onPressed: _onLogoutPressed,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.p_10,
                          ),
                          child: _Divider(),
                        ),
                        _SettingTile(
                          title: L10n.of(context)
                              .translate('setting_tile_account_header_deleteAccount'),
                          showIcon: false,
                          onPressed: _onDeleteAccountPressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: Dimens.p_40 + context.queryPaddingBottom,
            ),
          ),
        ],
      ),
    );
  }
}
