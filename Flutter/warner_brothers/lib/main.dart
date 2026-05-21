// ─────────────────────────────────────────────
//  main.dart  –  app entry point
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'screens/selection_screen.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder rebuilds this widget whenever
    // themeNotifier.value changes (i.e. when the user taps the toggle).
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Building Navigator',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: const SelectionScreen(),
        );
      },
    );
  }
}
