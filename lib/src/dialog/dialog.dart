import 'dart:math';
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

/// An iOS-style alert dialog.
///
/// See [CupertinoAlertDialog].
@immutable
class CupertinoAlertDialogExtended extends StatelessWidget {
  /// Creates an iOS-style alert dialog.
  const CupertinoAlertDialogExtended({
    super.key,
    this.title,
    this.content,
    this.actions = const <Widget>[],
    this.scrollController,
    this.actionScrollController,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.theme,
  });

  /// The (optional) title of the dialog is displayed in a large font at the top
  /// of the dialog.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// The (optional) content of the dialog is displayed in the center of the
  /// dialog in a lighter font.
  ///
  /// Typically a [Text] widget.
  final Widget? content;

  /// The (optional) set of actions that are displayed at the bottom of the
  /// dialog.
  ///
  /// Typically this is a list of [CupertinoDialogActionExtended] widgets.
  final List<Widget> actions;

  /// A scroll controller that can be used to control the scrolling of the
  /// [content] in the dialog.
  ///
  /// Defaults to null, and is typically not needed, since most alert messages
  /// are short.
  ///
  /// See also:
  ///
  ///  * [actionScrollController], which can be used for controlling the actions
  ///    section when there are many actions.
  final ScrollController? scrollController;

  /// A scroll controller that can be used to control the scrolling of the
  /// actions in the dialog.
  ///
  /// Defaults to null, and is typically not needed.
  ///
  /// See also:
  ///
  ///  * [scrollController], which can be used for controlling the [content]
  ///    section when it is long.
  final ScrollController? actionScrollController;

  /// {@macro flutter.material.dialog.insetAnimationDuration}
  final Duration insetAnimationDuration;

  /// {@macro flutter.material.dialog.insetAnimationCurve}
  final Curve insetAnimationCurve;

  final CupertinoDialogTheme? theme;

  ScrollController get _effectiveScrollController =>
      scrollController ?? ScrollController();

  ScrollController get _effectiveActionScrollController =>
      actionScrollController ?? ScrollController();

