import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'theme.dart';

@immutable
class CupertinoActionSheetTheme with Diagnosticable {
  const CupertinoActionSheetTheme({
    this.backgroundColor,
    this.cancelButtonBackgroundColor,
    this.dividerColor,
    this.destructiveColor,
    this.actionStyle,
    this.titleStyle,
    this.messageStyle,
  });

  final Color? backgroundColor;
  final Color? cancelButtonBackgroundColor;
  final Color? dividerColor;
  final Color? destructiveColor;
  final TextStyle? actionStyle;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  /// Get [CupertinoActionSheetTheme] from [CupertinoDialogExtendedTheme.of].
  static CupertinoActionSheetTheme? of(BuildContext context) =>
      CupertinoDialogExtendedTheme.of(context)?.actionSheetTheme;

  /// Helper method to get required theme property.
  ///
  /// Inspired by [ButtonStyleButton] `effectiveValue` function.
  @internal
  static T getProperty<T>({
    required CupertinoActionSheetTheme? widgetTheme,
    required CupertinoActionSheetTheme? theme,
    required CupertinoActionSheetTheme defaults,
    required T? Function(CupertinoActionSheetTheme? theme) getThemeProperty,
  }) {
    final widgetThemeValue = getThemeProperty(widgetTheme);

    final themeValue = getThemeProperty(theme);
    final defaultsValue = getThemeProperty(defaults) as T;

    return widgetThemeValue ?? themeValue ?? defaultsValue;
  }

  CupertinoActionSheetTheme copyWith({
    Color? backgroundColor,
    Color? cancelButtonBackgroundColor,
    Color? dividerColor,
    Color? destructiveColor,
    TextStyle? actionStyle,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) =>
      CupertinoActionSheetTheme(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        cancelButtonBackgroundColor:
            cancelButtonBackgroundColor ?? this.cancelButtonBackgroundColor,
        dividerColor: dividerColor ?? this.dividerColor,
        destructiveColor: destructiveColor ?? this.destructiveColor,
        actionStyle: actionStyle ?? this.actionStyle,
        titleStyle: titleStyle ?? this.titleStyle,
        messageStyle: messageStyle ?? this.messageStyle,
      );

  static CupertinoActionSheetTheme? lerp(
    CupertinoActionSheetTheme? a,
    CupertinoActionSheetTheme? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }

    return CupertinoActionSheetTheme(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      cancelButtonBackgroundColor: Color.lerp(
        a?.cancelButtonBackgroundColor,
        b?.cancelButtonBackgroundColor,
        t,
      ),
      dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
      destructiveColor: Color.lerp(a?.destructiveColor, b?.destructiveColor, t),
      actionStyle: TextStyle.lerp(a?.actionStyle, b?.actionStyle, t),
      titleStyle: TextStyle.lerp(a?.titleStyle, b?.titleStyle, t),
      messageStyle: TextStyle.lerp(a?.messageStyle, b?.messageStyle, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        cancelButtonBackgroundColor,
        dividerColor,
        destructiveColor,
        actionStyle,
        titleStyle,
        messageStyle,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is CupertinoActionSheetTheme &&
        other.backgroundColor == backgroundColor &&
        other.cancelButtonBackgroundColor == cancelButtonBackgroundColor &&
        other.dividerColor == dividerColor &&
        other.destructiveColor == destructiveColor &&
        other.actionStyle == actionStyle &&
        other.titleStyle == titleStyle &&
        other.messageStyle == messageStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null),
      )
      ..add(
        ColorProperty(
          'cancelButtonBackgroundColor',
          cancelButtonBackgroundColor,
          defaultValue: null,
        ),
      )
      ..add(
        ColorProperty('dividerColor', dividerColor, defaultValue: null),
      )
      ..add(
        ColorProperty('destructiveColor', destructiveColor, defaultValue: null),
      )
      ..add(
        DiagnosticsProperty<TextStyle>(
          'actionStyle',
          actionStyle,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<TextStyle>(
          'titleStyle',
          titleStyle,
          defaultValue: null,
        ),
      )
      ..add(
        DiagnosticsProperty<TextStyle>(
          'messageStyle',
          messageStyle,
          defaultValue: null,
        ),
      );
  }
}
