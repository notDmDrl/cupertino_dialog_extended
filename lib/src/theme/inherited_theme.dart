import 'package:flutter/cupertino.dart';

import 'theme.dart';

/// Alternative way of defining [CupertinoDialogExtendedTheme].
///
/// Example:
///
/// ```dart
/// CupertinoApp(
///    builder: (context, child) => CupertinoDialogExtendedInheritedTheme(
///      data: const CupertinoDialogExtendedTheme(
///        ...
///      ),
///      child: child!,
///  ),
/// home: ...,
/// ```
@immutable
class CupertinoDialogExtendedInheritedTheme extends InheritedTheme {
  /// Creates a [CupertinoDialogExtendedInheritedTheme].
  const CupertinoDialogExtendedInheritedTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final CupertinoDialogExtendedTheme data;

  /// The closest nullable instance of this class that encloses the given
  /// context.
  static CupertinoDialogExtendedTheme? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<
          CupertinoDialogExtendedInheritedTheme>()
      ?.data;

  @override
  bool updateShouldNotify(
    covariant CupertinoDialogExtendedInheritedTheme oldWidget,
  ) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      CupertinoDialogExtendedInheritedTheme(
        data: data,
        child: child,
      );
}
