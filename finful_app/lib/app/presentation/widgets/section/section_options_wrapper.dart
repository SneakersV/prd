import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';

class SectionOptionWrapperItem extends StatelessWidget {
  const SectionOptionWrapperItem({
    super.key,
    required this.child,
    required this.animation,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      // And slide transition
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -0.1),
          end: Offset.zero,
        ).animate(animation),
        // Paste you Widget
        child: child,
      ),
    );
  }
}

class SectionOptionsWrapper extends StatelessWidget {
  const SectionOptionsWrapper({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final LiveListItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LiveList.options(
      options: LiveOptions(
        delay: Duration.zero,
        // Show each item through
        showItemInterval: Duration(milliseconds: 100),
        // Animation duration
        showItemDuration: Duration(milliseconds: 100),
        visibleFraction: 0.05,
        reAnimateOnVisibility: false,
      ),
      shrinkWrap: true,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  }
}
