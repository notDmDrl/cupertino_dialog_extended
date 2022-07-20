import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

// Dialog specific constants.
// iOS dialogs have a normal display width and another display width that is
// used when the device is in accessibility mode. Each of these widths are
// listed below.
@internal
const double kCupertinoDialogWidth = 270;

@internal
const double kAccessibilityCupertinoDialogWidth = 310;

@internal
const double kDialogEdgePadding = 20;

@internal
const double kDialogMinButtonHeight = kMinInteractiveDimensionCupertino;

@internal
const double kDialogMinButtonFontSize = 10;

@internal
const BorderRadius kCornerRadius = BorderRadius.all(Radius.circular(14));
