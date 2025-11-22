import 'dart:math';

import 'package:finful_app/app/constants/constants.dart';
import 'package:finful_app/app/presentation/blocs/section/onboarding/onboarding.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/theme/theme.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/core.dart';
import 'package:finful_app/core/extension/context_extension.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _LoadingView extends StatelessWidget {
  const _LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: context.queryHeight / 5),
        Center(
          child: SizedBox(
            width: Dimens.p_110,
            height: Dimens.p_110,
            child: CircularProgressIndicator(
              color: FinfulColor.brandPrimary,
              backgroundColor: FinfulColor.brandPrimary.withValues(alpha: 0.30),
              strokeWidth: Dimens.p_15,
            ),
          ),
        ),
        const SizedBox(height: Dimens.p_60),
        Text(
          L10n.of(context)
              .translate('section_onboarding_calculating'),
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PossibleView extends StatelessWidget {
  const _PossibleView({
    super.key,
    required this.year,
  });

  final int? year;

  String _titleTxt(BuildContext context) {
    final staticTxt = L10n.of(context)
        .translate('section_onboarding_calculate_result_title');
    String yearTxt = "";
    if (year != null) {
      yearTxt = year.toString();
    } else {
      yearTxt = L10n.of(context)
          .translate('common_dummy_default_year');
    }

    return "$staticTxt$yearTxt";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.p_40,
      ),
      child: Column(
        children: [
          const SizedBox(height: Dimens.p_46),
          Text(
            _titleTxt(context),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: FinfulDimens.xs),
          Text(
            L10n.of(context)
                .translate('section_onboarding_calculate_result_possible_status'),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: FinfulColor.success,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimens.p_44),
          FinfulImage(
            type: FinfulImageType.asset,
            source: ImageConstants.imgOnboardingSubmitSuccess,
            width: Dimens.p_274,
            height: Dimens.p_254,
          ),
          const SizedBox(height: Dimens.p_44),
          Text(
            L10n.of(context)
                .translate('section_onboarding_calculate_result_desc'),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Impossible1View extends StatelessWidget {
  const _Impossible1View({
    super.key,
    required this.year,
    required this.affordableYear,
    required this.message,
  });

  final int? year;
  final int? affordableYear;
  final String? message;

  String _titleTxt(BuildContext context) {
    final staticTxt = L10n.of(context)
        .translate('section_onboarding_calculate_result_title');
    String yearTxt = "";
    if (year != null) {
      yearTxt = year.toString();
    } else {
      yearTxt = L10n.of(context)
          .translate('common_dummy_default_year');
    }

    return "$staticTxt$yearTxt";
  }

  String _subtitleTxt(BuildContext context) {
    if (message.isNotNullAndEmpty) {
      return message!;
    }

    final staticTxt = L10n.of(context)
        .translate('section_onboarding_calculate_result_possible_future');
    String yearTxt = "";
    if (affordableYear != null) {
      yearTxt = affordableYear.toString();
    } else {
      yearTxt = L10n.of(context)
          .translate('common_dummy_default_year');
    }
    return "$staticTxt$yearTxt";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.p_40,
      ),
      child: Column(
        children: [
          const SizedBox(height: Dimens.p_46),
          Text(
            _titleTxt(context),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: FinfulDimens.xs),
          Text(
            L10n.of(context)
                .translate('section_onboarding_calculate_result_impossible_status'),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: FinfulColor.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: FinfulDimens.xs),
          Text(
            _subtitleTxt(context),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimens.p_44),
          FinfulImage(
            type: FinfulImageType.asset,
            source: ImageConstants.imgOnboardingSubmitFailed1,
            width: Dimens.p_209,
            height: Dimens.p_221,
          ),
          const SizedBox(height: Dimens.p_44),
          Text(
            L10n.of(context)
                .translate('section_onboarding_calculate_result_desc'),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Impossible2View extends StatelessWidget {
  const _Impossible2View({
    super.key,
    required this.year,
  });

  final int? year;

  String _titleTxt(BuildContext context) {
    final staticTxt = L10n.of(context)
        .translate('section_onboarding_calculate_result_title');
    String yearTxt = "";
    if (year != null) {
      yearTxt = year.toString();
    } else {
      yearTxt = L10n.of(context)
          .translate('common_dummy_default_year');
    }

    return "$staticTxt$yearTxt";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.p_40,
      ),
      child: Column(
        children: [
          const SizedBox(height: Dimens.p_46),
          Text(
            _titleTxt(context),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: FinfulDimens.xs),
          Text(
            L10n.of(context)
                .translate('section_onboarding_calculate_result_impossible_status'),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: FinfulColor.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimens.p_44),
          FinfulImage(
            type: FinfulImageType.asset,
            source: ImageConstants.imgOnboardingSubmitFailed2,
            width: Dimens.p_258,
            height: Dimens.p_214,
          ),
          const SizedBox(height: Dimens.p_44),
          Text(
            L10n.of(context)
                .translate('section_onboarding_calculate_result_desc'),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SectionOnboardingCalculateResult extends StatefulWidget {
  const SectionOnboardingCalculateResult({super.key});

  @override
  State<SectionOnboardingCalculateResult> createState() => _SectionOnboardingCalculateResultState();
}

class _SectionOnboardingCalculateResultState extends State<SectionOnboardingCalculateResult> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (_, state) {
          if (state is OnboardingCalculateSuccess) {
            final caseNumber = state.calculateResult?.caseNumber;
            final projectionData = state.calculateResult?.projectionData ?? [];
            int? year;
            if (projectionData.isNotEmpty) {
              year = projectionData.first.year;
            }

            switch (caseNumber) {
              case null:
                return _LoadingView();
              case 1:
                return _PossibleView(
                  year: year,
                );
              case 2:
                return _Impossible1View(
                  year: year,
                  affordableYear: state.calculateResult?.affordableYear,
                  message: state.calculateResult?.message,
                );
              case 3:
                return _Impossible2View(
                  year: year,
                );
            }
          }

          return _LoadingView();
        }
    );
  }
}

