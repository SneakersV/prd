import 'package:finful_app/app/constants/images.dart';
import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/presentation/blocs/section/onboarding/onboarding.dart';
import 'package:finful_app/app/presentation/widgets/app_button/FinfulButton.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/app/theme/dimens.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:finful_app/core/mixin/widget_didmount_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class EducationContentView extends StatefulWidget {
  const EducationContentView({
    super.key,
    this.showDivider = false,
    required this.title,
    required this.description,
    required this.url,
    this.isLast = false,
  });

  final bool showDivider;
  final String? title;
  final String? description;
  final String? url;
  final bool isLast;

  @override
  State<EducationContentView> createState() => _EducationContentViewState();
}

class _EducationContentViewState extends State<EducationContentView>
    with TickerProviderStateMixin, WidgetDidMount<EducationContentView> {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void widgetDidMount(BuildContext context) {

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: FinfulDimens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showDivider) Container(
            decoration: BoxDecoration(
              color: FinfulColor.divider,
            ),
            width: double.infinity,
            height: Dimens.p_3,
            margin: EdgeInsets.only(
              bottom: Dimens.p_23,
            ),
          ) else const SizedBox(),
          if (widget.title.isNotNullAndEmpty)
            Padding(
              padding: EdgeInsets.only(
                bottom: Dimens.p_14,
              ),
              child: Row(
                children: [
                  FinfulImage(
                    type: FinfulImageType.asset,
                    source: ImageConstants.imgQuestionMark,
                    width: Dimens.p_14,
                    height: Dimens.p_14,
                  ),
                  const SizedBox(width: Dimens.p_6),
                  Expanded(
                    child: Text(
                      widget.title!,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: FinfulColor.brandPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ) else const SizedBox(),
          if (widget.description.isNotNullAndEmpty)
            Text(
              widget.description!,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                height: Dimens.p_23 / Dimens.p_16,
                fontWeight: FontWeight.w400,
              ),
            ) else const SizedBox(),
          const SizedBox(height: Dimens.p_60),
          if (widget.url.isNotNullAndEmpty)
            Lottie.network(
              widget.url!,
              controller: _controller,
              width: context.queryWidth,
              height: context.queryWidth * 1.3,
              fit: BoxFit.fill,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ) else const SizedBox(),
          const SizedBox(height: Dimens.p_40),
          if (widget.isLast)
            BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (_, state) {
                return FinfulButton.secondary(
                  title: L10n.of(context)
                      .translate('common_cta_continue'),
                  onPressed: () {
                    final nextStep = state.sectionOnboardings.length + 1;
                    BlocManager().event<OnboardingBloc>(
                      BlocConstants.sectionOnboarding,
                      OnboardingGetNextStepStarted(nextStep: nextStep),
                    );
                  },
                );
              },
            ) else const SizedBox(),
        ],
      ),
    );
  }
}
