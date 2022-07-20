import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

import 'actions_render_widget.dart';

@immutable
@internal
class ActionButtonParentDataWidget
    extends ParentDataWidget<ActionButtonParentData> {
  const ActionButtonParentDataWidget({
    super.key,
    required this.isPressed,
    required super.child,
  });

  final bool isPressed;

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData! as ActionButtonParentData;
    if (parentData.isPressed != isPressed) {
      parentData.isPressed = isPressed;

      // Force a repaint.
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsPaint();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => ActionsRenderWidget;
}

// ParentData applied to individual action buttons that report whether or not
// that button is currently pressed by the user.
class ActionButtonParentData extends MultiChildLayoutParentData {
  bool isPressed = false;
}
