import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/data/model/request/patch_plan_section_request.dart';
import 'package:finful_app/app/data/repository/plan_repository.dart';
import 'package:finful_app/app/domain/interactor/plan_interactor.dart';
import 'package:finful_app/app/domain/model/extension/section_ext.dart';
import 'package:finful_app/app/domain/model/plan_model.dart';
import 'package:finful_app/app/domain/model/section_model.dart';

class PlanInteractorImpl implements PlanInteractor {
  late final PlanRepository _planRepository;

  PlanInteractorImpl({
    required PlanRepository planRepository,
  }) :
        _planRepository = planRepository;

  @override
  Future<PlanModel?> getCurrentPlan() async {
    final response = await _planRepository.getAllPlans();
    if (response.isEmpty) return null;

    final currentPlanResponse = response.first;
    final currentPlan = PlanModel(
      planId: currentPlanResponse.id,
      userId: currentPlanResponse.userId,
    );

    return currentPlan;
  }

  @override
  Future<PlanModel?> submitCreatePlan({
    required List<SectionAnswerModel> answersFilled,
  }) async {
    final answerRequest = answersFilled.toRequest();
    final response = await _planRepository.createPlan(
      request: answerRequest,
    );
    final plan = PlanModel(
      planId: response.planId,
    );

    return plan;
  }

  @override
  Future<void> updateSectionFamilySupportOfPlan({
    required String planId,
    required List<SectionAnswerModel> answersFilled,
  }) async {
    final answerRequest = answersFilled.toRequest();
    final request = PatchPlanSectionRequest(
      currentSection: SectionType.familySupport.toValue(),
      answers: answerRequest,
    );
    await _planRepository.updateSectionOfPlan(
      planId: planId,
      request: request,
    );
  }

  @override
  Future<PlanModel?> updateSectionSpendingOfPlan({
    required String planId,
    required List<SectionAnswerModel> answersFilled,
  }) async {
    final answerRequest = answersFilled.toRequest();
    final request = PatchPlanSectionRequest(
        currentSection: SectionType.spending.toValue(),
        answers: answerRequest,
    );
    final response = await _planRepository.updateSectionOfPlan(
        planId: planId,
        request: request,
    );
    final planData = response.data;
    if (planData == null) return null;

    final sectionType = SectionTypeExt.fromValue(response.section);
    final planSectionResultResponse = response.result;
    final planSectionResult = planSectionResultResponse != null ? PlanSectionResultModel(
      caseNumber: planSectionResultResponse.caseNumber,
      message: planSectionResultResponse.message,
      earliestPurchaseYear: planSectionResultResponse.earliestPurchaseYear,
    ) : null;
    final planModel = PlanModel(
      planId: planData.id,
      userId: planData.userId,
      planName: planData.planName,
      sectionType: sectionType,
      sectionResult: planSectionResult,
    );

    return planModel;
  }

  @override
  Future<PlanModel?> updateSectionAssumptionsOfPlan({
    required String planId,
    required List<SectionAnswerModel> answersFilled,
  }) async {
    final answerRequest = answersFilled.toRequest();
    final request = PatchPlanSectionRequest(
      currentSection: SectionType.assumptions.toValue(),
      answers: answerRequest,
    );
    final response = await _planRepository.updateSectionOfPlan(
      planId: planId,
      request: request,
    );
    final planData = response.data;
    if (planData == null) return null;

    final sectionType = SectionTypeExt.fromValue(response.section);
    final planSectionResultResponse = response.result;
    final planSectionResult = planSectionResultResponse != null ? PlanSectionResultModel(
      caseNumber: planSectionResultResponse.caseNumber,
      message: planSectionResultResponse.message,
      earliestPurchaseYear: planSectionResultResponse.earliestPurchaseYear,
      customMessage: planSectionResultResponse.customMessage,
      isAffordable: planSectionResultResponse.isAffordable,
    ) : null;
    final planModel = PlanModel(
      planId: planData.id,
      userId: planData.userId,
      planName: planData.planName,
      sectionType: sectionType,
      sectionResult: planSectionResult,
    );

    return planModel;
  }

}