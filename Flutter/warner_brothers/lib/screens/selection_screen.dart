// ─────────────────────────────────────────────
//  selection_screen.dart
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../models/building.dart';
import '../theme.dart';
import '../widgets/room_layout.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Palette.scaffold(context),
      appBar: AppBar(
        backgroundColor: Palette.surface(context),
        title: Text(
          'Building Navigator',
          style: TextStyle(
            color:       Palette.accent(context),
            fontWeight:  FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Palette.textSecondary(context),
            ),
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: () =>
                themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
              height: 1,
              color: Palette.accent(context).withOpacity(0.3)),
        ),
      ),
      body: RoomLayout(building: buildSTCBuilding()),
    );
  }
}
