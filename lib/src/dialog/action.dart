import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../cupertino_dialog_extended.dart';
import '../theme/default_theme.dart';
import '../utils/utils.dart';
import 'utils/constants.dart';

@immutable
class CupertinoDialogActionExtended extends StatelessWidget {
  const CupertinoDialogActionExtended({
    super.key,
    this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.textStyle,
    required this.child,
  });

  final VoidCallback? onPressed;

  final bool isDefaultAction;

  final bool isDestructiveAction;

  final TextStyle? textStyle;

  final Widget child;

  double _calculatePadding(BuildContext context) =>
      8.0 * MediaQuery.textScaleFactorOf(context);

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoDialogTheme.of(context);

    final defaults = CupertinoDialogExtendedThemeDefaults(context).dialogTheme;

    var style = CupertinoDialogTheme.getProperty<TextStyle>(
      widgetTheme: null,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.actionStyle,
    );

    if (isDestructiveAction) {
      final color = CupertinoDialogTheme.getProperty<Color>(
        widgetTheme: null,
        theme: theme,
        defaults: defaults,
        getThemeProperty: (theme) => theme?.destructiveColor,
      );

      style = style.copyWith(color: color);
    }
    style = style.merge(textStyle);

    if (isDefaultAction) {
      style = style.copyWith(fontWeight: FontWeight.w600);
    }

    if (onPressed == null) {
      style = style.copyWith(color: style.color!.withOpacity(0.5));
    }

    final calculatePadding = _calculatePadding(context);

    // Apply a sizing policy to the action button's content based on whether or
    // not the device is in accessibility mode.
    // TODO(mattcarroll): The following logic is not entirely correct.
    // It is also the case that if content text does not contain a space, it
    // should also wrap instead of ellipsizing. We are consciously not
    // implementing that now due to complexity.

    final sizedContent = isInAccessibilityMode(context)
        ? DefaultTextStyle(
            style: style,
            textAlign: TextAlign.center,
            child: child,
          )
        : _RegularSizingContent(
            onPressed: onPressed,
            textStyle: style,
            content: child,
            padding: calculatePadding,
          );

    return MouseRegion(
      cursor: onPressed != null && kIsWeb
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        excludeFromSemantics: true,
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: kDialogMinButtonHeight,
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(calculatePadding),
            child: sizedContent,
          ),
        ),
      ),
    );
  }
}

@immutable
class _RegularSizingContent extends StatelessWidget {
  const _RegularSizingContent({
    required this.onPressed,
    required this.textStyle,
    required this.content,
    required this.padding,
  });

  final TextStyle textStyle;
  final Widget content;
  final VoidCallback? onPressed;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final isInAccessibility = isInAccessibilityMode(context);
    final dialogWidth = isInAccessibility
        ? kAccessibilityCupertinoDialogWidth
        : kCupertinoDialogWidth;
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final fontSizeRatio =
        (textScaleFactor * textStyle.fontSize!) / kDialogMinButtonFontSize;

    return IntrinsicHeight(
      child: SizedBox(
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: fontSizeRatio * (dialogWidth - (padding * 2)),
            ),
            child: Semantics(
              button: true,
              onTap: onPressed,
              child: DefaultTextStyle(
                style: textStyle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
