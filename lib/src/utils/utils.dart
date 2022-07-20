// Accessibility mode on iOS is determined by the text scale factor that the
// user has selected.
import 'package:flutter/cupertino.dart';

// The alert dialog layout policy changes depending on whether the user is using
// a "regular" font size vs a "large" font size. This is a spectrum. There are
// many "regular" font sizes and many "large" font sizes. But depending on which
// policy is currently being used, a dialog is laid out differently.
//
// Empirically, the jump from one policy to the other occurs at the following
// text scale factors:
// Largest regular scale factor:  1.3529411764705883
// Smallest large scale factor:   1.6470588235294117
//
// The following constant represents a division in text scale factor beyond
// which we want to change how the dialog is laid out.
const double _kMaxRegularTextScaleFactor = 1.4;

bool isInAccessibilityMode(BuildContext context) {
  final data = MediaQuery.maybeOf(context);

  return data != null && data.textScaleFactor > _kMaxRegularTextScaleFactor;
}

// Create `dialogPressedColor` by changing color properties for specific
// percent.
//
// Eyeballed percent for `Brightness.light` is 7% and 15% for `Brightness.dark`.
//
// For `Brightness.dark` we lighten color, for `Brightness.light` we darken
// color;
//
Color lightenDialogPressedColor(Color color) => Color.fromARGB(
      color.alpha,
      color.red + ((255 - color.red) * 0.15).round(),
      color.green + ((255 - color.green) * 0.15).round(),
      color.blue + ((255 - color.blue) * 0.15).round(),
    );

Color darkenDialogPressedColor(Color color) => Color.fromARGB(
      color.alpha,
      (color.red * 0.93).round(),
      (color.green * 0.93).round(),
      (color.blue * 0.93).round(),
    );
