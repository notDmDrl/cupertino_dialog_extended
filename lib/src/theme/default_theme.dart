import 'package:flutter/cupertino.dart';

import 'action_sheet_theme.dart';
import 'dialog_theme.dart';
import 'theme.dart';

// Dialog constants
const _kDialogBackgroundColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(242, 242, 242, 0.8),
  darkColor: Color.fromRGBO(30, 30, 30, 0.75),
);

// Action sheet constants
const _kSheetBackgroundColor = CupertinoDynamicColor.withBrightness(
  color: Color.fromRGBO(245, 245, 245, 0.7),
  darkColor: Color.fromRGBO(24, 24, 24, 0.7),
);

const _kSheetCancelButtonBackground = CupertinoDynamicColor.withBrightness(
  color: Color.fromARGB(255, 255, 255, 255),
  darkColor: Color.fromARGB(255, 28, 28, 30),
);

/// Based on values from https://www.figma.com/community/file/984106517828363349
@immutable
class CupertinoDialogExtendedThemeDefaults
    extends CupertinoDialogExtendedTheme {
  const CupertinoDialogExtendedThemeDefaults(this.context);

  final BuildContext context;

  static const _sfProText = '.SF Pro Text';
  static const _sfProDisplay = '.SF Pro Display';

  @override
  CupertinoDialogTheme get dialogTheme {
    const actionStyle = TextStyle(
      fontFamily: _sfProText,
      inherit: false,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.3,
      letterSpacing: -0.41,
      textBaseline: TextBaseline.alphabetic,
    );

    final label = CupertinoDynamicColor.resolve(
      CupertinoColors.label,
      context,
    );

    return CupertinoDialogTheme(
      backgroundColor: CupertinoDynamicColor.resolve(
        _kDialogBackgroundColor,
        context,
      ),
      dividerColor: CupertinoDynamicColor.resolve(
        CupertinoColors.separator,
        context,
      ),
      destructiveColor: CupertinoDynamicColor.resolve(
        CupertinoColors.destructiveRed,
        context,
      ),
      actionStyle: actionStyle.copyWith(
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.systemBlue,
          context,
        ),
      ),
      titleStyle: actionStyle.copyWith(
        color: label,
        fontWeight: FontWeight.w600,
      ),
      contentStyle: TextStyle(
        fontFamily: _sfProText,
        inherit: false,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: -0.1,
        color: label,
        textBaseline: TextBaseline.alphabetic,
      ),
    );
  }

  @override
  CupertinoActionSheetTheme get actionSheetTheme {
    final titleStyle = TextStyle(
      fontFamily: _sfProText,
      inherit: false,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.4,
      letterSpacing: -0.08,
      color: CupertinoColors.secondaryLabel.resolveFrom(context),
      textBaseline: TextBaseline.alphabetic,
    );

    return CupertinoActionSheetTheme(
      backgroundColor: _kSheetBackgroundColor.resolveFrom(context),
      cancelButtonBackgroundColor: CupertinoDynamicColor.resolve(
        _kSheetCancelButtonBackground,
        context,
      ),
      dividerColor: CupertinoDynamicColor.resolve(
        CupertinoColors.separator,
        context,
      ),
      destructiveColor: CupertinoDynamicColor.resolve(
        CupertinoColors.destructiveRed,
        context,
      ),
      actionStyle: TextStyle(
        fontFamily: _sfProDisplay,
        inherit: false,
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.38,
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.systemBlue,
          context,
        ),
        textBaseline: TextBaseline.alphabetic,
      ),
      titleStyle: titleStyle,
      messageStyle: titleStyle,
    );
  }
}