  @override
  Widget build(BuildContext context) {
    final localizations = CupertinoLocalizations.of(context);
    final isInAccessibility = isInAccessibilityMode(context);
    final mediaQueryData = MediaQuery.of(context);

    final textScaleFactor = mediaQueryData.textScaleFactor;

    final defaults = CupertinoDialogExtendedThemeDefaults(context).dialogTheme;
    final themeOfContext = CupertinoDialogTheme.of(context);

    Widget actionSection = const SizedBox.shrink();

    if (actions.isNotEmpty) {
      final dividerColor = CupertinoDialogTheme.getProperty<Color>(
        widgetTheme: theme,
        theme: themeOfContext,
        defaults: defaults,
        getThemeProperty: (theme) => theme?.dividerColor,
      );

      final dialogColor = CupertinoDialogTheme.getProperty<Color>(
        widgetTheme: theme,
        theme: themeOfContext,
        defaults: defaults,
        getThemeProperty: (theme) => theme?.backgroundColor,
      );

      actionSection = CupertinoAlertActionSection(
        scrollController: _effectiveActionScrollController,
        dialogColor: dialogColor,
        dividerColor: dividerColor,
        children: actions,
      );
    }

    return CupertinoUserInterfaceLevel(
      data: CupertinoUserInterfaceLevelData.elevated,
      child: MediaQuery(
        data: mediaQueryData.copyWith(
          textScaleFactor: max(textScaleFactor, 1),
        ),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Builder(
            builder: (context) => AnimatedPadding(
              padding: mediaQueryData.viewInsets +
                  const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 24,
                  ),
              duration: insetAnimationDuration,
              curve: insetAnimationCurve,
              child: MediaQuery.removeViewInsets(
                removeLeft: true,
                removeTop: true,
                removeRight: true,
                removeBottom: true,
                context: context,
                child: _Dialog(
                  isInAccessibility: isInAccessibility,
                  alertDialogLabel: localizations.alertDialogLabel,
                  title: title,
                  content: content,
                  effectiveScrollController: _effectiveScrollController,
                  actionSection: actionSection,
                  widgetTheme: theme,
                  theme: themeOfContext,
                  defaults: defaults,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _Dialog extends StatelessWidget {
  const _Dialog({
    required this.isInAccessibility,
    required this.alertDialogLabel,
    required this.title,
    required this.content,
    required this.effectiveScrollController,
    required this.actionSection,
    required this.widgetTheme,
    required this.theme,
    required this.defaults,
  });

  final bool isInAccessibility;
  final String alertDialogLabel;
  final Widget? title;
  final Widget? content;
  final ScrollController effectiveScrollController;
  final Widget actionSection;
  final CupertinoDialogTheme? widgetTheme;
  final CupertinoDialogTheme? theme;
  final CupertinoDialogTheme defaults;

  @override
  Widget build(BuildContext context) {
    final dividerColor = CupertinoDialogTheme.getProperty<Color>(
      widgetTheme: widgetTheme,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.dividerColor,
    );

    final dialogColor = CupertinoDialogTheme.getProperty<Color>(
      widgetTheme: widgetTheme,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.backgroundColor,
    );

    final titleStyle = CupertinoDialogTheme.getProperty<TextStyle>(
      widgetTheme: widgetTheme,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.titleStyle,
    );

    final messageStyle = CupertinoDialogTheme.getProperty<TextStyle>(
      widgetTheme: widgetTheme,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.contentStyle,
    );

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: kDialogEdgePadding,
        ),
        width: isInAccessibility
            ? kAccessibilityCupertinoDialogWidth
            : kCupertinoDialogWidth,
        child: _CupertinoPopupSurface(
          child: Semantics(
            namesRoute: true,
            scopesRoute: true,
            explicitChildNodes: true,
            label: alertDialogLabel,
            child: CupertinoDialogRenderWidget(
              contentSection: _DialogContent(
                title: title,
                content: content,
                controller: effectiveScrollController,
                titleTextStyle: titleStyle,
                messageTextStyle: messageStyle,
                dialogColor: dialogColor,
              ),
              actionsSection: actionSection,
              dividerColor: dividerColor,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _DialogContent extends StatelessWidget {
  const _DialogContent({
    required this.title,
    required this.content,
    required this.controller,
    required this.titleTextStyle,
    required this.messageTextStyle,
    required this.dialogColor,
  });

  final Widget? title;
  final Widget? content;
  final ScrollController controller;
  final TextStyle titleTextStyle;
  final TextStyle messageTextStyle;
  final Color dialogColor;

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // TODO(notDmdrl): do we even need column with flexible here?
    // seems redundant.
    final children = [
      if (title != null || content != null)
        Flexible(
          flex: 3,
          child: CupertinoAlertContentSection(
            title: title,
            message: content,
            scrollController: controller,
            titlePadding: EdgeInsets.only(
              left: kDialogEdgePadding,
              right: kDialogEdgePadding,
              bottom: content == null ? kDialogEdgePadding : 1.0,
              top: kDialogEdgePadding * textScaleFactor,
            ),
            messagePadding: EdgeInsets.only(
              left: kDialogEdgePadding,
              right: kDialogEdgePadding,
              bottom: kDialogEdgePadding * textScaleFactor,
              top: title == null ? kDialogEdgePadding : 1.0,
            ),
            titleTextStyle: titleTextStyle,
            messageTextStyle: messageTextStyle,
          ),
        ),
    ];

    return ColoredBox(
      color: dialogColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

@immutable
class _CupertinoPopupSurface extends StatelessWidget {
  const _CupertinoPopupSurface({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: kCornerRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: kBlurAmount, sigmaY: kBlurAmount),
          child: child,
        ),
      );
}
