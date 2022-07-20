import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

import '../activity_sheet/utils/constants.dart';
import '../dialog/utils/constants.dart';

@immutable
class _AlertDialogSizes {
  const _AlertDialogSizes({
    required this.size,
    required this.contentHeight,
    required this.dividerThickness,
  });

  final Size size;
  final double contentHeight;
  final double dividerThickness;
}

@internal
class RenderDialog extends RenderBox {
  RenderDialog({
    RenderBox? contentSection,
    RenderBox? actionsSection,
    double dividerThickness = 0.0,
    bool isInAccessibilityMode = false,
    bool isActionSheet = false,
    required Color dividerColor,
  })  : _contentSection = contentSection,
        _actionsSection = actionsSection,
        _dividerThickness = dividerThickness,
        _isInAccessibilityMode = isInAccessibilityMode,
        _isActionSheet = isActionSheet,
        _dividerPaint = Paint()
          ..color = dividerColor
          ..style = PaintingStyle.fill;

  RenderBox? get contentSection => _contentSection;
  RenderBox? _contentSection;
  set contentSection(RenderBox? newContentSection) {
    if (newContentSection != _contentSection) {
      if (_contentSection != null) {
        dropChild(_contentSection!);
      }
      _contentSection = newContentSection;
      if (_contentSection != null) {
        adoptChild(_contentSection!);
      }
    }
  }

  RenderBox? get actionsSection => _actionsSection;
  RenderBox? _actionsSection;
  set actionsSection(RenderBox? newActionsSection) {
    if (newActionsSection != _actionsSection) {
      if (null != _actionsSection) {
        dropChild(_actionsSection!);
      }
      _actionsSection = newActionsSection;
      if (null != _actionsSection) {
        adoptChild(_actionsSection!);
      }
    }
  }

  bool get isInAccessibilityMode => _isInAccessibilityMode;
  bool _isInAccessibilityMode;
  set isInAccessibilityMode(bool newValue) {
    if (newValue != _isInAccessibilityMode) {
      _isInAccessibilityMode = newValue;
      markNeedsLayout();
    }
  }

  bool _isActionSheet;
  bool get isActionSheet => _isActionSheet;
  set isActionSheet(bool newValue) {
    if (newValue != _isActionSheet) {
      _isActionSheet = newValue;
      markNeedsLayout();
    }
  }

  double get _dialogWidth => isInAccessibilityMode
      ? kAccessibilityCupertinoDialogWidth
      : kCupertinoDialogWidth;

  final double _dividerThickness;
  final Paint _dividerPaint;

  Color get dividerColor => _dividerPaint.color;
  set dividerColor(Color newValue) {
    if (dividerColor == newValue) {
      return;
    }

    _dividerPaint.color = newValue;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (null != contentSection) {
      contentSection!.attach(owner);
    }
    if (null != actionsSection) {
      actionsSection!.attach(owner);
    }
  }

  @override
  void detach() {
    super.detach();
    if (null != contentSection) {
      contentSection!.detach();
    }
    if (null != actionsSection) {
      actionsSection!.detach();
    }
  }

