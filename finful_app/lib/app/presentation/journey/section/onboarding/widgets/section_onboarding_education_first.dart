import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/injection/injection.dart';
import 'package:finful_app/app/presentation/blocs/section/onboarding/onboarding_bloc.dart';
import 'package:finful_app/app/presentation/blocs/section/onboarding/onboarding_event.dart';
import 'package:finful_app/app/presentation/blocs/section/onboarding/onboarding_state.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/widgets/education_content_tile.dart';
import 'package:finful_app/app/presentation/widgets/app_button/FinfulButton.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/theme/dimens.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/context_extension.dart';
import 'package:finful_app/core/extension/string_extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SectionOnboardingEducationFirst extends StatelessWidget {
  const SectionOnboardingEducationFirst({
    super.key,
    required this.currentSection,
    required this.showNextStepBtn,
  });

  final SectionModel currentSection;
  final bool showNextStepBtn;

  double mediaWidth(BuildContext context) => context.queryWidth;

  double mediaHeight(BuildContext context) => mediaWidth(context) * 9 / 16;

  @override
  Widget build(BuildContext context) {
    final payload = currentSection.section.payload;

    if (payload == null) {
      return const SizedBox();
    }

    final contentData = payload.points;
    final showContent = contentData != null && contentData.isNotEmpty;
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: FinfulDimens.md,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.p_40,
            ),
            child: Text(
              payload.title ?? "",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimens.p_35,
            ),
            child: Text(
              payload.summary ?? "",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (payload.image.isNotNullAndEmpty)
            FinfulImage(
              type: FinfulImageType.network,
              source: payload.image!.getNormalImageUrlFromHost(Injection().getMediaHost),
              width: mediaWidth(context),
              height: mediaHeight(context),
            ) else const SizedBox(),
          const SizedBox(height: Dimens.p_30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showContent) ...[
                for (var entry in contentData.entries)
                  EducationContentTile(
                    title: entry.key.toString(),
                    description: entry.value.toString(),
                  ),
              ] else const SizedBox(),
            ],
          ),
          const SizedBox(height: Dimens.p_30),
          if (showNextStepBtn)
            BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (_, state) {
                String btnCtaTitle = L10n.of(context)
                    .translate('common_cta_continue');
                final currentSection = state.sectionOnboardings.last;
                final stepType = SectionStepTypeExt.fromValue(
                    currentSection.section.stepType);
                final ctaText = currentSection.section.payload?.ctaText ?? "";
                if (stepType == SectionStepType.education && ctaText.isNotEmpty) {
                  btnCtaTitle = ctaText;
                }

                return FinfulButton.secondary(
                  title: btnCtaTitle,
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
          SizedBox(
            height: Dimens.p_64 + context.queryPaddingBottom,
          ),
        ],
      ),
    );
  }
}
