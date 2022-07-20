import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'theme.dart';

@immutable
class CupertinoDialogTheme with Diagnosticable {
  const CupertinoDialogTheme({
    this.backgroundColor,
    this.dividerColor,
    this.destructiveColor,
    this.actionStyle,
    this.titleStyle,
    this.contentStyle,
  });

  final Color? backgroundColor;
  final Color? dividerColor;
  final Color? destructiveColor;
  final TextStyle? actionStyle;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;

  /// Get [CupertinoDialogTheme] from [CupertinoDialogExtendedTheme.of].
  static CupertinoDialogTheme? of(BuildContext context) =>
      CupertinoDialogExtendedTheme.of(context)?.dialogTheme;

  /// Helper method to get required theme property.
  ///
  /// Inspired by [ButtonStyleButton] `effectiveValue` function.
  @internal
  static T getProperty<T>({
    required CupertinoDialogTheme? widgetTheme,
    required CupertinoDialogTheme? theme,
    required CupertinoDialogTheme defaults,
    required T? Function(CupertinoDialogTheme? theme) getThemeProperty,
  }) {
    final widgetThemeValue = getThemeProperty(widgetTheme);
    final themeValue = getThemeProperty(theme);
    final defaultsValue = getThemeProperty(defaults) as T;

    return widgetThemeValue ?? themeValue ?? defaultsValue;
  }

  CupertinoDialogTheme copyWith({
    Color? backgroundColor,
    Color? dividerColor,
    Color? destructiveColor,
    TextStyle? actionStyle,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
  }) =>
      CupertinoDialogTheme(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        dividerColor: dividerColor ?? this.dividerColor,
        destructiveColor: destructiveColor ?? this.destructiveColor,
        actionStyle: actionStyle ?? this.actionStyle,
        titleStyle: titleStyle ?? this.titleStyle,
        contentStyle: contentStyle ?? this.contentStyle,
      );

  static CupertinoDialogTheme? lerp(
    CupertinoDialogTheme? a,
    CupertinoDialogTheme? b,
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

    return CupertinoDialogTheme(
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      dividerColor: Color.lerp(a?.dividerColor, b?.dividerColor, t),
      destructiveColor: Color.lerp(a?.destructiveColor, b?.destructiveColor, t),
      actionStyle: TextStyle.lerp(a?.actionStyle, b?.actionStyle, t),
      titleStyle: TextStyle.lerp(a?.titleStyle, b?.titleStyle, t),
      contentStyle: TextStyle.lerp(a?.contentStyle, b?.contentStyle, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        dividerColor,
        destructiveColor,
        actionStyle,
        titleStyle,
        contentStyle,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is CupertinoDialogTheme &&
        other.backgroundColor == backgroundColor &&
        other.dividerColor == dividerColor &&
        other.destructiveColor == destructiveColor &&
        other.actionStyle == actionStyle &&
        other.titleStyle == titleStyle &&
        other.contentStyle == contentStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null),
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
          'contentStyle',
          contentStyle,
          defaultValue: null,
        ),
      );
  }
}
