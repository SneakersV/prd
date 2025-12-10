import 'package:finful_app/app/domain/model/section_model.dart';
import 'package:finful_app/app/presentation/blocs/get_education/get_education.dart';
import 'package:finful_app/app/presentation/journey/section/onboarding/widgets/section_onboarding_education_first.dart';
import 'package:finful_app/app/presentation/widgets/education/education_content_view.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/mixin/mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EducationView extends StatefulWidget {
  const EducationView({
    super.key,
    required this.type,
    required this.location,
    required this.currentSection,
  });

  final String type;
  final String location;
  final SectionModel currentSection;

  @override
  State<EducationView> createState() => _EducationViewState();
}

class _EducationViewState extends State<EducationView>
    with WidgetDidMount<EducationView> {
  late final PageController _pageController;
  int _currentPageIdx = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIdx);
  }

  @override
  void widgetDidMount(BuildContext context) {
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetEducationBloc>(
      create: (_) => GetEducationBloc.instance()
        ..add(GetEducationOnboardingStarted(
          type: widget.type,
          location: widget.location,
        )),
      child: BlocConsumer<GetEducationBloc, GetEducationState>(
        listener: (_, state) {

        },
        builder: (_, state) {
          if (state.onboardingEducations.isEmpty) {
            return SectionOnboardingEducationFirst(
              currentSection: widget.currentSection,
              showNextStepBtn: true,
            );
          }

          return SizedBox(
            width: double.infinity,
            height: context.queryHeight * 1.3,
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                if (page != _currentPageIdx) {
                  _currentPageIdx = page;
                }
                setState(() {});
              },
              children: [
                SectionOnboardingEducationFirst(
                  currentSection: widget.currentSection,
                  showNextStepBtn: false,
                ),
                for (final data in state.onboardingEducations)
                  EducationContentView(
                    title: data.title,
                    description: data.message,
                    url: data.url,
                    isLast: data == state.onboardingEducations.last,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

}
