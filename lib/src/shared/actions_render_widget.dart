import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../dialog/utils/constants.dart';
import '../utils/utils.dart';
import 'render_actions.dart';

@internal
class ActionsRenderWidget extends MultiChildRenderObjectWidget {
  ActionsRenderWidget({
    super.key,
    required super.children,
    this.hasCancelButton = false,
    this.isActionSheet = false,
    required this.dividerColor,
    required this.dialogColor,
  });

  final bool hasCancelButton;
  final bool isActionSheet;
  final Color dividerColor;
  final Color dialogColor;

  double? _width(BuildContext context) => isActionSheet
      ? null
      : isInAccessibilityMode(context)
          ? kAccessibilityCupertinoDialogWidth
          : kCupertinoDialogWidth;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderActions(
        dialogWidth: _width(context),
        dividerThickness: 0.5,
        dialogColor: dialogColor,
        dialogPressedColor: CupertinoDynamicColor.withBrightness(
          color: darkenDialogPressedColor(dialogColor),
          darkColor: lightenDialogPressedColor(dialogColor),
        ).resolveFrom(context),
        dividerColor: dividerColor,
        hasCancelButton: hasCancelButton,
        isActionSheet: isActionSheet,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderActions renderObject,
  ) {
    renderObject
      ..dialogWidth = _width(context)
      ..dividerThickness = 0.5
      ..dialogColor = dialogColor
      ..dialogPressedColor = CupertinoDynamicColor.withBrightness(
        color: darkenDialogPressedColor(dialogColor),
        darkColor: lightenDialogPressedColor(dialogColor),
      ).resolveFrom(context)
      ..dividerColor = dividerColor
      ..hasCancelButton = hasCancelButton
      ..isActionSheet = isActionSheet;
  }
}
