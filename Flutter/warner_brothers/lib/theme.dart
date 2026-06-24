// ─────────────────────────────────────────────
//  theme.dart  –  colors, themes, toggle notifier
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';

// ── Global theme toggle ──────────────────────
// Any widget can read or write this to switch themes without
// needing to pass callbacks down through every widget.
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

// ── Theme definitions ────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.tealAccent,
          surface: const Color(0xFF161B22),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22),
          elevation: 0,
        ),
        useMaterial3: true,
      );

  static ThemeData light() => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.light(
          primary: Colors.cyan.shade700,
          secondary: Colors.teal.shade600,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Color(0xFF1A1A2A),
        ),
        useMaterial3: true,
      );
}

// ── Color palette ────────────────────────────
//
// Usage: call Palette.someColor(context) anywhere you have a BuildContext.
// Each method checks whether the current theme is dark or light and
// returns the appropriate color — so you never hardcode hex values in
// your widgets.
//
class Palette {
  Palette._();

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  // ── Backgrounds ────────────────────────────
  static Color scaffold(BuildContext context) =>
      _isDark(context) ? const Color(0xFF0D1117) : const Color(0xFFF5F7FA);

  static Color surface(BuildContext context) =>
      _isDark(context) ? const Color(0xFF161B22) : Colors.white;

  // ── Borders ────────────────────────────────
  static Color border(BuildContext context) =>
      _isDark(context) ? Colors.white12 : Colors.black12;

  static Color borderSubtle(BuildContext context) =>
      _isDark(context) ? Colors.white24 : Colors.black26;

  // ── Text ───────────────────────────────────
  static Color textPrimary(BuildContext context) =>
      _isDark(context) ? Colors.white : const Color(0xFF1A1A2A);

  static Color textSecondary(BuildContext context) =>
      _isDark(context) ? Colors.white54 : Colors.black54;

  static Color textHint(BuildContext context) =>
      _isDark(context) ? Colors.white38 : Colors.black38;

  static Color textDisabled(BuildContext context) =>
      _isDark(context) ? Colors.white24 : Colors.black26;

  // ── Accent colors ──────────────────────────
  // Dark mode uses neon variants; light mode uses darker shades
  // that stay visible against a white background.
  static Color accent(BuildContext context) =>
      _isDark(context) ? Colors.cyanAccent : Colors.cyan.shade700;

  static Color accentTeal(BuildContext context) =>
      _isDark(context) ? Colors.tealAccent : Colors.teal.shade600;

  static Color accentRed(BuildContext context) =>
      _isDark(context) ? Colors.redAccent : Colors.red.shade700;

  // ── Overlay (semi-transparent tint) ────────
  static Color overlayBg(BuildContext context) =>
      _isDark(context)
          ? Colors.white.withAlpha((0.05 * 255).round())
          : Colors.black.withAlpha((0.05 * 255).round());

  // ── Grid: wall cells ───────────────────────
  static Color cellWall(BuildContext context) =>
      _isDark(context) ? const Color(0xFF1A1A2E) : const Color(0xFFCFD8DC);

  static Color cellWallBorder(BuildContext context) =>
      _isDark(context) ? const Color(0xFF16213E) : const Color(0xFFB0BEC5);

  // ── Grid: hallway cells ────────────────────
  static Color cellHallway(BuildContext context) =>
      _isDark(context)
          ? const Color(0xFF0F3460).withAlpha((0.2 * 255).round())
          : const Color(0xFFE3F2FD);

  static Color cellHallwayPath(BuildContext context) =>
      _isDark(context)
          ? const Color(0xFF0F3460).withAlpha((0.6 * 255).round())
          : const Color(0xFF1565C0).withAlpha((0.2 * 255).round());

  // ── Grid: staircase cells ──────────────────
  static Color cellStaircase(BuildContext context) =>
      _isDark(context)
          ? const Color(0xFF533483).withAlpha((0.5 * 255).round())
          : const Color(0xFFEDE7F6);

  static Color cellStaircasePath(BuildContext context) =>
      _isDark(context)
          ? const Color(0xFF533483).withAlpha((0.9 * 255).round())
          : const Color(0xFFD1C4E9);

  static Color cellStaircaseBorder(BuildContext context) =>
      _isDark(context) ? const Color(0xFF9B72CF) : const Color(0xFF7C4DFF);

  static Color cellStaircaseText(BuildContext context) =>
      _isDark(context) ? Colors.white70 : Colors.deepPurple.shade700;

  // ── Grid: room cells ───────────────────────
  static Color cellRoom(BuildContext context) =>
      _isDark(context) ? const Color(0xFF263238) : const Color(0xFFECEFF1);

  static Color cellRoomBorder(BuildContext context) =>
      _isDark(context) ? const Color(0xFF546E7A) : const Color(0xFF90A4AE);

  static Color cellRoomText(BuildContext context) =>
      _isDark(context) ? Colors.blueGrey.shade300 : Colors.blueGrey.shade700;

  // Path-highlighted room
  static Color cellRoomPath(BuildContext context) =>
      _isDark(context)
          ? const Color(0xFF1565C0).withAlpha((0.7 * 255).round())
          : const Color(0xFF1976D2).withAlpha((0.4 * 255).round());

  static Color cellRoomPathBorder(BuildContext context) =>
      _isDark(context) ? Colors.lightBlueAccent : Colors.blue;

  // Start / end room colors — same in both themes because the
  // solid green/red backgrounds look fine regardless of page brightness.
  static const Color cellRoomStart    = Color(0xFF00897B);
  static const Color cellRoomStartBorder = Colors.tealAccent;
  static const Color cellRoomEnd      = Color(0xFFC62828);
  static const Color cellRoomEndBorder   = Colors.redAccent;

  // ── Path dot (animated circle on map) ──────
  static Color pathDot(BuildContext context) => accent(context);
}
