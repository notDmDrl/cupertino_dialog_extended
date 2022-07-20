// The "content section" of a CupertinoAlertDialog.
//
// If title is missing, then only content is added.  If content is
// missing, then only title is added. If both are missing, then it returns
// a SingleChildScrollView with a zero-sized Container.
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@internal
@immutable
class CupertinoAlertContentSection extends StatelessWidget {
  const CupertinoAlertContentSection({
    super.key,
    this.title,
    this.message,
    required this.scrollController,
    required this.titlePadding,
    required this.messagePadding,
    required this.titleTextStyle,
    required this.messageTextStyle,
    this.additionalPaddingBetweenTitleAndMessage,
  });

  final Widget? title;
  final Widget? message;
  final ScrollController scrollController;
  final EdgeInsets titlePadding;
  final EdgeInsets messagePadding;
  final EdgeInsets? additionalPaddingBetweenTitleAndMessage;
  final TextStyle titleTextStyle;
  final TextStyle messageTextStyle;

  @override
  Widget build(BuildContext context) {
    if (title == null && message == null) {
      return const SizedBox.shrink();
    }

    final titleContentGroup = [
      if (title != null)
        Padding(
          padding: titlePadding,
          child: DefaultTextStyle(
            style: titleTextStyle,
            textAlign: TextAlign.center,
            child: title!,
          ),
        ),
      if (message != null)
        Padding(
          padding: messagePadding,
          child: DefaultTextStyle(
            style: messageTextStyle,
            textAlign: TextAlign.center,
            child: message!,
          ),
        ),
    ];

    // Add padding between the widgets if necessary.
    if (additionalPaddingBetweenTitleAndMessage != null &&
        titleContentGroup.length > 1) {
      titleContentGroup.insert(
        1,
        Padding(padding: additionalPaddingBetweenTitleAndMessage!),
      );
    }

    return CupertinoScrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: titleContentGroup,
        ),
      ),
    );
  }
}
