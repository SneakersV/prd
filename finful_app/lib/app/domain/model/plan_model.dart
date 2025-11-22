import 'package:equatable/equatable.dart';
import 'package:finful_app/app/data/enum/section.dart';

class PlanSectionResultModel extends Equatable {
  final int? caseNumber;
  final String? message;
  final int? earliestPurchaseYear;
  final String? customMessage;
  final bool? isAffordable;

  const PlanSectionResultModel({
    this.caseNumber,
    this.message,
    this.earliestPurchaseYear,
    this.customMessage,
    this.isAffordable,
  });

  @override
  List<Object?> get props => [
    caseNumber,
    message,
    earliestPurchaseYear,
    customMessage,
    isAffordable,
  ];
}

class PlanModel extends Equatable {
  final String? planId;
  final String? userId;
  final String? planName;
  final SectionType sectionType;
  final PlanSectionResultModel? sectionResult;

  const PlanModel({
    this.planId,
    this.userId,
    this.planName,
    this.sectionType = SectionType.undefined,
    this.sectionResult,
  });

  @override
  List<Object?> get props => [
    planId,
    userId,
    planName,
    sectionType,
    sectionResult,
  ];
}