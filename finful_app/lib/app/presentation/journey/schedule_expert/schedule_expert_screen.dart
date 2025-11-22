import 'package:finful_app/app/constants/icons.dart';
import 'package:finful_app/app/constants/images.dart';
import 'package:finful_app/app/presentation/journey/schedule_expert/schedule_expert_router.dart';
import 'package:finful_app/app/presentation/widgets/app_button/FinfulButton.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/presentation/widgets/app_input/FinfulTextInput.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/app/theme/dimens.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/common/widgets/app_bar/finful_app_bar.dart';
import 'package:finful_app/common/widgets/app_icon/app_icon.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:finful_app/core/presentation/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    super.key,
    required this.title,
    required this.desc,
  });

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: context.queryWidth * 0.3,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: FinfulColor.textWOpacity80,
            ),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            desc,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.w400,
              color: FinfulColor.textWOpacity80,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _InfoView extends StatelessWidget {
  const _InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FinfulColor.cardBg,
        borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusLg)),
      ),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.p_14,
        horizontal: Dimens.p_20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: FinfulColor.brandPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(Dimens.p_10)),
                ),
                width: Dimens.p_10,
                height: Dimens.p_10,
              ),
              const SizedBox(width: Dimens.p_12),
              Text(
                L10n.of(context)
                    .translate('schedule_expert_info_label'),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  height: Dimens.p_16 / Dimens.p_16,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.p_15),
          _InfoTile(
            title: L10n.of(context)
                .translate('schedule_expert_info_label'),
            desc: L10n.of(context)
                .translate('schedule_expert_info_time_desc'),
          ),
          const SizedBox(height: Dimens.p_9),
          _InfoTile(
            title: L10n.of(context)
                .translate('schedule_expert_info_fee_label'),
            desc: L10n.of(context)
                .translate('schedule_expert_info_fee_desc'),
          ),
          const SizedBox(height: Dimens.p_9),
          _InfoTile(
            title: L10n.of(context)
                .translate('schedule_expert_info_content_label'),
            desc: L10n.of(context)
                .translate('schedule_expert_info_content_desc'),
          ),
          const SizedBox(height: Dimens.p_45),
        ],
      ),
    );
  }
}

class _TransferInfoView extends StatelessWidget {
  const _TransferInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final bankAccountNumber = L10n.of(context).translate('schedule_expert_transfer_info_bank_account_number');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.of(context).translate('schedule_expert_transfer_info_label'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Dimens.p_16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FinfulImage(
              type: FinfulImageType.asset,
              source: ImageConstants.imgQRFinfulBank,
              width: Dimens.p_124,
              height: Dimens.p_143,
            ),
            const SizedBox(width: Dimens.p_29),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10n.of(context).translate('schedule_expert_transfer_info_bank_name'),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: Dimens.p_15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: Dimens.p_6),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: bankAccountNumber));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: FinfulColor.cardBg,
                          content: Text(
                            L10n.of(context).translate('common_copied_text'),
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              fontSize: Dimens.p_15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          bankAccountNumber,
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: FinfulColor.brandPrimary,
                            fontSize: Dimens.p_15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: Dimens.p_10),
                        Icon(
                          Icons.copy_outlined,
                          color: FinfulColor.white,
                          size: FinfulDimens.iconMd,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.p_6),
                  Text(
                    L10n.of(context).translate('schedule_expert_transfer_info_bank_account_name'),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: Dimens.p_15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: Dimens.p_30),
                  Text(
                    L10n.of(context).translate('schedule_expert_transfer_info_bank_note'),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class ScheduleExpertScreen extends StatefulWidget {
  const ScheduleExpertScreen({super.key});

  @override
  State<ScheduleExpertScreen> createState() => _ScheduleExpertScreenState();
}

class _ScheduleExpertScreenState extends State<ScheduleExpertScreen>
    with BaseScreenMixin<ScheduleExpertScreen, ScheduleExpertRouter> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  late TextEditingController _nameController;
  final FocusNode _nameNode = FocusNode();
  late TextEditingController _phoneController;
  final FocusNode _phoneNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    _nameController.dispose();
    _nameNode.dispose();
    _phoneController.dispose();
    _phoneNode.dispose();
    super.dispose();
  }

  void _handleUnFocus() {
    if (_focusScopeNode.hasFocus) {
      _focusScopeNode.unfocus();
    }
  }

  void _onSubmitPressed() {

  }

  Future<void> _onBackPressed() async {
    _handleUnFocus();
    await Future.delayed(Duration(milliseconds: 300));
    router.pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FinfulAppBar(
        forceMaterialTransparency: true,
        title: L10n.of(context)
            .translate('schedule_expert_header_title'),
        leadingIcon: AppSvgIcon(
          IconConstants.icBack,
          width: FinfulDimens.iconMd,
          height: FinfulDimens.iconMd,
          color: FinfulColor.white,
        ),
        onLeadingPressed: _onBackPressed,
      ),
      body: GestureDetector(
        onTap: _handleUnFocus,
        child: Form(
          key: _formKey,
          child: FocusScope(
            node: _focusScopeNode,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    color: FinfulColor.disabled,
                    height: Dimens.p_3,
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: Dimens.p_15,
                    left: FinfulDimens.md,
                    right: FinfulDimens.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _InfoView(),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: Dimens.p_35,
                    left: FinfulDimens.md,
                    right: FinfulDimens.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          L10n.of(context)
                              .translate('schedule_expert_info_name_input_label'),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: Dimens.p_10,
                          ),
                          child: FinfulTextInput.single(
                            controller: _nameController,
                            focusNode: _nameNode,
                            backgroundColor: FinfulColor.textFieldBgColor,
                            height: FinfulTextInputHeight.md,
                            hintText: L10n.of(context)
                                .translate('schedule_expert_name_hint'),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.go,
                          ),
                        ),
                        const SizedBox(height: Dimens.p_25),
                        Text(
                          L10n.of(context)
                              .translate('schedule_expert_info_phone_input_label'),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: Dimens.p_10,
                          ),
                          child: FinfulTextInput.single(
                            controller: _phoneController,
                            focusNode: _phoneNode,
                            backgroundColor: FinfulColor.textFieldBgColor,
                            height: FinfulTextInputHeight.md,
                            hintText: L10n.of(context)
                                .translate('schedule_expert_phone_hint'),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: Dimens.p_25,
                    left: FinfulDimens.md,
                    right: FinfulDimens.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _TransferInfoView(),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: Dimens.p_54,
                    left: FinfulDimens.md,
                    right: FinfulDimens.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: FinfulButton.secondary(
                      title: L10n.of(context)
                          .translate('schedule_expert_submit_request'),
                      onPressed: () {

                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Dimens.p_14 + context.queryPaddingBottom,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
