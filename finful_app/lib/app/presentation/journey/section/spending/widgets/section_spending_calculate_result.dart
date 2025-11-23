import 'package:finful_app/app/constants/images.dart';
import 'package:finful_app/app/presentation/blocs/section/spending/spending.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/theme/theme.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/core/extension/context_extension.dart';
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
              .translate('section_spending_qa_calculating'),
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  final String title;
  final String image;
  final String description;

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
            title,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: FinfulColor.textWOpacity70,
              height: Dimens.p_23 / Dimens.p_16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimens.p_44),
          FinfulImage(
            type: FinfulImageType.asset,
            source: image,
            width: Dimens.p_274,
            height: Dimens.p_254,
          ),
          const SizedBox(height: Dimens.p_64),
          Text(
            description,
            style: Theme.of(context).textTheme.displaySmall!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SectionSpendingCalculateResult extends StatefulWidget {
  const SectionSpendingCalculateResult({
    super.key,
  });

  @override
  State<SectionSpendingCalculateResult> createState() => _SectionSpendingCalculateResultState();
}

class _SectionSpendingCalculateResultState extends State<SectionSpendingCalculateResult> {

  String _titleText(SpendingCalculateSuccess state) {
    return state.calculateResult?.sectionResult?.message ?? "";
  }

  String _descriptionText(SpendingCalculateSuccess state) {
    final caseNumber = state.calculateResult?.sectionResult?.caseNumber;
    if (caseNumber == null) {
      return "";
    }
    String descTxt = "";
    String finalTxt = "";
    final dataYear = state.calculateResult?.sectionResult?.earliestPurchaseYear;
    final yearTxt = dataYear != null && dataYear > 0
      ? dataYear.toString()
        : L10n.of(context).translate("common_dummy_default_year");
    switch (caseNumber) {
      case 1:
        descTxt = L10n.of(context).translate("section_spending_result_case1_desc");
      case 2:
        descTxt = L10n.of(context).translate("section_spending_result_case2_desc");
      case 3:
        descTxt = L10n.of(context).translate("section_spending_result_case3_desc");
      case 4:
        descTxt = L10n.of(context).translate("section_spending_result_case4_desc");
      case 5:
        descTxt = L10n.of(context).translate("section_spending_result_case5_desc");
      default:
    }
    finalTxt = "$descTxt $yearTxt";

    return finalTxt;
  }

  String _imagePath(SpendingCalculateSuccess state) {
    final caseNumber = state.calculateResult?.sectionResult?.caseNumber;
    switch (caseNumber) {
      case null:
      case -1:
        return "";
      case 1:
        return ImageConstants.imgSpendingResultCase1;
      case 2:
        return ImageConstants.imgSpendingResultCase2;
      case 3:
        return ImageConstants.imgSpendingResultCase3;
      case 4:
        return ImageConstants.imgSpendingResultCase4;
      case 5:
        return ImageConstants.imgSpendingResultCase5;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpendingBloc, SpendingState>(
        builder: (_, state) {
          if (state is SpendingCalculateSuccess) {
            return _ContentView(
              title: _titleText(state),
              image: _imagePath(state),
              description: _descriptionText(state),
            );
          }

          return _LoadingView();
        }
    );
  }
}

