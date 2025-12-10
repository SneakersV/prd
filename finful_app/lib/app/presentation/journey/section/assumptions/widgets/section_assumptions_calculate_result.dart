import 'package:finful_app/app/constants/images.dart';
import 'package:finful_app/app/domain/model/extension/extension.dart';
import 'package:finful_app/app/presentation/blocs/common/session/session.dart';
import 'package:finful_app/app/presentation/blocs/section/assumptions/assumptions.dart';
import 'package:finful_app/app/presentation/widgets/app_image/FinfulImage.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/common/constants/dimensions.dart';
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
              .translate('section_assumptions_qa_calculating'),
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
    required this.message,
    required this.image,
    required this.customMessage,
  });

  final String message;
  final String image;
  final String customMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.p_40,
      ),
      child: Column(
        children: [
          const SizedBox(height: Dimens.p_46),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<SessionBloc, SessionState>(
                builder: (_, state) {
                  final fullName = state.loggedInUser?.toFullName ?? "";
                  if (fullName.isNullOrEmpty) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: Dimens.p_7,
                    ),
                    child: Text(
                      "$fullName,",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: FinfulColor.brandPrimary,
                        height: Dimens.p_25 / Dimens.p_19,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  );
                },
              ),
              Text(
                message,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  height: Dimens.p_25 / Dimens.p_19,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          const SizedBox(height: Dimens.p_36),
          FinfulImage(
            type: FinfulImageType.asset,
            source: image,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: Dimens.p_22),
          Text(
            customMessage,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: Dimens.p_13,
              fontWeight: FontWeight.w200,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SectionAssumptionsCalculateResult extends StatefulWidget {
  const SectionAssumptionsCalculateResult({
    super.key,
  });

  @override
  State<SectionAssumptionsCalculateResult> createState() => _SectionAssumptionsCalculateResultState();
}

class _SectionAssumptionsCalculateResultState extends State<SectionAssumptionsCalculateResult> {

  String _messageText(AssumptionsCalculateSuccess state) {
    return state.calculateResult?.sectionResult?.message ?? "";
  }

  String _customMessageText(AssumptionsCalculateSuccess state) {
    return state.calculateResult?.sectionResult?.customMessage ?? "";
  }

  String _imagePath(AssumptionsCalculateSuccess state) {
    final caseNumber = state.calculateResult?.sectionResult?.caseNumber;
    switch (caseNumber) {
      case null:
      case -1:
        return "";
      case 1:
        return ImageConstants.imgAssumptionsResultCase1;
      case 2:
        return ImageConstants.imgAssumptionsResultCase2;
      case 3:
        return ImageConstants.imgAssumptionsResultCase3;
      case 4:
        return ImageConstants.imgAssumptionsResultCase4;
      case 5:
        return ImageConstants.imgAssumptionsResultCase5;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssumptionsBloc, AssumptionsState>(
        builder: (_, state) {
          if (state is AssumptionsCalculateSuccess) {
            return _ContentView(
              message: _messageText(state),
              image: _imagePath(state),
              customMessage: _customMessageText(state),
            );
          }

          return _LoadingView();
        }
    );
  }
}
