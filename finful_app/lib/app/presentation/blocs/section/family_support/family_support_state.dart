import 'package:equatable/equatable.dart';
import 'package:finful_app/app/domain/model/section_model.dart';

enum FamilySupportSubmitAnswerFailureType { missingPlanId, api }

abstract class FamilySupportState extends Equatable {
  final List<SectionModel> sectionFamilySupports;

  const FamilySupportState({
    required this.sectionFamilySupports,
  });

  @override
  List<Object?> get props => [
    sectionFamilySupports,
  ];
}

class FamilySupportInitial extends FamilySupportState {
  const FamilySupportInitial({
    required List<SectionModel> initSection,
  }) : super(
    sectionFamilySupports: initSection,
  );
}

class FamilySupportGetNextStepInProgress extends FamilySupportState {
  FamilySupportGetNextStepInProgress(FamilySupportState state) : super(
    sectionFamilySupports: state.sectionFamilySupports,
  );
}

class FamilySupportGetNextStepSuccess extends FamilySupportState {
  const FamilySupportGetNextStepSuccess({
    required List<SectionModel> latestSections,
  }) : super(
    sectionFamilySupports: latestSections,
  );
}

class FamilySupportGetNextStepFailure extends FamilySupportState {
  FamilySupportGetNextStepFailure(FamilySupportState state) : super(
    sectionFamilySupports: state.sectionFamilySupports,
  );
}

class FamilySupportFillAnswerInProgress extends FamilySupportState {
  FamilySupportFillAnswerInProgress(FamilySupportState state) : super(
    sectionFamilySupports: state.sectionFamilySupports,
  );
}

class FamilySupportFillAnswerSuccess extends FamilySupportState {
  const FamilySupportFillAnswerSuccess({
    required List<SectionModel> latestSections,
  }) : super(
    sectionFamilySupports: latestSections,
  );
}

class FamilySupportGetPreviousStepInProgress extends FamilySupportState {
  FamilySupportGetPreviousStepInProgress(FamilySupportState state) : super(
    sectionFamilySupports: state.sectionFamilySupports,
  );
}

class FamilySupportGetPreviousStepSuccess extends FamilySupportState {
  const FamilySupportGetPreviousStepSuccess({
    required List<SectionModel> latestSections,
  }) : super(
    sectionFamilySupports: latestSections,
  );
}

class FamilySupportSubmitAnswerInProgress extends FamilySupportState {
  FamilySupportSubmitAnswerInProgress(FamilySupportState state) : super(
    sectionFamilySupports: state.sectionFamilySupports,
  );
}

class FamilySupportSubmitAnswerSuccess extends FamilySupportState {
  FamilySupportSubmitAnswerSuccess({
    required FamilySupportState state,
  }) : super(
    sectionFamilySupports: state.sectionFamilySupports,
  );
}

class FamilySupportSubmitAnswerFailure extends FamilySupportState {
  FamilySupportSubmitAnswerFailure({
    required FamilySupportState state,
    required FamilySupportSubmitAnswerFailureType failedType,
  }) : super(
    sectionFamilySupports: state.sectionFamilySupports,
  );
}

