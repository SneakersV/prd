
import 'package:finful_app/app/data/enum/section.dart';
import 'package:finful_app/app/data/enum/section_progress.dart';
import 'package:finful_app/app/data/model/request/query_section_request.dart';
import 'package:finful_app/app/data/model/response/section_onboarding_calculate_response.dart';
import 'package:finful_app/app/data/repository/section_repository.dart';
import 'package:finful_app/app/domain/interactor/section_interactor.dart';
import 'package:finful_app/app/domain/model/extension/extension.dart';
import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/domain/model/section_progress_model.dart';

class SectionInteractorImpl implements SectionInteractor {
  late final SectionRepository _sectionRepository;

  SectionInteractorImpl({
    required SectionRepository sectionRepository,
  }) :
        _sectionRepository = sectionRepository;

  @override
  Future<SectionModel> getSectionOnboardingQA({
    required int nextStep,
    required List<SectionAnswerModel> answersFilled,
  }) async {
    final answerRequest = answersFilled.toRequest();
    final request = SectionRequest(
        currentSection: SectionType.onboarding.toValue(),
        answers: answerRequest,
    );
    final sectionResponse = await _sectionRepository.getSectionQA(
        nextStep: nextStep,
        request: request,
    );
    final sectionModel = SectionModel(
      section: sectionResponse,
      answerFilled: null,
    );
    return sectionModel;
  }

  @override
  Future<SectionOnboardingCalculateResponse> submitSectionOnboardingCalculate({
    required List<SectionAnswerModel> answersFilled,
  }) async {
    final answerRequest = answersFilled.toRequest();
    final result = await _sectionRepository.submitOnboardingCalculate(
      request: answerRequest,
    );
    return result;
  }

  @override
  Future<SectionModel> getSectionFamilySupportQA({
    required int nextStep,
    required List<SectionAnswerModel> answersFilled,
  }) async {
    final answerRequest = answersFilled.toRequest();
    final request = SectionRequest(
      currentSection: SectionType.familySupport.toValue(),
      answers: answerRequest,
    );
    final sectionResponse = await _sectionRepository.getSectionQA(
      nextStep: nextStep,
      request: request,
    );
    final sectionModel = SectionModel(
      section: sectionResponse,
      answerFilled: null,
    );
    return sectionModel;
  }

  @override
  Future<SectionModel> getSectionSpendingQA({
    required int nextStep,
    required List<SectionAnswerModel> answersFilled,
  }) async {
    final answerRequest = answersFilled.toRequest();
    final request = SectionRequest(
      currentSection: SectionType.spending.toValue(),
      answers: answerRequest,
    );
    final sectionResponse = await _sectionRepository.getSectionQA(
      nextStep: nextStep,
      request: request,
    );
    final sectionModel = SectionModel(
      section: sectionResponse,
      answerFilled: null,
    );
    return sectionModel;
  }

  @override
  Future<SectionModel> getSectionAssumptionsQA({
    required int nextStep,
    required List<SectionAnswerModel> answersFilled,
  }) async {
    final answerRequest = answersFilled.toRequest();
    final request = SectionRequest(
      currentSection: SectionType.assumptions.toValue(),
      answers: answerRequest,
    );
    final sectionResponse = await _sectionRepository.getSectionQA(
      nextStep: nextStep,
      request: request,
    );
    final sectionModel = SectionModel(
      section: sectionResponse,
      answerFilled: null,
    );
    return sectionModel;
  }

  @override
  Future<SectionProgressModel> getCurrentSectionProgress() async {
    final response = await _sectionRepository.getCurrentSectionProgress();
    final quickCheckResponse = response.progress?.quickCheck;
    final quickCheck = quickCheckResponse != null ? SectionProgressItemModel(
        state: SectionProgressStateTypeExt.fromValue(quickCheckResponse.state),
        status: SectionProgressStatusTypeExt.fromValue(quickCheckResponse.status),
    ) : null;
    final familySupportResponse = response.progress?.familySupport;
    final familySupport = familySupportResponse != null ? SectionProgressItemModel(
      state: SectionProgressStateTypeExt.fromValue(familySupportResponse.state),
      status: SectionProgressStatusTypeExt.fromValue(familySupportResponse.status),
    ) : null;
    final spendingResponse = response.progress?.spending;
    final spending = spendingResponse != null ? SectionProgressItemModel(
      state: SectionProgressStateTypeExt.fromValue(spendingResponse.state),
      status: SectionProgressStatusTypeExt.fromValue(spendingResponse.status),
    ) : null;
    final assumptionsResponse = response.progress?.assumption;
    final assumptions = assumptionsResponse != null ? SectionProgressItemModel(
      state: SectionProgressStateTypeExt.fromValue(assumptionsResponse.state),
      status: SectionProgressStatusTypeExt.fromValue(assumptionsResponse.status),
    ) : null;
    final progressModel = SectionProgressModel(
      planId: response.planId,
      quickCheck: quickCheck,
      familySupport: familySupport,
      spending: spending,
      assumptions: assumptions,
    );
    return progressModel;
  }

}