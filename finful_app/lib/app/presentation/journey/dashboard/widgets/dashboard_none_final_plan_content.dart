import 'package:finful_app/app/constants/constants.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/domain/model/extension/extension.dart';
import 'package:finful_app/app/presentation/blocs/common/session/session.dart';
import 'package:finful_app/app/presentation/blocs/get_section_progress/get_section_progress.dart';
import 'package:finful_app/app/presentation/journey/dashboard/ui_model/section_dashboard_item.dart';
import 'package:finful_app/app/presentation/journey/dashboard/widgets/dashboard_static_schedule.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/presentation/widgets/app_loading/finful_skeleton_loading.dart';
import 'package:finful_app/app/theme/theme.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _HeaderView extends StatelessWidget {
  const _HeaderView({super.key});

  String greetingTxt(BuildContext context, SessionState state) {
    final greetingTxt = L10n.of(context).translate('dashboard_greeting');
    final dummyName = L10n.of(context).translate('common_dummy_name');
    final loggedInUser = state.loggedInUser;
    final fullName = loggedInUser != null ? loggedInUser.toFullName : dummyName;
    return "$greetingTxt, $fullName!";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (_, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                greetingTxt(context, state),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  height: Dimens.p_14/ Dimens.p_16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: Dimens.p_40),
            FinfulImage(
              type: FinfulImageType.asset,
              source: ImageConstants.imgDefaultCard,
              borderRadius: BorderRadius.circular(Dimens.p_20),
              width: Dimens.p_40,
              height: Dimens.p_40,
            ),
          ],
        );
      },
    );
  }
}

class _SubHeaderView extends StatelessWidget {
  const _SubHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            L10n.of(context).translate('dashboard_none_finalPlan_subHeader_title'),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: FinfulColor.textWOpacity60,
              height: Dimens.p_18/ Dimens.p_12,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ),
        SizedBox(width: context.queryWidth * 0.4),
      ],
    );
  }
}

class _SectionItemView extends StatelessWidget {
  const _SectionItemView({
    super.key,
    required this.isCompleted,
    required this.isActivated,
    required this.bgImage,
    required this.image,
    required this.content,
    required this.isEnd,
    required this.onPressed,
  });

  final bool isCompleted;
  final bool isActivated;
  final String bgImage;
  final String image;
  final String content;
  final bool isEnd;
  final VoidCallback onPressed;

  double get cardWidth => Dimens.p_180 * 1.08;

  double get cardHeight => Dimens.p_180;

  BorderRadius get cardRadius => BorderRadius.all(Radius.circular(Dimens.p_10));

  String _statusTxt(BuildContext context) {
    if (isCompleted) {
      return L10n.of(context).translate('dashboard_section_completed_btn_title');
    }

    if (isActivated) {
      return L10n.of(context).translate('dashboard_section_start_btn_title');
    }

    return L10n.of(context).translate('dashboard_section_inactive_btn_title');
  }

