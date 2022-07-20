import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../cupertino_dialog_extended.dart';
import '../theme/default_theme.dart';
import 'utils/constants.dart';

@immutable
class CupertinoActionSheetActionExtended extends StatelessWidget {
  const CupertinoActionSheetActionExtended({
    super.key,
    required this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    required this.child,
  });

  final VoidCallback onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoActionSheetTheme.of(context);

    final defaults =
        CupertinoDialogExtendedThemeDefaults(context).actionSheetTheme;

    var style = CupertinoActionSheetTheme.getProperty<TextStyle>(
      widgetTheme: null,
      theme: theme,
      defaults: defaults,
      getThemeProperty: (theme) => theme?.actionStyle,
    );

    if (isDestructiveAction) {
      final color = CupertinoActionSheetTheme.getProperty<Color>(
        widgetTheme: null,
        theme: theme,
        defaults: defaults,
        getThemeProperty: (theme) => theme?.destructiveColor,
      );

      style = style.copyWith(color: color);
    }

    if (isDefaultAction) {
      style = style.copyWith(fontWeight: FontWeight.w600);
    }

    return MouseRegion(
      cursor: kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: kActionSheetButtonHeight,
          ),
          child: Semantics(
            button: true,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 10,
              ),
              child: DefaultTextStyle(
                style: style,
                textAlign: TextAlign.center,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
