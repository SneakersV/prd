import 'package:finful_app/app/domain/model/section_model.dart';

abstract class CreatePlanEvent {
  const CreatePlanEvent();
}

class CreatePlanStarted extends CreatePlanEvent {
  final List<SectionAnswerModel> answersFilled;

  CreatePlanStarted({
    required this.answersFilled,
  });
}

class CreatePlanFromDraftDataStarted extends CreatePlanEvent {
  final List<SectionAnswerModel> answersFilled;

  CreatePlanFromDraftDataStarted({
    required this.answersFilled,
  });
}