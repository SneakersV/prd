import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

class SectionQuestionText extends StatelessWidget {
  const SectionQuestionText({
    super.key,
    required this.value,
    this.textStyle,
  });

  final String value;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return OffsetText(
      text: value,
      duration: const Duration(milliseconds: 100),
      type: AnimationType.word,
      slideType: SlideAnimationType.leftRight,
      textStyle: textStyle ?? Theme.of(context).textTheme.displaySmall!.copyWith(
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
