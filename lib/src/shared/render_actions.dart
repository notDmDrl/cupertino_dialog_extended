import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

import 'parent_data.dart';

// Copy of [_RenderCupertinoDialogActions] from [CupertinoAlertDialog]
// implementation since it's private there.
@internal
class RenderActions extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  RenderActions({
    List<RenderBox>? children,
    double? dialogWidth,
    double dividerThickness = 0.0,
    required Color dialogColor,
    required Color dialogPressedColor,
    required Color dividerColor,
    bool hasCancelButton = false,
    bool isActionSheet = false,
  })  : _dialogWidth = dialogWidth,
        _buttonBackgroundPaint = Paint()
          ..color = dialogColor
          ..style = PaintingStyle.fill,
        _pressedButtonBackgroundPaint = Paint()
          ..color = dialogPressedColor
          ..style = PaintingStyle.fill,
        _dividerPaint = Paint()
          ..color = dividerColor
          ..style = PaintingStyle.fill,
        _dividerThickness = dividerThickness,
        _hasCancelButton = hasCancelButton,
        _isActionSheet = isActionSheet {
    addAll(children);
  }

  double? get dialogWidth => _dialogWidth;
  double? _dialogWidth;
  set dialogWidth(double? newWidth) {
    if (newWidth != _dialogWidth) {
      _dialogWidth = newWidth;
      markNeedsLayout();
    }
  }

  // The thickness of the divider between buttons.
  double get dividerThickness => _dividerThickness;
  double _dividerThickness;
  set dividerThickness(double newValue) {
    if (newValue != _dividerThickness) {
      _dividerThickness = newValue;
      markNeedsLayout();
    }
  }

  bool _hasCancelButton;
  bool get hasCancelButton => _hasCancelButton;
  set hasCancelButton(bool newValue) {
    if (newValue == _hasCancelButton) {
      return;
    }

    _hasCancelButton = newValue;
    markNeedsLayout();
  }

  Color get dialogColor => _buttonBackgroundPaint.color;
  final Paint _buttonBackgroundPaint;
  set dialogColor(Color value) {
    if (value == _buttonBackgroundPaint.color) {
      return;
    }

    _buttonBackgroundPaint.color = value;
    markNeedsPaint();
  }

  Color get dialogPressedColor => _pressedButtonBackgroundPaint.color;
  final Paint _pressedButtonBackgroundPaint;
  set dialogPressedColor(Color value) {
    if (value == _pressedButtonBackgroundPaint.color) {
      return;
    }

    _pressedButtonBackgroundPaint.color = value;
    markNeedsPaint();
  }

  Color get dividerColor => _dividerPaint.color;
  final Paint _dividerPaint;
  set dividerColor(Color value) {
    if (value == _dividerPaint.color) {
      return;
    }

    _dividerPaint.color = value;
    markNeedsPaint();
  }

  bool get isActionSheet => _isActionSheet;
  bool _isActionSheet;
  set isActionSheet(bool value) {
    if (value == _isActionSheet) {
      return;
    }

    _isActionSheet = value;
    markNeedsPaint();
  }

  Iterable<RenderBox> get _pressedButtons {
    final boxes = <RenderBox>[];
    var currentChild = firstChild;
    while (currentChild != null) {
      final parentData = currentChild.parentData! as ActionButtonParentData;
      if (parentData.isPressed) {
        boxes.add(currentChild);
      }
      currentChild = childAfter(currentChild);
    }

    return boxes;
  }

  bool get _isButtonPressed {
    var currentChild = firstChild;
    while (currentChild != null) {
      final parentData = currentChild.parentData! as ActionButtonParentData;
      if (parentData.isPressed) {
        return true;
      }
      currentChild = childAfter(currentChild);
    }

    return false;
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ActionButtonParentData) {
      child.parentData = ActionButtonParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      isActionSheet ? constraints.minWidth : dialogWidth!;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      isActionSheet ? constraints.maxWidth : dialogWidth!;

  @override
  double computeMinIntrinsicHeight(double width) {
    if (childCount == 0) {
      return 0;
    } else if (isActionSheet) {
      if (childCount == 1) {
        return firstChild!.computeMaxIntrinsicHeight(width) + dividerThickness;
      }
      if (hasCancelButton && childCount < 4) {
        return _computeMinIntrinsicHeightWithCancel(width);
      }

      return _computeMinIntrinsicHeightStacked(width);
    } else if (childCount == 1) {
      // If only 1 button, display the button across the entire dialog.
      return _computeMinIntrinsicHeightSideBySide(width);
    } else if (childCount == 2 && _isSingleButtonRow(width)) {
      // The first 2 buttons fit side-by-side. Display them horizontally.
      return _computeMinIntrinsicHeightSideBySide(width);
    }

    // 3+ buttons are always stacked. The minimum height when stacked is
    // 1.5 buttons tall.
    return _computeMinIntrinsicHeightStacked(width);
  }

  // The minimum height for more than 2-3 buttons when a cancel button is
  // included is the full height of button stack.
  double _computeMinIntrinsicHeightWithCancel(double width) {
    final childAfterFirstChild = childAfter(firstChild!)!;
    if (childCount == 2) {
      return firstChild!.getMinIntrinsicHeight(width) +
          childAfterFirstChild.getMinIntrinsicHeight(width) +
          dividerThickness;
    }

    return firstChild!.getMinIntrinsicHeight(width) +
        childAfterFirstChild.getMinIntrinsicHeight(width) +
        childAfter(childAfterFirstChild)!.getMinIntrinsicHeight(width) +
        (dividerThickness * 2);
  }

  // The minimum height for a single row of buttons is the larger of the
  // buttons' min intrinsic heights.
  double _computeMinIntrinsicHeightSideBySide(double width) {
    final double minHeight;
    if (childCount == 1) {
      minHeight = firstChild!.getMinIntrinsicHeight(width);
    } else {
      final perButtonWidth = (width - dividerThickness) / 2.0;
      minHeight = math.max(
        firstChild!.getMinIntrinsicHeight(perButtonWidth),
        lastChild!.getMinIntrinsicHeight(perButtonWidth),
      );
    }

    return minHeight;
  }

  // Dialog: The minimum height for 2+ stacked buttons is the height of the 1st
  // button + 50% the height of the 2nd button + the divider between the two.
  //
  // ActionSheet: The minimum height for more than 2 buttons when no cancel
  // button or 4+ buttons when a cancel button is included is the height of the
  // 1st button + 50% the height of the 2nd button + 2 dividers.
  double _computeMinIntrinsicHeightStacked(double width) =>
      firstChild!.getMinIntrinsicHeight(width) +
      dividerThickness +
      (0.5 * childAfter(firstChild!)!.getMinIntrinsicHeight(width));

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (childCount == 0) {
      // No buttons. Zero height.
      return 0;
    } else if (isActionSheet) {
      if (childCount == 1) {
        return firstChild!.computeMaxIntrinsicHeight(width) + dividerThickness;
      }

      return _computeMaxIntrinsicHeightStacked(width);
    } else if (childCount == 1) {
      // One button. Our max intrinsic height is equal to the button's.
      return firstChild!.getMaxIntrinsicHeight(width);
    } else if (childCount == 2) {
      // Two buttons...
      if (_isSingleButtonRow(width)) {
        // The 2 buttons fit side by side so our max intrinsic height is equal
        // to the taller of the 2 buttons.
        final perButtonWidth = (width - dividerThickness) / 2.0;

        return math.max(
          firstChild!.getMaxIntrinsicHeight(perButtonWidth),
          lastChild!.getMaxIntrinsicHeight(perButtonWidth),
        );
      } else {
        // The 2 buttons do not fit side by side. Measure total height as a
        // vertical stack.
        return _computeMaxIntrinsicHeightStacked(width);
      }
    }

    // Three+ buttons. Stack the buttons vertically with dividers and measure
    // the overall height.
    return _computeMaxIntrinsicHeightStacked(width);
  }

  // Max height of a stack of buttons is the sum of all button heights + a
  // divider for each button.
  double _computeMaxIntrinsicHeightStacked(double width) {
    final allDividersHeight = (childCount - 1) * dividerThickness;
    var heightAccumulation = allDividersHeight;
    var button = firstChild;
    while (button != null) {
      heightAccumulation += button.getMaxIntrinsicHeight(width);
      button = childAfter(button);
    }

    return heightAccumulation;
  }

  bool _isSingleButtonRow(double width) {
    final bool isSingleButtonRow;
    if (childCount == 1) {
      isSingleButtonRow = true;
    } else if (childCount == 2) {
      // There are 2 buttons. If they can fit side-by-side then that's what
      // we want to do. Otherwise, stack them vertically.
      final sideBySideWidth =
          firstChild!.getMaxIntrinsicWidth(double.infinity) +
              dividerThickness +
              lastChild!.getMaxIntrinsicWidth(double.infinity);
      isSingleButtonRow = sideBySideWidth <= width;
    } else {
      isSingleButtonRow = false;
    }

    return isSingleButtonRow;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _performLayout(constraints: constraints, dry: true);

  @override
  void performLayout() {
    size = _performLayout(constraints: constraints);
  }

  Size _performLayout({
    required BoxConstraints constraints,
    bool dry = false,
  }) {
    final layoutChild =
        dry ? ChildLayoutHelper.dryLayoutChild : ChildLayoutHelper.layoutChild;

    return !isActionSheet && _isSingleButtonRow(dialogWidth!)
        ? _sizeForSingleButtonRowDialog(layoutChild, constraints, dry)
        : _sizeForVerticallyStackedItems(constraints, layoutChild, dry);
  }

  Size _sizeForVerticallyStackedItems(
    BoxConstraints constraints,
    Size Function(RenderBox child, BoxConstraints constraints) layoutChild,
    bool dry,
  ) {
    // We need to stack buttons vertically, plus dividers above each button
    // (except the 1st).
    final perButtonConstraints = constraints.copyWith(
      minHeight: 0,
      maxHeight: double.infinity,
    );

    var child = firstChild;
    var index = 0;
    var verticalOffset = 0.0;
    while (child != null) {
      final childSize = layoutChild(
        child,
        perButtonConstraints,
      );

      if (!dry) {
        (child.parentData! as MultiChildLayoutParentData).offset =
            Offset(0, verticalOffset);
      }
      verticalOffset += childSize.height;
      if (index < childCount - 1) {
        // Add a gap for the next divider.
        verticalOffset += dividerThickness;
      }

      index += 1;
      child = childAfter(child);
    }

    // Our height is the accumulated height of all buttons and dividers.
    return constraints.constrain(
      Size(computeMaxIntrinsicWidth(0), verticalOffset),
    );
  }

  Size _sizeForSingleButtonRowDialog(
    Size Function(RenderBox child, BoxConstraints constraints) layoutChild,
    BoxConstraints constraints,
    bool dry,
  ) {
    if (childCount == 1) {
      // We have 1 button. Our size is the width of the dialog and the height
      // of the single button.
      final childSize = layoutChild(
        firstChild!,
        constraints,
      );

      return constraints.constrain(
        Size(dialogWidth!, childSize.height),
      );
    } else {
      // Each button gets half the available width, minus a single divider.
      final perButtonConstraints = BoxConstraints(
        minWidth: (constraints.minWidth - dividerThickness) / 2.0,
        maxWidth: (constraints.maxWidth - dividerThickness) / 2.0,
      );

      // Layout the 2 buttons.
      final firstChildSize = layoutChild(
        firstChild!,
        perButtonConstraints,
      );
      final lastChildSize = layoutChild(
        lastChild!,
        perButtonConstraints,
      );

      if (!dry) {
        // The 2nd button needs to be offset to the right.
        (lastChild!.parentData! as MultiChildLayoutParentData).offset =
            Offset(firstChildSize.width + dividerThickness, 0);
      }

      // Calculate our size based on the button sizes.
      return constraints.constrain(
        Size(
          dialogWidth!,
          math.max(
            firstChildSize.height,
            lastChildSize.height,
          ),
        ),
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    if (!isActionSheet && _isSingleButtonRow(size.width)) {
      _drawButtonBackgroundsAndDividersSingleRow(canvas, offset);
    } else {
      _drawButtonBackgroundsAndDividersStacked(canvas, offset);
    }

    _drawButtons(context, offset);
  }

  void _drawButtonBackgroundsAndDividersSingleRow(
    Canvas canvas,
    Offset offset,
  ) {
    // The vertical divider sits between the left button and right button (if
    // the dialog has 2 buttons).  The vertical divider is hidden if either the
    // left or right button is pressed.
    final firstChildSize = firstChild!.size;
    final verticalDivider = childCount == 2 && !_isButtonPressed
        ? Rect.fromLTWH(
            offset.dx + firstChildSize.width,
            offset.dy,
            dividerThickness,
            math.max(
              firstChildSize.height,
              lastChild!.size.height,
            ),
          )
        : Rect.zero;

    final pressedButtonRects =
        _pressedButtons.map<Rect>((RenderBox pressedButton) {
      final buttonParentData =
          pressedButton.parentData! as MultiChildLayoutParentData;

      return Rect.fromLTWH(
        offset.dx + buttonParentData.offset.dx,
        offset.dy + buttonParentData.offset.dy,
        pressedButton.size.width,
        pressedButton.size.height,
      );
    }).toList();

    // Create the button backgrounds path and paint it.
    final backgroundFillPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(verticalDivider);

    for (var i = 0; i < pressedButtonRects.length; i += 1) {
      backgroundFillPath.addRect(pressedButtonRects[i]);
    }

    canvas.drawPath(
      backgroundFillPath,
      _buttonBackgroundPaint,
    );

    // Create the pressed buttons background path and paint it.
    final pressedBackgroundFillPath = Path();
    for (var i = 0; i < pressedButtonRects.length; i += 1) {
      pressedBackgroundFillPath.addRect(pressedButtonRects[i]);
    }

    canvas.drawPath(
      pressedBackgroundFillPath,
      _pressedButtonBackgroundPaint,
    );

    // Create the dividers path and paint it.
    final dividersPath = Path()..addRect(verticalDivider);

    canvas.drawPath(
      dividersPath,
      _dividerPaint,
    );
  }

  // ignore: long-method
  void _drawButtonBackgroundsAndDividersStacked(Canvas canvas, Offset offset) {
    final dividerOffset = Offset(0, dividerThickness);

    final backgroundFillPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final pressedBackgroundFillPath = Path();

    final dividersPath = Path();

    var accumulatingOffset = offset;

    var child = firstChild;
    RenderBox? prevChild;
    while (child != null) {
      final currentButtonParentData =
          child.parentData! as ActionButtonParentData;
      final isButtonPressed = currentButtonParentData.isPressed;

      var isPrevButtonPressed = false;
      if (prevChild != null) {
        final previousButtonParentData =
            prevChild.parentData! as ActionButtonParentData;
        isPrevButtonPressed = previousButtonParentData.isPressed;
      }

      final isDividerPresent = child != firstChild;
      final isDividerPainted =
          isDividerPresent && !(isButtonPressed || isPrevButtonPressed);
      final dividerRect = Rect.fromLTWH(
        accumulatingOffset.dx,
        accumulatingOffset.dy,
        size.width,
        dividerThickness,
      );

      final childHeight = child.size.height;

      final buttonBackgroundRect = Rect.fromLTWH(
        accumulatingOffset.dx,
        accumulatingOffset.dy + (isDividerPresent ? dividerThickness : 0.0),
        size.width,
        childHeight,
      );

      if (isButtonPressed) {
        backgroundFillPath.addRect(buttonBackgroundRect);
        pressedBackgroundFillPath.addRect(buttonBackgroundRect);
      }

      if (isDividerPainted) {
        backgroundFillPath.addRect(dividerRect);
        dividersPath.addRect(dividerRect);
      }

      accumulatingOffset += (isDividerPresent ? dividerOffset : Offset.zero) +
          Offset(0, childHeight);

      prevChild = child;
      child = childAfter(child);
    }

    canvas
      ..drawPath(backgroundFillPath, _buttonBackgroundPaint)
      ..drawPath(pressedBackgroundFillPath, _pressedButtonBackgroundPaint)
      ..drawPath(dividersPath, _dividerPaint);
  }

  void _drawButtons(PaintingContext context, Offset offset) {
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as MultiChildLayoutParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childAfter(child);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
