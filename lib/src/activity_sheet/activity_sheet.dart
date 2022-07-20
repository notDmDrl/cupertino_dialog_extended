import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../cupertino_dialog_extended.dart';
import '../shared/alert_action_section.dart';
import '../shared/alert_content_section.dart';
import '../shared/dialog_render_widget.dart';
import '../theme/default_theme.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'utils/constants.dart';

/// An iOS-style action sheet.
///
/// See [CupertinoActionSheet].
@immutable
class CupertinoActionSheetExtended extends StatelessWidget {
  /// Creates an iOS-style action sheet.
  ///
  /// An action sheet must have a non-null value for at least one of the
  /// following arguments: [actions], [title], [message], or [cancelButton].
  ///
  /// Generally, action sheets are used to give the user a choice between
  /// two or more choices for the current context.
  const CupertinoActionSheetExtended({
    super.key,
    this.title,
    this.message,
    this.actions,
    this.messageScrollController,
    this.actionScrollController,
    this.cancelButton,
    this.theme,
  }) : assert(
          actions != null ||
              title != null ||
              message != null ||
              cancelButton != null,
          'An action sheet must have a non-null value for at least one of the '
          'following arguments: '
          'actions, title, message, or cancelButton',
        );

  /// An optional title of the action sheet. When the [message] is non-null,
  /// the font of the [title] is bold.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// An optional descriptive message that provides more details about the
  /// reason for the alert.
  ///
  /// Typically a [Text] widget.
  final Widget? message;

  /// The set of actions that are displayed for the user to select.
  ///
  /// Typically this is a list of [CupertinoActionSheetActionExtended] widgets.
  final List<Widget>? actions;

  /// A scroll controller that can be used to control the scrolling of the
  /// [message] in the action sheet.
  ///
  /// This attribute is typically not needed, as alert messages should be
  /// short.
  final ScrollController? messageScrollController;

  /// A scroll controller that can be used to control the scrolling of the
  /// [actions] in the action sheet.
  ///
  /// This attribute is typically not needed.
  final ScrollController? actionScrollController;

  /// The optional cancel button that is grouped separately from the other
  /// actions.
  ///
  /// Typically this is an [CupertinoActionSheetActionExtended] widget.
  final Widget? cancelButton;

  final CupertinoActionSheetTheme? theme;

  ScrollController get _effectiveMessageScrollController =>
      messageScrollController ?? ScrollController();

  ScrollController get _effectiveActionScrollController =>
      actionScrollController ?? ScrollController();

