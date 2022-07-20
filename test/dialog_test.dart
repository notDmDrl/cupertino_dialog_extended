// Copy of cupertino dialog tests so we can be sure it's working as intended.

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore_for_file: long-method, avoid-returning-widgets
void main() {
  testWidgets('Alert dialog control test', (WidgetTester tester) async {
    var didDelete = false;

    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('The title'),
          content: const Text('The content'),
          actions: <Widget>[
            const CupertinoDialogAction(
              child: Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                didDelete = true;
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pump();

    expect(didDelete, isFalse);

    await tester.tap(find.text('Delete'));
    await tester.pump();

    expect(didDelete, isTrue);
    expect(find.text('Delete'), findsNothing);
  });

  testWidgets('Dialog not barrier dismissible by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(createAppWithCenteredButton(const Text('Go')));

    final BuildContext context = tester.element(find.text('Go'));

    unawaited(
      showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          child: const Text('Dialog'),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Dialog'), findsOneWidget);

    // Tap on the barrier, which shouldn't do anything this time.
    await tester.tapAt(const Offset(10, 10));

    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Dialog'), findsOneWidget);
  });

  testWidgets('Dialog configurable to be barrier dismissible',
      (WidgetTester tester) async {
    await tester.pumpWidget(createAppWithCenteredButton(const Text('Go')));

    final BuildContext context = tester.element(find.text('Go'));

    unawaited(
      showCupertinoDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          child: const Text('Dialog'),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Dialog'), findsOneWidget);

    // Tap off the barrier.
    await tester.tapAt(const Offset(10, 10));

    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Dialog'), findsNothing);
  });

  testWidgets('Dialog destructive action style', (WidgetTester tester) async {
    await tester.pumpWidget(
      boilerplate(
        const CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text('Ok'),
        ),
      ),
    );

    final widget =
        tester.widget(find.byType(DefaultTextStyle)) as DefaultTextStyle;

    expect(widget.style.color!.withAlpha(255), CupertinoColors.systemRed.color);
  });

  testWidgets('Dialog default action style', (WidgetTester tester) async {
    await tester.pumpWidget(
      boilerplate(
        const CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
        ),
      ),
    );

    final widget =
        tester.widget(find.byType(DefaultTextStyle)) as DefaultTextStyle;

    expect(widget.style.fontWeight, equals(FontWeight.w600));
  });

  testWidgets('Dialog default and destructive action styles',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      boilerplate(
        const CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: true,
          child: Text('Ok'),
        ),
      ),
    );

    final widget =
        tester.widget(find.byType(DefaultTextStyle)) as DefaultTextStyle;

    expect(widget.style.color!.withAlpha(255), CupertinoColors.systemRed.color);
    expect(widget.style.fontWeight, equals(FontWeight.w600));
  });

  testWidgets('Dialog disabled action style', (WidgetTester tester) async {
    await tester.pumpWidget(
      boilerplate(
        const CupertinoDialogAction(
          child: Text('Ok'),
        ),
      ),
    );

    final widget =
        tester.widget(find.byType(DefaultTextStyle)) as DefaultTextStyle;

    expect(widget.style.color!.opacity, greaterThanOrEqualTo(127 / 255));
    expect(widget.style.color!.opacity, lessThanOrEqualTo(128 / 255));
  });

  testWidgets('Dialog enabled action style', (WidgetTester tester) async {
    await tester.pumpWidget(
      boilerplate(
        CupertinoDialogAction(
          child: const Text('Ok'),
          onPressed: () {},
        ),
      ),
    );

    final widget =
        tester.widget(find.byType(DefaultTextStyle)) as DefaultTextStyle;

    expect(widget.style.color!.opacity, equals(1.0));
  });

  testWidgets(
      'Message is scrollable, has correct padding with large text sizes',
      (WidgetTester tester) async {
    final scrollController = ScrollController();
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 3),
          child: CupertinoAlertDialog(
            title: const Text('The Title'),
            content: Text('Very long content ' * 20),
            actions: const <Widget>[
              CupertinoDialogAction(
                child: Text('Cancel'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('OK'),
              ),
            ],
            scrollController: scrollController,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    expect(scrollController.offset, 0.0);
    scrollController.jumpTo(100);
    expect(scrollController.offset, 100.0);
    // Set the scroll position back to zero.
    scrollController.jumpTo(0);

    await tester.pumpAndSettle();

    // Expect the modal dialog box to take all available height.
    expect(
      tester.getSize(find.byType(ClipRRect)),
      equals(const Size(310, 560.0 - 24.0 * 2)),
    );

    // Check sizes/locations of the text. The text is large so these 2 buttons are stacked.
    // Visually the "Cancel" button and "OK" button are the same height when using the
    // regular font. However, when using the test font, "Cancel" becomes 2 lines which
    // is why the height we're verifying for "Cancel" is larger than "OK".

    // TODO(yjbanov): https://github.com/flutter/flutter/issues/99933
    //                A bug in the HTML renderer and/or Chrome 96+ causes a
    //                discrepancy in the paragraph height.
    const hasIssue99933 =
        kIsWeb && !bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');
    expect(
      tester.getSize(find.text('The Title')),
      equals(const Size(270, hasIssue99933 ? 133 : 132.0)),
    );
    expect(
      tester.getTopLeft(find.text('The Title')),
      equals(const Offset(265, 80.0 + 24.0)),
    );
    expect(
      tester.getSize(find.widgetWithText(CupertinoDialogAction, 'Cancel')),
      equals(const Size(310, 148)),
    );
    expect(
      tester.getSize(find.widgetWithText(CupertinoDialogAction, 'OK')),
      equals(const Size(310, 98)),
    );
  });

  testWidgets('Dialog respects small constraints.',
      (WidgetTester tester) async {
    final scrollController = ScrollController();
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => Center(
          child: ConstrainedBox(
            // Constrain the dialog to a tiny size and ensure it respects
            // these exact constraints.
            constraints: BoxConstraints.tight(const Size(200, 100)),
            child: CupertinoAlertDialog(
              title: const Text('The Title'),
              content: const Text('The message'),
              actions: const <Widget>[
                CupertinoDialogAction(
                  child: Text('Option 1'),
                ),
                CupertinoDialogAction(
                  child: Text('Option 2'),
                ),
                CupertinoDialogAction(
                  child: Text('Option 3'),
                ),
              ],
              scrollController: scrollController,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pump();

    const topAndBottomMargin = 40.0;
    const topAndBottomPadding = 24.0 * 2;
    const leftAndRightPadding = 40.0 * 2;
    final modalFinder = find.byType(ClipRRect);
    expect(
      tester.getSize(modalFinder),
      equals(
        const Size(
          200.0 - leftAndRightPadding,
          100.0 - topAndBottomMargin - topAndBottomPadding,
        ),
      ),
    );
  });

  testWidgets(
      'Button list is scrollable, has correct position with large text sizes.',
      (WidgetTester tester) async {
    final actionScrollController = ScrollController();
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 3),
          child: CupertinoAlertDialog(
            title: const Text('The title'),
            content: const Text('The content.'),
            actions: const <Widget>[
              CupertinoDialogAction(
                child: Text('One'),
              ),
              CupertinoDialogAction(
                child: Text('Two'),
              ),
              CupertinoDialogAction(
                child: Text('Three'),
              ),
              CupertinoDialogAction(
                child: Text('Chocolate Brownies'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Cancel'),
              ),
            ],
            actionScrollController: actionScrollController,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));

    await tester.pump();

    // Check that the action buttons list is scrollable.
    expect(actionScrollController.offset, 0.0);
    actionScrollController.jumpTo(100);
    expect(actionScrollController.offset, 100.0);
    actionScrollController.jumpTo(0);

    // Check that the action buttons are aligned vertically.
    expect(
      tester.getCenter(find.widgetWithText(CupertinoDialogAction, 'One')).dx,
      equals(400.0),
    );
    expect(
      tester.getCenter(find.widgetWithText(CupertinoDialogAction, 'Two')).dx,
      equals(400.0),
    );
    expect(
      tester.getCenter(find.widgetWithText(CupertinoDialogAction, 'Three')).dx,
      equals(400.0),
    );
    expect(
      tester
          .getCenter(
            find.widgetWithText(
              CupertinoDialogAction,
              'Chocolate Brownies',
            ),
          )
          .dx,
      equals(400.0),
    );
    expect(
      tester.getCenter(find.widgetWithText(CupertinoDialogAction, 'Cancel')).dx,
      equals(400.0),
    );

    // Check that the action buttons are the correct heights.
    expect(
      tester.getSize(find.widgetWithText(CupertinoDialogAction, 'One')).height,
      equals(98.0),
    );
    expect(
      tester.getSize(find.widgetWithText(CupertinoDialogAction, 'Two')).height,
      equals(98.0),
    );
    expect(
      tester
          .getSize(find.widgetWithText(CupertinoDialogAction, 'Three'))
          .height,
      equals(98.0),
    );
    expect(
      tester
          .getSize(
            find.widgetWithText(
              CupertinoDialogAction,
              'Chocolate Brownies',
            ),
          )
          .height,
      equals(248.0),
    );
    expect(
      tester
          .getSize(find.widgetWithText(CupertinoDialogAction, 'Cancel'))
          .height,
      equals(148.0),
    );
  });

  testWidgets('Title Section is empty, Button section is not empty.',
      (WidgetTester tester) async {
    const textScaleFactor = 1.0;
    final actionScrollController = ScrollController();
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
          child: CupertinoAlertDialog(
            actions: const <Widget>[
              CupertinoDialogAction(
                child: Text('One'),
              ),
              CupertinoDialogAction(
                child: Text('Two'),
              ),
            ],
            actionScrollController: actionScrollController,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));

    await tester.pump();

    // Check that the dialog size is the same as the actions section size. This
    // ensures that an empty content section doesn't accidentally render some
    // empty space in the dialog.
    final contentSectionFinder = find.byElementPredicate(
      (Element element) =>
          element.widget.runtimeType.toString() ==
          '_CupertinoAlertActionSection',
    );

    final modalBoundaryFinder = find.byType(ClipRRect);

    expect(
      tester.getSize(contentSectionFinder),
      tester.getSize(modalBoundaryFinder),
    );

    // Check that the title/message section is not displayed
    expect(actionScrollController.offset, 0.0);
    expect(
      tester.getTopLeft(find.widgetWithText(CupertinoDialogAction, 'One')).dy,
      equals(277.5),
    );

    // Check that the button's vertical size is the same.
    expect(
      tester.getSize(find.widgetWithText(CupertinoDialogAction, 'One')).height,
      equals(
        tester
            .getSize(find.widgetWithText(CupertinoDialogAction, 'Two'))
            .height,
      ),
    );
  });

  testWidgets('Button section is empty, Title section is not empty.',
      (WidgetTester tester) async {
    const textScaleFactor = 1.0;
    final scrollController = ScrollController();
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
          child: CupertinoAlertDialog(
            title: const Text('The title'),
            content: const Text('The content.'),
            scrollController: scrollController,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));

    await tester.pump();

    // Check that there's no button action section.
    expect(scrollController.offset, 0.0);
    expect(find.widgetWithText(CupertinoDialogAction, 'One'), findsNothing);

    // Check that the dialog size is the same as the content section size. This
    // ensures that an empty button section doesn't accidentally render some
    // empty space in the dialog.
    final contentSectionFinder = find.byElementPredicate(
      (Element element) =>
          element.widget.runtimeType.toString() ==
          '_CupertinoAlertContentSection',
    );

    final modalBoundaryFinder = find.byType(ClipRRect);

    expect(
      tester.getSize(contentSectionFinder),
      tester.getSize(modalBoundaryFinder),
    );
  });

  testWidgets('Actions section height for 1 button is height of button.',
      (WidgetTester tester) async {
    final scrollController = ScrollController();
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('The Title'),
          content: const Text('The message'),
          actions: const <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
            ),
          ],
          scrollController: scrollController,
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pump();

    final okButtonBox = findActionButtonRenderBoxByTitle(tester, 'OK');
    final actionsSectionBox = findScrollableActionsSectionRenderBox(tester);

    expect(okButtonBox.size.width, actionsSectionBox.size.width);
    expect(okButtonBox.size.height, actionsSectionBox.size.height);
  });

  testWidgets(
      'Actions section height for 2 side-by-side buttons is height of tallest button.',
      (WidgetTester tester) async {
    final scrollController = ScrollController();
    late double
        dividerWidth; // Will be set when the dialog builder runs. Needs a BuildContext.
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) {
          dividerWidth = 1.0 / MediaQuery.of(context).devicePixelRatio;

          return CupertinoAlertDialog(
            title: const Text('The Title'),
            content: const Text('The message'),
            actions: const <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Cancel'),
              ),
            ],
            scrollController: scrollController,
          );
        },
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pump();

    final okButtonBox = findActionButtonRenderBoxByTitle(tester, 'OK');
    final cancelButtonBox = findActionButtonRenderBoxByTitle(tester, 'Cancel');
    final actionsSectionBox = findScrollableActionsSectionRenderBox(tester);

    expect(okButtonBox.size.width, cancelButtonBox.size.width);

    expect(
      actionsSectionBox.size.width,
      okButtonBox.size.width + cancelButtonBox.size.width + dividerWidth,
    );

    expect(
      actionsSectionBox.size.height,
      max(okButtonBox.size.height, cancelButtonBox.size.height),
    );
  });

  testWidgets(
      'Actions section height for 2 stacked buttons with enough room is height of both buttons.',
      (WidgetTester tester) async {
    final scrollController = ScrollController();
    late double
        dividerThickness; // Will be set when the dialog builder runs. Needs a BuildContext.
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) {
          dividerThickness = 1.0 / MediaQuery.of(context).devicePixelRatio;

          return CupertinoAlertDialog(
            title: const Text('The Title'),
            content: const Text('The message'),
            actions: const <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('This is too long to fit'),
              ),
            ],
            scrollController: scrollController,
          );
        },
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pump();

    final okButtonBox = findActionButtonRenderBoxByTitle(tester, 'OK');
    final longButtonBox =
        findActionButtonRenderBoxByTitle(tester, 'This is too long to fit');
    final actionsSectionBox = findScrollableActionsSectionRenderBox(tester);

    expect(okButtonBox.size.width, longButtonBox.size.width);

    expect(okButtonBox.size.width, actionsSectionBox.size.width);

    expect(
      okButtonBox.size.height + dividerThickness + longButtonBox.size.height,
      actionsSectionBox.size.height,
    );
  });

  testWidgets(
      'Actions section height for 2 stacked buttons without enough room and regular font is 1.5 buttons tall.',
      (WidgetTester tester) async {
    final scrollController = ScrollController();
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('The Title'),
          content: Text('The message\n' * 40),
          actions: const <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('This is too long to fit'),
            ),
          ],
          scrollController: scrollController,
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    final actionsSectionBox = findScrollableActionsSectionRenderBox(tester);

    expect(
      actionsSectionBox.size.height,
      67.83333333333337,
    );
  });

  testWidgets(
      'Actions section height for 2 stacked buttons without enough room and large accessibility font is 50% of dialog height.',
      (WidgetTester tester) async {
    final scrollController = ScrollController();
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 3),
          child: CupertinoAlertDialog(
            title: const Text('The Title'),
            content: Text('The message\n' * 20),
            actions: const <Widget>[
              CupertinoDialogAction(
                child: Text('This button is multi line'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('This button is multi line'),
              ),
            ],
            scrollController: scrollController,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    final actionsSectionBox = findScrollableActionsSectionRenderBox(tester);

    // The two multiline buttons with large text are taller than 50% of the
    // dialog height, but with the accessibility layout policy, the 2 buttons
    // should be in a scrollable area equal to half the dialog height.
    expect(
      actionsSectionBox.size.height,
      280.0 - 24.0,
    );
  });

  testWidgets(
      'Actions section height for 3 buttons without enough room is 1.5 buttons tall.',
      (WidgetTester tester) async {
    final scrollController = ScrollController();
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('The Title'),
          content: Text('The message\n' * 40),
          actions: const <Widget>[
            CupertinoDialogAction(
              child: Text('Option 1'),
            ),
            CupertinoDialogAction(
              child: Text('Option 2'),
            ),
            CupertinoDialogAction(
              child: Text('Option 3'),
            ),
          ],
          scrollController: scrollController,
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pump();
    await tester.pumpAndSettle();

    final option1ButtonBox =
        findActionButtonRenderBoxByTitle(tester, 'Option 1');
    final option2ButtonBox =
        findActionButtonRenderBoxByTitle(tester, 'Option 2');
    final actionsSectionBox = findScrollableActionsSectionRenderBox(tester);

    expect(option1ButtonBox.size.width, option2ButtonBox.size.width);
    expect(option1ButtonBox.size.width, actionsSectionBox.size.width);

    // Expected Height = button 1 + divider + 1/2 button 2 = 67.83333333333334.
    const expectedHeight = 67.83333333333334;
    expect(
      actionsSectionBox.size.height,
      moreOrLessEquals(expectedHeight),
    );
  });

  testWidgets('ScaleTransition animation for showCupertinoDialog()',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: Builder(
            builder: (BuildContext context) => CupertinoButton(
              onPressed: () {
                showCupertinoDialog<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('The title'),
                    content: const Text('The content'),
                    actions: <Widget>[
                      const CupertinoDialogAction(
                        child: Text('Cancel'),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Go'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));

    // Enter animation.
    await tester.pump();
    var transform = tester.widget(find.byType(Transform)) as Transform;
    expect(transform.transform[0], moreOrLessEquals(1.3, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transform = tester.widget(find.byType(Transform));
    expect(transform.transform[0], moreOrLessEquals(1.145, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transform = tester.widget(find.byType(Transform));
    expect(transform.transform[0], moreOrLessEquals(1.044, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transform = tester.widget(find.byType(Transform));
    expect(transform.transform[0], moreOrLessEquals(1.013, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transform = tester.widget(find.byType(Transform));
    expect(transform.transform[0], moreOrLessEquals(1.003, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transform = tester.widget(find.byType(Transform));
    expect(transform.transform[0], moreOrLessEquals(1, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transform = tester.widget(find.byType(Transform));
    expect(transform.transform[0], moreOrLessEquals(1, epsilon: 0.001));

    await tester.tap(find.text('Delete'));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // No scaling on exit animation.
    expect(find.byType(Transform), findsNothing);
  });

  testWidgets('FadeTransition animation for showCupertinoDialog()',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: Center(
          child: Builder(
            builder: (BuildContext context) => CupertinoButton(
              onPressed: () {
                showCupertinoDialog<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('The title'),
                    content: const Text('The content'),
                    actions: <Widget>[
                      const CupertinoDialogAction(
                        child: Text('Cancel'),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Go'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));

    // Enter animation.
    await tester.pump();
    final fadeTransitionFinder = find.ancestor(
      of: find.byType(CupertinoAlertDialog),
      matching: find.byType(FadeTransition),
    );
    var transition = tester.firstWidget(fadeTransitionFinder) as FadeTransition;

    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(0.081, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(0.332, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(0.667, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(0.918, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(1, epsilon: 0.001));

    await tester.tap(find.text('Delete'));

    // Exit animation, look at reverse FadeTransition.
    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(1, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(0.918, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(0.667, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(0.332, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(0.081, epsilon: 0.001));

    await tester.pump(const Duration(milliseconds: 50));
    transition = tester.firstWidget(fadeTransitionFinder);
    expect(transition.opacity.value, moreOrLessEquals(0, epsilon: 0.001));
  });

  testWidgets('Actions are accessible by key', (WidgetTester tester) async {
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => const CupertinoAlertDialog(
          title: Text('The Title'),
          content: Text('The message'),
          actions: <Widget>[
            CupertinoDialogAction(
              key: Key('option_1'),
              child: Text('Option 1'),
            ),
            CupertinoDialogAction(
              key: Key('option_2'),
              child: Text('Option 2'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pump();

    expect(find.byKey(const Key('option_1')), findsOneWidget);
    expect(find.byKey(const Key('option_2')), findsOneWidget);
    expect(find.byKey(const Key('option_3')), findsNothing);
  });

  testWidgets('Dialog widget insets by MediaQuery viewInsets',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(),
          child:
              CupertinoAlertDialog(content: Placeholder(fallbackHeight: 200)),
        ),
      ),
    );

    final placeholderRectWithoutInsets =
        tester.getRect(find.byType(Placeholder));

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(viewInsets: EdgeInsets.fromLTRB(40, 30, 20, 10)),
          child:
              CupertinoAlertDialog(content: Placeholder(fallbackHeight: 200)),
        ),
      ),
    );

    // no change yet because padding is animated
    expect(
      tester.getRect(find.byType(Placeholder)),
      placeholderRectWithoutInsets,
    );

    await tester.pump(const Duration(seconds: 1));

    // once animation settles the dialog is padded by the new viewInsets
    expect(
      tester.getRect(find.byType(Placeholder)),
      placeholderRectWithoutInsets.translate(10, 10),
    );
  });

  testWidgets(
    'CupertinoDialogRoute is state restorable',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const CupertinoApp(
          restorationScopeId: 'app',
          home: _RestorableDialogTestWidget(),
        ),
      );

      expect(find.byType(CupertinoAlertDialog), findsNothing);

      await tester.tap(find.text('X'));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      final restorationData = await tester.getRestorationData();

      await tester.restartAndRestore();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Tap on the barrier.
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsNothing);

      await tester.restoreFrom(restorationData);
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    },
    skip: isBrowser,
  ); // https://github.com/flutter/flutter/issues/33615

  testWidgets(
    'Conflicting scrollbars are not applied by ScrollBehavior to CupertinoAlertDialog',
    (WidgetTester tester) async {
      // Regression test for https://github.com/flutter/flutter/issues/83819
      const textScaleFactor = 1.0;
      final actionScrollController = ScrollController();
      await tester.pumpWidget(
        createAppWithButtonThatLaunchesDialog(
          dialogBuilder: (BuildContext context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: textScaleFactor),
            child: CupertinoAlertDialog(
              title: const Text('Test Title'),
              content: const Text('Test Content'),
              actions: const <Widget>[
                CupertinoDialogAction(
                  child: Text('One'),
                ),
                CupertinoDialogAction(
                  child: Text('Two'),
                ),
              ],
              actionScrollController: actionScrollController,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pump();

      // The inherited ScrollBehavior should not apply Scrollbars since they are
      // already built in to the widget.
      expect(find.byType(Scrollbar), findsNothing);
      expect(find.byType(RawScrollbar), findsNothing);
      // Built in CupertinoScrollbars should only number 2: one for the actions,
      // one for the content.
      expect(find.byType(CupertinoScrollbar), findsNWidgets(2));
    },
    variant: TargetPlatformVariant.all(),
  );

  testWidgets('CupertinoAlertDialog scrollbars controllers should be different',
      (WidgetTester tester) async {
    // https://github.com/flutter/flutter/pull/81278
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(),
          child: CupertinoAlertDialog(
            actions: <Widget>[
              CupertinoDialogAction(child: Text('OK')),
            ],
            content: Placeholder(fallbackHeight: 200),
          ),
        ),
      ),
    );

    final scrollbars = find
        .descendant(
          of: find.byType(CupertinoAlertDialog),
          matching: find.byType(CupertinoScrollbar),
        )
        .evaluate()
        .map((Element e) => e.widget as CupertinoScrollbar)
        .toList();

    expect(scrollbars.length, 2);
    expect(scrollbars[0].controller != scrollbars[1].controller, isTrue);
  });

  group('showCupertinoDialog avoids overlapping display features', () {
    testWidgets('positioning using anchorPoint', (WidgetTester tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          builder: (BuildContext context, Widget? child) => MediaQuery(
            // Display has a vertical hinge down the middle
            data: const MediaQueryData(
              size: Size(800, 600),
              displayFeatures: <DisplayFeature>[
                DisplayFeature(
                  bounds: Rect.fromLTRB(390, 0, 410, 600),
                  type: DisplayFeatureType.hinge,
                  state: DisplayFeatureState.unknown,
                ),
              ],
            ),
            child: child!,
          ),
          home: const Center(child: Text('Test')),
        ),
      );

      final BuildContext context = tester.element(find.text('Test'));
      unawaited(
        showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => const Placeholder(),
          anchorPoint: const Offset(1000, 0),
        ),
      );
      await tester.pumpAndSettle();

      // Should take the right side of the screen.
      expect(tester.getTopLeft(find.byType(Placeholder)), const Offset(410, 0));
      expect(
        tester.getBottomRight(find.byType(Placeholder)),
        const Offset(800, 600),
      );
    });

    testWidgets('positioning using Directionality',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          builder: (BuildContext context, Widget? child) => MediaQuery(
            // Display has a vertical hinge down the middle.
            data: const MediaQueryData(
              size: Size(800, 600),
              displayFeatures: <DisplayFeature>[
                DisplayFeature(
                  bounds: Rect.fromLTRB(390, 0, 410, 600),
                  type: DisplayFeatureType.hinge,
                  state: DisplayFeatureState.unknown,
                ),
              ],
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            ),
          ),
          home: const Center(child: Text('Test')),
        ),
      );

      final BuildContext context = tester.element(find.text('Test'));
      unawaited(
        showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => const Placeholder(),
        ),
      );
      await tester.pumpAndSettle();

      // Should take the right side of the screen
      expect(tester.getTopLeft(find.byType(Placeholder)), const Offset(410, 0));
      expect(
        tester.getBottomRight(find.byType(Placeholder)),
        const Offset(800, 600),
      );
    });

    testWidgets('default positioning', (WidgetTester tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          builder: (BuildContext context, Widget? child) => MediaQuery(
            // Display has a vertical hinge down the middle
            data: const MediaQueryData(
              size: Size(800, 600),
              displayFeatures: <DisplayFeature>[
                DisplayFeature(
                  bounds: Rect.fromLTRB(390, 0, 410, 600),
                  type: DisplayFeatureType.hinge,
                  state: DisplayFeatureState.unknown,
                ),
              ],
            ),
            child: child!,
          ),
          home: const Center(child: Text('Test')),
        ),
      );

      final BuildContext context = tester.element(find.text('Test'));
      unawaited(
        showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => const Placeholder(),
        ),
      );
      await tester.pumpAndSettle();

      // By default it should place the dialog on the left screen
      expect(tester.getTopLeft(find.byType(Placeholder)), Offset.zero);
      expect(
        tester.getBottomRight(find.byType(Placeholder)),
        const Offset(390, 600),
      );
    });
  });

  testWidgets(
      'Hovering over Cupertino alert dialog action updates cursor to clickable on Web',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createAppWithButtonThatLaunchesDialog(
        dialogBuilder: (BuildContext context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 3),
          child: RepaintBoundary(
            child: CupertinoAlertDialog(
              title: const Text('Title'),
              content: const Text('text'),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {},
                  child: const Text('NO'),
                ),
                CupertinoDialogAction(
                  onPressed: () {},
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    final gesture =
        await tester.createGesture(kind: PointerDeviceKind.mouse, pointer: 1);
    await gesture.addPointer(location: const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(
      RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
      SystemMouseCursors.basic,
    );

    final dialogAction = tester.getCenter(find.text('OK'));
    await gesture.moveTo(dialogAction);
    await tester.pumpAndSettle();
    expect(
      RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
      kIsWeb ? SystemMouseCursors.click : SystemMouseCursors.basic,
    );
  });
}

RenderBox findActionButtonRenderBoxByTitle(WidgetTester tester, String title) {
  final buttonBox =
      tester.renderObject(find.widgetWithText(CupertinoDialogAction, title));
  assert(buttonBox is RenderBox);

  return buttonBox as RenderBox;
}

RenderBox findScrollableActionsSectionRenderBox(WidgetTester tester) {
  final actionsSection = tester.renderObject(
    find.byElementPredicate(
      (Element element) =>
          element.widget.runtimeType.toString() ==
          '_CupertinoAlertActionSection',
    ),
  );
  assert(actionsSection is RenderBox);

  return actionsSection as RenderBox;
}

Widget createAppWithButtonThatLaunchesDialog({
  required WidgetBuilder dialogBuilder,
}) =>
    MaterialApp(
      home: Material(
        child: Center(
          child: Builder(
            builder: (BuildContext context) => ElevatedButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: dialogBuilder,
                );
              },
              child: const Text('Go'),
            ),
          ),
        ),
      ),
    );

Widget boilerplate(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: child,
    );

Widget createAppWithCenteredButton(Widget child) => MaterialApp(
      home: Material(
        child: Center(
          child: ElevatedButton(
            onPressed: null,
            child: child,
          ),
        ),
      ),
    );

class _RestorableDialogTestWidget extends StatelessWidget {
  const _RestorableDialogTestWidget();

  static Route<Object?> _dialogBuilder(
    BuildContext context,
    Object? _,
  ) =>
      CupertinoDialogRoute<void>(
        context: context,
        builder: (context) => const CupertinoAlertDialog(
          title: Text('Title'),
          content: Text('Content'),
          actions: <Widget>[
            CupertinoDialogAction(child: Text('Yes')),
            CupertinoDialogAction(child: Text('No')),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Home'),
        ),
        child: Center(
          child: CupertinoButton(
            onPressed: () {
              Navigator.of(context).restorablePush(_dialogBuilder);
            },
            child: const Text('X'),
          ),
        ),
      );
}
