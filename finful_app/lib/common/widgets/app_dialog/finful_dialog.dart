import 'dart:ui';

import 'package:finful_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

const _kActionButtonHeight = 44.0;
const _kDropdownPosition = 50.0;
const _kShowColumnIfActionGreaterThanValue = 2;
const _kDefaultBorderRadius = 12.0;
const _kDefaultBackgroundColor = Color(0xFF333437);
const _kDefaultBlurValue = 20.0;
const _kMaxActionDisplay = 4;
const _kDefaultAction = FinfulDialogAction(label: 'OK');

enum DialogTransitionType {
  zoomIn,
  dropDown,
  fadeIn,
}

class FinfulDialogAction {
  final String label;
  final VoidCallback? onPressed;
  final TextStyle? style;

  const FinfulDialogAction({
    this.label = '',
    this.onPressed,
    this.style,
  });
}

class FinfulDialog extends StatelessWidget {
  const FinfulDialog({
    super.key,
    this.title = '',
    this.content = '',
    this.margin,
    this.contentPadding,
    this.titleStyle,
    this.contentStyle,
    this.borderRadius = _kDefaultBorderRadius,
    this.actions = const [_kDefaultAction],
    this.backgroundColor = _kDefaultBackgroundColor,
  });

  final String title;
  final String content;
  final double? margin;
  final double borderRadius;
  final EdgeInsets? contentPadding;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final List<FinfulDialogAction> actions;
  final Color backgroundColor;

  static Future<dynamic> show(
    BuildContext context, {
    String title = '',
    String content = '',
    double? margin,
    double borderRadius = _kDefaultBorderRadius,
    EdgeInsets? contentPadding,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    List<FinfulDialogAction> actions = const [_kDefaultAction],
    Color backgroundColor = _kDefaultBackgroundColor,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration transitionDuration = const Duration(milliseconds: 200),
    DialogTransitionType transitionType = DialogTransitionType.zoomIn,
  }) {
    return showGeneralDialog(
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
      transitionBuilder: (context, animation1, _, widget) {
        switch (transitionType) {
          case DialogTransitionType.zoomIn:
            return Transform.scale(
              scale: animation1.value,
              child: Opacity(
                opacity: animation1.value,
                child: widget,
              ),
            );
          case DialogTransitionType.dropDown:
            final curvedValue =
                Curves.easeInOutBack.transform(animation1.value) - 1.0;
            return Transform(
              transform: Matrix4.translationValues(
                  0.0, curvedValue * _kDropdownPosition, 0.0),
              child: Opacity(
                opacity: animation1.value,
                child: widget,
              ),
            );
          case DialogTransitionType.fadeIn:
            return Opacity(
              opacity: animation1.value,
              child: widget,
            );
        }
      },
      barrierLabel: '',
      transitionDuration: transitionDuration,
      barrierDismissible: barrierDismissible,
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return FinfulDialog(
          title: title,
          content: content,
          margin: margin,
          borderRadius: borderRadius,
          contentPadding: contentPadding,
          titleStyle: titleStyle,
          contentStyle: contentStyle,
          actions: actions,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isColumnOfAction =
        actions.length > _kShowColumnIfActionGreaterThanValue;
    final List<Widget> actionWidgets = actions
        .mapIndexed(
          (index, action) => _ActionItem(
            key: ValueKey('app_dialog_action_item_$index'),
            isFirstItem: index == 0,
            isLastItem: index == actions.length - 1,
            isColumnOfAction: isColumnOfAction,
            borderRadius: borderRadius,
            action: action,
          ),
        )
        .toList();

    return Dialog(
      insetPadding:
          EdgeInsets.symmetric(horizontal: margin ?? context.queryWidth / 6),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: _kDefaultBlurValue, sigmaY: _kDefaultBlurValue),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: contentPadding ??
                      const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 16.0,
                      ),
                  child: Column(
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: titleStyle ??
                            const TextStyle(
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                      ),
                      if (content.isNotEmpty) ...[
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          content,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: contentStyle ??
                              const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.0,
                              ),
                        ),
                      ]
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Material(
                  color: Colors.transparent,
                  child: isColumnOfAction
                      ? SizedBox(
                          height: actions.length > _kMaxActionDisplay
                              ? (_kMaxActionDisplay + 0.5) *
                                  _kActionButtonHeight
                              : actions.length * _kActionButtonHeight,
                          child: SingleChildScrollView(
                              child: Column(children: actionWidgets)),
                        )
                      : Row(children: actionWidgets),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final bool isFirstItem;
  final bool isLastItem;
  final bool isColumnOfAction;
  final double borderRadius;
  final FinfulDialogAction action;

  const _ActionItem({
    super.key,
    this.isColumnOfAction = false,
    required this.isFirstItem,
    required this.isLastItem,
    required this.action,
    this.borderRadius = _kDefaultBorderRadius,
  });

  void _onPressed(BuildContext context) {
    action.onPressed?.call();
    Navigator.of(context).pop();
  }

  Radius get _bottomLeftRadius {
    final radius = Radius.circular(borderRadius);
    if (isColumnOfAction) {
      return isLastItem ? radius : Radius.zero;
    }
    return isFirstItem ? radius : Radius.zero;
  }

  Radius get _bottomRightRadius {
    final radius = Radius.circular(borderRadius);
    if (isColumnOfAction) {
      return isLastItem ? radius : Radius.zero;
    }
    return isLastItem ? radius : Radius.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isColumnOfAction ? 0 : 1,
      child: Container(
        height: _kActionButtonHeight,
        decoration: BoxDecoration(
          border: Border(
            right: !isColumnOfAction
                ? Divider.createBorderSide(
                    context,
                  )
                : BorderSide.none,
            bottom: isColumnOfAction
                ? Divider.createBorderSide(
                    context,
                  )
                : BorderSide.none,
          ),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.only(
            bottomLeft: _bottomLeftRadius,
            bottomRight: _bottomRightRadius,
          ),
          onTap: () => _onPressed(context),
          child: Center(
            child: Text(
              action.label,
              style: action.style ??
                  Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
