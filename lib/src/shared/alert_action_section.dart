// The "actions section" of a [CupertinoAlertDialog].
//
// See [_RenderCupertinoDialogActions] for details about action button sizing
// and layout.
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'actions_render_widget.dart';
import 'parent_data.dart';

@internal
@immutable
class CupertinoAlertActionSection extends StatelessWidget {
  const CupertinoAlertActionSection({
    super.key,
    required this.children,
    this.scrollController,
    this.hasCancelButton = false,
    this.isActionSheet = false,
    required this.dividerColor,
    required this.dialogColor,
  });

  final List<Widget> children;
  final ScrollController? scrollController;
  final bool hasCancelButton;
  final bool isActionSheet;
  final Color dividerColor;
  final Color dialogColor;

  @override
  Widget build(BuildContext context) {
    final interactiveButtons = <Widget>[];
    for (var i = 0; i < children.length; i += 1) {
      interactiveButtons.add(
        _PressableActionButton(
          child: children[i],
        ),
      );
    }

    return CupertinoScrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: ActionsRenderWidget(
          hasCancelButton: hasCancelButton,
          isActionSheet: isActionSheet,
          dividerColor: dividerColor,
          dialogColor: dialogColor,
          children: interactiveButtons,
        ),
      ),
    );
  }
}

// Button that updates its render state when pressed.
//
// The pressed state is forwarded to an _ActionButtonParentDataWidget. The
// corresponding _ActionButtonParentData is then interpreted and rendered
// appropriately by _RenderCupertinoDialogActions.
@immutable
class _PressableActionButton extends StatefulWidget {
  const _PressableActionButton({required this.child});

  final Widget child;

  @override
  _PressableActionButtonState createState() => _PressableActionButtonState();
}

class _PressableActionButtonState extends State<_PressableActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) => ActionButtonParentDataWidget(
        isPressed: _isPressed,
        child: MergeSemantics(
          // TODO(mattcarroll): Button press dynamics need overhaul for iOS:
          // https://github.com/flutter/flutter/issues/19786
          child: GestureDetector(
            excludeFromSemantics: true,
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => setState(() => _isPressed = true),
            onTapUp: (details) => setState(() => _isPressed = false),
            // TODO(mattcarroll): Cancel is currently triggered when user moves
            //  past slop instead of off button: https://github.com/flutter/flutter/issues/19783
            onTapCancel: () => setState(() => _isPressed = false),
            child: widget.child,
          ),
        ),
      );
}