  @override
  Widget build(BuildContext context) {
    final cancelPadding = (actions != null || message != null || title != null)
        ? kActionSheetCancelButtonPadding
        : 0.0;

    final defaults =
        CupertinoDialogExtendedThemeDefaults(context).actionSheetTheme;
    final themeOfContext = CupertinoActionSheetTheme.of(context);

    final dividerColor = CupertinoActionSheetTheme.getProperty<Color>(
      widgetTheme: theme,
      theme: themeOfContext,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.dividerColor,
    );

    final sheetColor = CupertinoActionSheetTheme.getProperty<Color>(
      widgetTheme: theme,
      theme: themeOfContext,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.backgroundColor,
    );

    final cancelButtonColor = CupertinoActionSheetTheme.getProperty<Color>(
      widgetTheme: theme,
      theme: themeOfContext,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.cancelButtonBackgroundColor,
    );

    final titleStyle = CupertinoActionSheetTheme.getProperty<TextStyle>(
      widgetTheme: theme,
      theme: themeOfContext,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.titleStyle,
    );

    final messageStyle = CupertinoActionSheetTheme.getProperty<TextStyle>(
      widgetTheme: theme,
      theme: themeOfContext,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.messageStyle,
    );

    final children = <Widget>[
      Flexible(
        child: ClipRRect(
          borderRadius: kSheetCornerRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: kBlurAmount, sigmaY: kBlurAmount),
            child: CupertinoDialogRenderWidget(
              contentSection: _SheetContent(
                title: title,
                message: message,
                controller: _effectiveMessageScrollController,
                titleTextStyle: titleStyle,
                messageTextStyle: messageStyle,
                sheetColor: sheetColor,
              ),
              actionsSection: _SheetActions(
                controller: _effectiveActionScrollController,
                hasCancelButton: cancelButton != null,
                actions: actions,
                dividerColor: dividerColor,
                sheetColor: sheetColor,
              ),
              dividerColor: dividerColor,
              isActionSheet: true,
            ),
          ),
        ),
      ),
      if (cancelButton != null)
        Padding(
          padding: EdgeInsets.only(top: cancelPadding),
          child: _CupertinoActionSheetCancelButton(
            cancelButtonColor: cancelButtonColor,
            child: cancelButton,
          ),
        ),
    ];

    final mediaQueryData = MediaQuery.of(context);

    final orientation = mediaQueryData.orientation;
    final actionSheetWidth = orientation == Orientation.portrait
        ? mediaQueryData.size.width - (kActionSheetEdgeHorizontalPadding * 2)
        : mediaQueryData.size.height - (kActionSheetEdgeHorizontalPadding * 2);

    return SafeArea(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Semantics(
          namesRoute: true,
          scopesRoute: true,
          explicitChildNodes: true,
          label: 'Alert',
          child: CupertinoUserInterfaceLevel(
            data: CupertinoUserInterfaceLevelData.elevated,
            child: Container(
              width: actionSheetWidth,
              margin: const EdgeInsets.symmetric(
                horizontal: kActionSheetEdgeHorizontalPadding,
                vertical: kActionSheetEdgeVerticalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _SheetContent extends StatelessWidget {
  const _SheetContent({
    required this.title,
    required this.message,
    required this.controller,
    required this.titleTextStyle,
    required this.messageTextStyle,
    required this.sheetColor,
  });

  final Widget? title;
  final Widget? message;
  final ScrollController controller;
  final TextStyle titleTextStyle;
  final TextStyle messageTextStyle;
  final Color sheetColor;

  @override
  Widget build(BuildContext context) {
    // TODO(notDmdrl): do we even need column with flexible here?
    // seems redundant.

    final style = titleTextStyle.copyWith(fontWeight: FontWeight.w600);

    final content = [
      if (title != null || message != null)
        Flexible(
          child: CupertinoAlertContentSection(
            title: title,
            message: message,
            scrollController: controller,
            titlePadding: const EdgeInsets.only(
              left: kActionSheetContentHorizontalPadding,
              right: kActionSheetContentHorizontalPadding,
              bottom: kActionSheetContentVerticalPadding,
              top: kActionSheetContentVerticalPadding,
            ),
            messagePadding: EdgeInsets.only(
              left: kActionSheetContentHorizontalPadding,
              right: kActionSheetContentHorizontalPadding,
              bottom: title == null ? kActionSheetContentVerticalPadding : 22.0,
              top: title == null ? kActionSheetContentVerticalPadding : 0.0,
            ),
            titleTextStyle: message == null ? titleTextStyle : style,
            messageTextStyle: title == null ? style : messageTextStyle,
            additionalPaddingBetweenTitleAndMessage:
                const EdgeInsets.only(top: 8),
          ),
        ),
    ];

    return ColoredBox(
      color: sheetColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: content,
      ),
    );
  }
}

@immutable
class _SheetActions extends StatelessWidget {
  const _SheetActions({
    required this.actions,
    required this.controller,
    required this.hasCancelButton,
    required this.sheetColor,
    required this.dividerColor,
  });

  final List<Widget>? actions;
  final ScrollController controller;
  final bool hasCancelButton;
  final Color sheetColor;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    if (actions == null || actions!.isEmpty) {
      return const SizedBox.shrink();
    }

    return CupertinoAlertActionSection(
      scrollController: controller,
      hasCancelButton: hasCancelButton,
      isActionSheet: true,
      dialogColor: sheetColor,
      dividerColor: dividerColor,
      children: actions!,
    );
  }
}

@immutable
class _CupertinoActionSheetCancelButton extends StatefulWidget {
  const _CupertinoActionSheetCancelButton({
    this.child,
    required this.cancelButtonColor,
  });

  final Widget? child;
  final Color cancelButtonColor;

  @override
  _CupertinoActionSheetCancelButtonState createState() =>
      _CupertinoActionSheetCancelButtonState();
}

class _CupertinoActionSheetCancelButtonState
    extends State<_CupertinoActionSheetCancelButton> {
  bool isBeingPressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => isBeingPressed = true);

  void _onTapUp(TapUpDetails _) => setState(() => isBeingPressed = false);

  void _onTapCancel() => setState(() => isBeingPressed = false);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isBeingPressed
        ? CupertinoDynamicColor.withBrightness(
            color: darkenDialogPressedColor(widget.cancelButtonColor),
            darkColor: lightenDialogPressedColor(widget.cancelButtonColor),
          ).resolveFrom(context)
        : widget.cancelButtonColor;

    return GestureDetector(
      excludeFromSemantics: true,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: kSheetCornerRadius,
        ),
        child: widget.child,
      ),
    );
  }
}
