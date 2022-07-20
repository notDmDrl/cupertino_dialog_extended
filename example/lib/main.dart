import 'package:cupertino_dialog_extended/cupertino_dialog_extended.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode mode = ThemeMode.light;

  void onThemeModeChange() {
    setState(() {
      mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'CupertinoDialogExtended demo',
        theme: ThemeData(
          cupertinoOverrideTheme: const CupertinoThemeData(
            scaffoldBackgroundColor: CupertinoColors.systemBackground,
            barBackgroundColor: Color(0xF0F9F9F9),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          cupertinoOverrideTheme: const CupertinoThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: CupertinoColors.systemBackground,
            barBackgroundColor: Color(0xF01D1D1D),
          ),
        ),
        themeMode: mode,
        home: MyHomePage(onThemeModeChange: onThemeModeChange),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.onThemeModeChange});

  final GestureTapCallback onThemeModeChange;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            onPressed: onThemeModeChange,
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.sun_max_fill),
          ),
          middle: Text(
            'CupertinoDialogExtended example',
            style: TextStyle(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.label,
                context,
              ),
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CupertinoButton.filled(
                  child: const Text('CupertinoDialogExtended'),
                  onPressed: () => showCupertinoDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => CupertinoAlertDialogExtended(
                      title: const Text('Title here'),
                      actions: [
                        CupertinoDialogActionExtended(
                          onPressed: () {},
                          child: const Text('Action'),
                        ),
                        CupertinoDialogActionExtended(
                          onPressed: () {},
                          isDestructiveAction: true,
                          child: const Text('Action destructive'),
                        ),
                        CupertinoDialogActionExtended(
                          onPressed: () {},
                          isDefaultAction: true,
                          child: const Text('Action default'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CupertinoButton(
                  child: const Text('CupertinoDialog'),
                  onPressed: () => showCupertinoDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Title here'),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () {},
                          child: const Text('Action'),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {},
                          isDestructiveAction: true,
                          child: const Text('Action destructive'),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {},
                          isDefaultAction: true,
                          child: const Text('Action default'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                CupertinoButton.filled(
                  child: const Text('CupertinoActionSheetExtended'),
                  onPressed: () => showCupertinoModalPopup<void>(
                    context: context,
                    builder: (context) => CupertinoActionSheetExtended(
                      title: const Text('Title here'),
                      cancelButton: CupertinoActionSheetActionExtended(
                        onPressed: () {},
                        child: const Text('Cancel'),
                      ),
                      actions: [
                        CupertinoActionSheetActionExtended(
                          onPressed: () {},
                          child: const Text('Action'),
                        ),
                        CupertinoActionSheetActionExtended(
                          onPressed: () {},
                          isDestructiveAction: true,
                          child: const Text('Action destructive'),
                        ),
                        CupertinoActionSheetActionExtended(
                          onPressed: () {},
                          isDefaultAction: true,
                          child: const Text('Action default'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CupertinoButton(
                  child: const Text('CupertinoActionSheet'),
                  onPressed: () => showCupertinoModalPopup<void>(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: const Text('Title here'),
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () {},
                        child: const Text('Cancel'),
                      ),
                      actions: [
                        CupertinoActionSheetAction(
                          onPressed: () {},
                          child: const Text('Action'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {},
                          isDestructiveAction: true,
                          child: const Text('Action destructive'),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {},
                          isDefaultAction: true,
                          child: const Text('Action default'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
