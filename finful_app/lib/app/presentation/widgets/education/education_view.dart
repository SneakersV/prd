import 'package:finful_app/app/presentation/blocs/get_education/get_education.dart';
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
  });

  final String type;
  final String location;

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
      create: (_) => GetEducationBloc.instance()..add(GetEducationOnboardingStarted(
        type: widget.type,
        location: widget.location,
      )),
      child: BlocConsumer<GetEducationBloc, GetEducationState>(
        listener: (_, state) {
        },
        builder: (_, state) {
          if (state.onboardingEducations.isEmpty) {
            return const SizedBox();
          }

          return SizedBox(
            width: double.infinity,
            height: context.queryHeight,
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                if (page != _currentPageIdx) {
                  setState(() {
                    _currentPageIdx = page;
                  });
                }
              },
              children: state.onboardingEducations.map((data) {
                final showDivider = data.title.isNotNullAndEmpty;

                return EducationContentView(
                  showDivider: showDivider,
                  title: data.title,
                  description: data.message,
                  url: data.url,
                  isLast: data.order == state.onboardingEducations.last.order,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

}