  @override
  void redepthChildren() {
    if (null != contentSection) {
      redepthChild(contentSection!);
    }
    if (null != actionsSection) {
      redepthChild(actionsSection!);
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (!isActionSheet && child.parentData is! BoxParentData) {
      child.parentData = BoxParentData();
    } else if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (contentSection != null) {
      visitor(contentSection!);
    }
    if (actionsSection != null) {
      visitor(actionsSection!);
    }
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() => <DiagnosticsNode>[
        if (contentSection != null)
          contentSection!.toDiagnosticsNode(name: 'content'),
        if (actionsSection != null)
          actionsSection!.toDiagnosticsNode(name: 'actions'),
      ];

  @override
  double computeMinIntrinsicWidth(double height) =>
      isActionSheet ? constraints.minWidth : _dialogWidth;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      isActionSheet ? constraints.maxWidth : _dialogWidth;

  @override
  double computeMinIntrinsicHeight(double width) {
    final contentHeight = contentSection!.getMinIntrinsicHeight(width);
    final actionsHeight = actionsSection!.getMinIntrinsicHeight(width);
    final hasDivider = contentHeight > 0.0 && actionsHeight > 0.0;
    var height =
        contentHeight + (hasDivider ? _dividerThickness : 0.0) + actionsHeight;

    if (isActionSheet && (actionsHeight > 0 || contentHeight > 0)) {
      height -= kActionSheetEdgeVerticalPadding * 2;
    }
    if (height.isFinite) {
      return height;
    }

    return 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final contentHeight = contentSection!.getMaxIntrinsicHeight(width);
    final actionsHeight = actionsSection!.getMaxIntrinsicHeight(width);
    final hasDivider = contentHeight > 0.0 && actionsHeight > 0.0;
    var height =
        contentHeight + (hasDivider ? _dividerThickness : 0.0) + actionsHeight;

    if (isActionSheet && (actionsHeight > 0 || contentHeight > 0)) {
      height -= kActionSheetEdgeVerticalPadding * 2;
    }
    if (height.isFinite) {
      return height;
    }

    return 0;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => _performLayout(
        constraints: constraints,
        layoutChild: ChildLayoutHelper.dryLayoutChild,
      ).size;

  @override
  void performLayout() {
    final dialogSizes = _performLayout(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    size = dialogSizes.size;

    if (isActionSheet) {
      (actionsSection!.parentData! as MultiChildLayoutParentData).offset =
          Offset(0, dialogSizes.contentHeight + dialogSizes.dividerThickness);
    } else {
      (actionsSection!.parentData! as BoxParentData).offset =
          Offset(0, dialogSizes.contentHeight + dialogSizes.dividerThickness);
    }
  }

  _AlertDialogSizes _performLayout({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) =>
      isInAccessibilityMode
          ? performAccessibilityLayout(
              constraints: constraints,
              layoutChild: layoutChild,
            )
          : performRegularLayout(
              constraints: constraints,
              layoutChild: layoutChild,
            );

  // When not in accessibility mode, an alert dialog might reduce the space
  // for buttons to just over 1 button's height to make room for the content
  // section.
  _AlertDialogSizes performRegularLayout({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    final maxIntrinsicWidth = computeMaxIntrinsicWidth(0);

    final hasDivider =
        contentSection!.getMaxIntrinsicHeight(maxIntrinsicWidth) > 0.0 &&
            actionsSection!.getMaxIntrinsicHeight(maxIntrinsicWidth) > 0.0;
    final dividerThickness = hasDivider ? _dividerThickness : 0.0;

    final minActionsHeight =
        actionsSection!.getMinIntrinsicHeight(maxIntrinsicWidth);

    final contentSize = layoutChild(
      contentSection!,
      constraints.deflate(
        EdgeInsets.only(bottom: minActionsHeight + dividerThickness),
      ),
    );

    final actionsSize = layoutChild(
      actionsSection!,
      constraints
          .deflate(EdgeInsets.only(top: contentSize.height + dividerThickness)),
    );

    final dialogHeight =
        contentSize.height + dividerThickness + actionsSize.height;

    return _AlertDialogSizes(
      size: isActionSheet
          ? Size(constraints.maxWidth, dialogHeight)
          : constraints.constrain(Size(_dialogWidth, dialogHeight)),
      contentHeight: contentSize.height,
      dividerThickness: dividerThickness,
    );
  }

  // When in accessibility mode, an alert dialog will allow buttons to take
  // up to 50% of the dialog height, even if the content exceeds available space
  _AlertDialogSizes performAccessibilityLayout({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    final maxContentHeight =
        contentSection!.getMaxIntrinsicHeight(_dialogWidth);
    final maxActionsHeight =
        actionsSection!.getMaxIntrinsicHeight(_dialogWidth);

    final hasDivider = maxContentHeight > 0.0 && maxActionsHeight > 0.0;
    final dividerThickness = hasDivider ? _dividerThickness : 0.0;

    final Size contentSize;
    final Size actionsSize;
    if (maxContentHeight + dividerThickness + maxActionsHeight >
        constraints.maxHeight) {
      // AlertDialog: There isn't enough room for everything. Following iOS's
      // accessibility dialog layout policy, first we allow the actions to take
      // up to 50% of the dialog height. Second we fill the rest of the
      // available space with the content section.

      actionsSize = layoutChild(
        actionsSection!,
        constraints.deflate(EdgeInsets.only(top: constraints.maxHeight / 2.0)),
      );

      contentSize = layoutChild(
        contentSection!,
        constraints.deflate(
          EdgeInsets.only(bottom: actionsSize.height + dividerThickness),
        ),
      );
    } else {
      // Everything fits. Give content and actions all the space they want.

      contentSize = layoutChild(
        contentSection!,
        constraints,
      );

      actionsSize = layoutChild(
        actionsSection!,
        constraints.deflate(EdgeInsets.only(top: contentSize.height)),
      );
    }

    // Calculate overall dialog height.
    final dialogHeight =
        contentSize.height + dividerThickness + actionsSize.height;

    return _AlertDialogSizes(
      size: constraints.constrain(Size(_dialogWidth, dialogHeight)),
      contentHeight: contentSize.height,
      dividerThickness: dividerThickness,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (isActionSheet) {
      final contentParentData =
          contentSection!.parentData! as MultiChildLayoutParentData;
      contentSection!.paint(context, offset + contentParentData.offset);
    } else {
      final contentParentData = contentSection!.parentData! as BoxParentData;
      contentSection!.paint(context, offset + contentParentData.offset);
    }

    final hasDivider =
        contentSection!.size.height > 0.0 && actionsSection!.size.height > 0.0;
    if (hasDivider) {
      _paintDividerBetweenContentAndActions(context.canvas, offset);
    }

    if (isActionSheet) {
      final actionsParentData =
          actionsSection!.parentData! as MultiChildLayoutParentData;
      actionsSection!.paint(context, offset + actionsParentData.offset);
    } else {
      final actionsParentData = actionsSection!.parentData! as BoxParentData;
      actionsSection!.paint(context, offset + actionsParentData.offset);
    }
  }

  void _paintDividerBetweenContentAndActions(Canvas canvas, Offset offset) {
    canvas.drawRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy + contentSection!.size.height,
        size.width,
        _dividerThickness,
      ),
      _dividerPaint,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (isActionSheet) {
      final contentSectionParentData =
          contentSection!.parentData! as MultiChildLayoutParentData;
      final actionsSectionParentData =
          actionsSection!.parentData! as MultiChildLayoutParentData;

      return result.addWithPaintOffset(
            offset: contentSectionParentData.offset,
            position: position,
            hitTest: (result, transformed) =>
                contentSection!.hitTest(result, position: transformed),
          ) ||
          result.addWithPaintOffset(
            offset: actionsSectionParentData.offset,
            position: position,
            hitTest: (result, transformed) =>
                actionsSection!.hitTest(result, position: transformed),
          );
    }

    final contentSectionParentData =
        contentSection!.parentData! as BoxParentData;
    final actionsSectionParentData =
        actionsSection!.parentData! as BoxParentData;

    return result.addWithPaintOffset(
          offset: contentSectionParentData.offset,
          position: position,
          hitTest: (result, transformed) =>
              contentSection!.hitTest(result, position: transformed),
        ) ||
        result.addWithPaintOffset(
          offset: actionsSectionParentData.offset,
          position: position,
          hitTest: (result, transformed) =>
              actionsSection!.hitTest(result, position: transformed),
        );
  }
}