  bool get isDisabledCard {
    return !isActivated || isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: cardRadius,
      ),
      margin: EdgeInsets.only(
        left: Dimens.p_18,
        right: isEnd ? Dimens.p_18 : Dimens.p_0,
      ),
      child: AbsorbPointer(
        absorbing: isDisabledCard,
        child: InkWell(
          onTap: onPressed,
          borderRadius: cardRadius,
          child: AnimatedOpacity(
            opacity: isDisabledCard ? 0.5 : 1.0,
            duration: Duration(milliseconds: 300),
            child: ClipRRect(
              borderRadius: cardRadius,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FinfulImage(
                      type: FinfulImageType.asset,
                      source: bgImage,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.p_20,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FinfulImage(
                              type: FinfulImageType.asset,
                              source: image,
                              width: Dimens.p_44,
                              height: Dimens.p_44,
                            ),
                            const SizedBox(height: Dimens.p_11),
                            Text(
                              content,
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                height: Dimens.p_17/ Dimens.p_14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: Dimens.p_18),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimens.p_8,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FinfulColor.bgOpacity25,
                                  borderRadius: BorderRadius.all(Radius.circular(Dimens.p_5)),
                                  border: Border.all(
                                    width: Dimens.p_1,
                                    color: FinfulColor.white,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: Dimens.p_10,
                                  horizontal: Dimens.p_15,
                                ),
                                child: Text(
                                  _statusTxt(context),
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    height: Dimens.p_14/ Dimens.p_12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionItemLoading extends StatelessWidget {
  const _SectionItemLoading({
    required this.isEnd,
  });

  final bool isEnd;

  double get cardWidth => Dimens.p_180 * 1.08;
  double get cardHeight => Dimens.p_180;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.only(
        left: Dimens.p_18,
        right: isEnd ? Dimens.p_18 : Dimens.p_0,
      ),
      child: FinfulSkeletonLoading(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.p_10)),
          child: Container(
            decoration: BoxDecoration(
              color: FinfulColor.blackBaseSkeletonColor,
              borderRadius: BorderRadius.all(Radius.circular(Dimens.p_10)),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.p_20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: Dimens.p_44,
                        height: Dimens.p_44,
                        color: FinfulColor.blackHighLightSkeletonColor,
                      ),
                      SizedBox(height: Dimens.p_11),
                      Container(
                        height: Dimens.p_20,
                        width: Dimens.p_120,
                        color: FinfulColor.blackHighLightSkeletonColor,
                      ),
                      SizedBox(height: Dimens.p_18),
                      Container(
                        height: Dimens.p_40,
                        width: Dimens.p_140,
                        decoration: BoxDecoration(
                          color: FinfulColor.blackHighLightSkeletonColor,
                          borderRadius: BorderRadius.circular(Dimens.p_5),
                        ),
                      ),
                    ],
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

class DashboardNoneFinalPlanContent extends StatelessWidget {
  const DashboardNoneFinalPlanContent({
    super.key,
    required this.sectionItems,
    required this.onStaticSchedulePressed,
    required this.onSectionItemPressed,
  });

  final List<SectionDashboardItem> sectionItems;
  final VoidCallback onStaticSchedulePressed;
  final Function(SectionDashboardItem item) onSectionItemPressed;

  String _bgImage(SectionDashboardItem item) {
    switch (item.sectionType) {
      case SectionType.onboarding:
        return ImageConstants.imgOnboardingBg;
      case SectionType.familySupport:
        return ImageConstants.imgFamilySupportBg;
      case SectionType.spending:
        return ImageConstants.imgSpendingBg;
      case SectionType.assumptions:
        return ImageConstants.imgAssumptionsBg;
      default:
        return ImageConstants.imgOnboardingBg;
    }
  }

  String _image(SectionDashboardItem item) {
    switch (item.sectionType) {
      case SectionType.onboarding:
        return ImageConstants.imgDashboardOnboarding;
      case SectionType.familySupport:
        return ImageConstants.imgFamilySupport;
      case SectionType.spending:
        return ImageConstants.imgDashboardSpending;
      case SectionType.assumptions:
        return ImageConstants.imgAssumptions;
      default:
        return ImageConstants.imgDashboardOnboarding;
    }
  }

  String _contentText(BuildContext context, SectionDashboardItem item) {
    switch (item.sectionType) {
      case SectionType.onboarding:
        return L10n.of(context).translate('dashboard_section_onboarding_item_content');
      case SectionType.familySupport:
        return L10n.of(context).translate('dashboard_section_familySupport_item_content');
      case SectionType.spending:
        return L10n.of(context).translate('dashboard_section_spending_item_content');
      case SectionType.assumptions:
        return L10n.of(context).translate('dashboard_section_assumptions_item_content');
      default:
        return L10n.of(context).translate('dashboard_section_onboarding_item_content');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              top: Dimens.p_14,
              left: FinfulDimens.md,
              right: FinfulDimens.md,
            ),
            sliver: SliverToBoxAdapter(
              child: _HeaderView(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: FinfulDimens.md,
              right: FinfulDimens.md,
            ),
            sliver: SliverToBoxAdapter(
              child: _SubHeaderView(),
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(height: Dimens.p_40),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              height: Dimens.p_180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: sectionItems.length,
                itemBuilder: (context, index) {
                  final itemData = sectionItems[index];
                  final lastIndex = sectionItems.length - 1;
                  return BlocBuilder<GetSectionProgressBloc, GetSectionProgressState>(
                    builder: (_, state) {
                      if (state is GetSectionProgressGetCurrentInProgress) {
                        return _SectionItemLoading(
                          isEnd: index == lastIndex,
                        );
                      }

                      if (state.currentProgress != null) {
                        return _SectionItemView(
                          isEnd: index == lastIndex,
                          isCompleted: itemData.isCompleted,
                          isActivated: itemData.isActivated,
                          bgImage: _bgImage(itemData),
                          image: _image(itemData),
                          content: _contentText(context, itemData),
                          onPressed: () => onSectionItemPressed(itemData),
                        );
                      }

                      return _SectionItemLoading(
                        isEnd: index == lastIndex,
                      );

                    },
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: Dimens.p_40,
              left: FinfulDimens.md,
              right: FinfulDimens.md,
            ),
            sliver: SliverToBoxAdapter(
              child: DashboardStaticSchedule(
                onPressed: onStaticSchedulePressed,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(height: Dimens.p_40),
          ),
        ],
      ),
    );
  }
}
