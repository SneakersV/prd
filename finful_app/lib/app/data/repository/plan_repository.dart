import 'package:finful_app/app/data/model/request/patch_plan_section_request.dart';
import 'package:finful_app/app/data/model/request/query_section_request.dart';
import 'package:finful_app/app/data/model/response/create_plan_response.dart';
import 'package:finful_app/app/data/model/response/get_plan_response.dart';
import 'package:finful_app/app/data/model/response/patch_plan_section_response.dart';

abstract interface class PlanRepository {
  Future<List<GetPlanResponse>> getAllPlans();

  Future<CreatePlanResponse> createPlan({
    required List<SectionAnswerRequest> request,
  });

  Future<PatchPlanSectionResponse> updateSectionOfPlan({
    required String planId,
    required PatchPlanSectionRequest request,
  });
}