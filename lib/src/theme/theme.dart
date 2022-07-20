import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'action_sheet_theme.dart';
import 'dialog_theme.dart';
import 'inherited_theme.dart';

@immutable
class CupertinoDialogExtendedTheme
    extends ThemeExtension<CupertinoDialogExtendedTheme> with Diagnosticable {
  /// Creates [CupertinoDialogTheme] and [CupertinoActionSheetTheme] used
  /// to configure [CupertinoDialogExtendedTheme].
  const CupertinoDialogExtendedTheme({
    this.dialogTheme,
    this.actionSheetTheme,
  });

  /// The [CupertinoActionSheetTheme] configuration.
  final CupertinoDialogTheme? dialogTheme;

  /// The [CupertinoActionSheetTheme] configuration.
  final CupertinoActionSheetTheme? actionSheetTheme;

  /// Get [CupertinoDialogExtendedTheme] from
  /// [CupertinoDialogExtendedInheritedTheme].
  ///
  /// If that's null get [CupertinoDialogExtendedTheme] from
  /// [ThemeData.extensions] property of the ambient [Theme].
  static CupertinoDialogExtendedTheme? of(BuildContext context) =>
      CupertinoDialogExtendedInheritedTheme.of(context) ??
      Theme.of(context).extensions[CupertinoDialogExtendedTheme]
          as CupertinoDialogExtendedTheme?;

  @override
  CupertinoDialogExtendedTheme copyWith({
    CupertinoDialogTheme? dialogTheme,
    CupertinoActionSheetTheme? actionSheetTheme,
  }) =>
      CupertinoDialogExtendedTheme(
        dialogTheme: dialogTheme ?? this.dialogTheme,
        actionSheetTheme: actionSheetTheme ?? this.actionSheetTheme,
      );

  @override
  CupertinoDialogExtendedTheme lerp(
    ThemeExtension<CupertinoDialogExtendedTheme>? other,
    double t,
  ) {
    if (other is! CupertinoDialogExtendedTheme) return this;

    return CupertinoDialogExtendedTheme(
      dialogTheme: CupertinoDialogTheme.lerp(dialogTheme, other.dialogTheme, t),
      actionSheetTheme: CupertinoActionSheetTheme.lerp(
        actionSheetTheme,
        other.actionSheetTheme,
        t,
      ),
    );
  }

  @override
  int get hashCode => Object.hash(dialogTheme, actionSheetTheme);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is CupertinoDialogExtendedTheme &&
        other.dialogTheme == dialogTheme &&
        other.actionSheetTheme == actionSheetTheme;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (dialogTheme != null) {
      properties.add(dialogTheme!.toDiagnosticsNode(name: 'dialogTheme'));
    }
    if (actionSheetTheme != null) {
      properties.add(
        actionSheetTheme!.toDiagnosticsNode(name: 'actionSheetTheme'),
      );
    }
  }
}
