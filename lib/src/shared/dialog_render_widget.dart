import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../utils/utils.dart';
import 'render_dialog.dart';

@immutable
@internal
class CupertinoDialogRenderWidget extends RenderObjectWidget {
  const CupertinoDialogRenderWidget({
    super.key,
    required this.contentSection,
    required this.actionsSection,
    required this.dividerColor,
    this.isActionSheet = false,
  });

  final Widget contentSection;
  final Widget actionsSection;
  final Color dividerColor;
  final bool isActionSheet;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderDialog(
        dividerThickness: 0.5,
        isInAccessibilityMode: isInAccessibilityMode(context) && !isActionSheet,
        dividerColor: dividerColor,
        isActionSheet: isActionSheet,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    RenderDialog renderObject,
  ) {
    renderObject
      ..isInAccessibilityMode = isInAccessibilityMode(context) && !isActionSheet
      ..dividerColor = dividerColor;
  }

  @override
  RenderObjectElement createElement() => _CupertinoDialogRenderElement(
        this,
        allowMoveRenderObjectChild: isActionSheet,
      );
}

class _CupertinoDialogRenderElement extends RenderObjectElement {
  _CupertinoDialogRenderElement(
    CupertinoDialogRenderWidget super.widget, {
    this.allowMoveRenderObjectChild = false,
  });

  // Whether to allow overridden method moveRenderObjectChild call or default
  // to super. CupertinoActionSheet should default to [super] but
  // CupertinoAlertDialog not.
  final bool allowMoveRenderObjectChild;

  Element? _contentElement;
  Element? _actionsElement;

  @override
  RenderDialog get renderObject => super.renderObject as RenderDialog;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_contentElement != null) {
      visitor(_contentElement!);
    }
    if (_actionsElement != null) {
      visitor(_actionsElement!);
    }
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    final dialogRenderWidget = widget as CupertinoDialogRenderWidget;
    _contentElement = updateChild(
      _contentElement,
      dialogRenderWidget.contentSection,
      _AlertDialogSections.contentSection,
    );
    _actionsElement = updateChild(
      _actionsElement,
      dialogRenderWidget.actionsSection,
      _AlertDialogSections.actionsSection,
    );
  }

  @override
  void insertRenderObjectChild(RenderObject child, _AlertDialogSections slot) {
    _placeChildInSlot(child, slot);
  }

  @override
  void moveRenderObjectChild(
    RenderObject child,
    _AlertDialogSections oldSlot,
    _AlertDialogSections newSlot,
  ) {
    if (!allowMoveRenderObjectChild) {
      super.moveRenderObjectChild(child, oldSlot, newSlot);

      return;
    }

    _placeChildInSlot(child, newSlot);
  }

  @override
  void update(RenderObjectWidget newWidget) {
    super.update(newWidget);
    final dialogRenderWidget = widget as CupertinoDialogRenderWidget;
    _contentElement = updateChild(
      _contentElement,
      dialogRenderWidget.contentSection,
      _AlertDialogSections.contentSection,
    );
    _actionsElement = updateChild(
      _actionsElement,
      dialogRenderWidget.actionsSection,
      _AlertDialogSections.actionsSection,
    );
  }

  @override
  void forgetChild(Element child) {
    if (_contentElement == child) {
      _contentElement = null;
    } else {
      _actionsElement = null;
    }
    super.forgetChild(child);
  }

  @override
  void removeRenderObjectChild(RenderObject child, _AlertDialogSections slot) {
    if (renderObject.contentSection == child) {
      renderObject.contentSection = null;
    } else {
      renderObject.actionsSection = null;
    }
  }

  void _placeChildInSlot(RenderObject child, _AlertDialogSections slot) {
    switch (slot) {
      case _AlertDialogSections.contentSection:
        renderObject.contentSection = child as RenderBox;
        break;
      case _AlertDialogSections.actionsSection:
        renderObject.actionsSection = child as RenderBox;
        break;
    }
  }
}

// Visual components of an alert dialog that need to be explicitly sized and
// laid out at runtime.
enum _AlertDialogSections {
  contentSection,
  actionsSection,
}
