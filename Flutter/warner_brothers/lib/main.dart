import 'dart:collection';
import 'package:flutter/material.dart';
import 'models/nav_models.dart';
import 'data/stc_building.dart';

void main() {
  runApp(const MyApp());
}

// MyApp is stateful so the theme toggle can rebuild MaterialApp.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme:     ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: MapScreen(onToggleTheme: _toggleTheme),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  MapScreen
// ─────────────────────────────────────────────────────────────
class MapScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const MapScreen({super.key, required this.onToggleTheme});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Active building and floor.
  final _building       = stcBuilding;
  int   _currentFloorNum = 3;
  FloorData get _floor  => _building.floor(_currentFloorNum)!;

  // Tapped room selections.
  String? _selectedStart;
  String? _selectedEnd;

  // Route overlay points (screen coords, rebuilt on each generateRoute call).
  List<Offset> routePoints = [];

  // Text input controllers (fallback when no room is tapped).
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController   = TextEditingController();

  // ── Room tap handling ───────────────────────────────────────
  void _handleMapTap(Offset localPos, _ImageRect rect) {
    for (final room in _floor.rooms) {
      final pts  = room.pixels.map((p) => _pixelToScreen(p, rect)).toList();
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final pt in pts.skip(1)) path.lineTo(pt.dx, pt.dy);
      path.close();
      if (!path.contains(localPos)) continue;

      setState(() {
        if (room.id == _selectedStart) {
          _selectedStart = _selectedEnd;
          _selectedEnd   = null;
        } else if (room.id == _selectedEnd) {
          _selectedEnd = null;
        } else if (_selectedStart == null) {
          _selectedStart = room.id;
        } else {
          _selectedEnd = room.id;
        }
      });
      return;
    }
  }

  // ── Pathfinding ─────────────────────────────────────────────
  List<String> _findPath(String start, String goal) {
    final queue    = Queue<String>();
    final cameFrom = <String, String?>{};
    queue.add(start);
    cameFrom[start] = null;

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (current == goal) break;
      for (final next in _floor.navNodes[current]!.neighbors) {
        if (!cameFrom.containsKey(next)) {
          queue.add(next);
          cameFrom[next] = current;
        }
      }
    }

    final path = <String>[];
    String? cur = goal;
    while (cur != null) {
      path.insert(0, cur);
      cur = cameFrom[cur];
    }
    return path;
  }

  String? _resolveRoom(String input) => _floor.roomToNode[input.trim()];

  void generateRoute() {
    final startNode = _selectedStart != null
        ? _resolveRoom(_selectedStart!)
        : _resolveRoom(startController.text);
    final endNode = _selectedEnd != null
        ? _resolveRoom(_selectedEnd!)
        : _resolveRoom(endController.text);

    if (startNode == null || endNode == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(startNode == null
            ? 'No start room selected'
            : 'No destination room selected'),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    final nodePath = _findPath(startNode, endNode);
    setState(() {
      routePoints = nodePath
          .map((id) => _floor.navNodes[id]!.position)
          .toList();
    });
  }

  // ── Coordinate helpers ──────────────────────────────────────
  Offset _pixelToScreen(Offset pixel, _ImageRect rect) => Offset(
        rect.offsetX + (pixel.dx / rect.nativeWidth)  * rect.renderedWidth,
        rect.offsetY + (pixel.dy / rect.nativeHeight) * rect.renderedHeight,
      );

  _ImageRect _getImageRect(double w, double h) {
    const double nW = 1201;
    const double nH = 666;
    const double aspect = nW / nH;
    final double rW, rH;
    if (w / h > aspect) {
      rH = h; rW = h * aspect;
    } else {
      rW = w; rH = w / aspect;
    }
    return _ImageRect(
      offsetX: (w - rW) / 2, offsetY: (h - rH) / 2,
      renderedWidth: rW, renderedHeight: rH,
      nativeWidth: nW, nativeHeight: nH,
    );
  }

  // ── Build ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: search inputs + icons ────────────────
            _TopBar(
              startController:  startController,
              endController:    endController,
              onSearch:         generateRoute,
              onToggleTheme:    widget.onToggleTheme,
              isDark:           isDark,
            ),

            // ── Selection bar: tapped room chips + view toggle ─
            _SelectionBar(
              selectedStart: _selectedStart,
              selectedEnd:   _selectedEnd,
            ),

            // ── Map ───────────────────────────────────────────
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                final rect = _getImageRect(
                    constraints.maxWidth, constraints.maxHeight);

                return InteractiveViewer(
                  maxScale: 5,
                  minScale: 1,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapUp: (d) => _handleMapTap(d.localPosition, rect),
                    child: Stack(children: [
                      // Floor plan image
                      SizedBox(
                        width:  constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Image.asset(
                          _floor.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const ColoredBox(color: Color(0xFF1E1E1E)),
                        ),
                      ),

                      // Building outline + room polygons
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: RoomPolygonPainter(
                          rooms:           _floor.rooms,
                          buildingOutline: _floor.buildingOutline,
                          rect:            rect,
                          selectedStartId: _selectedStart,
                          selectedEndId:   _selectedEnd,
                        ),
                      ),

                      // Route line
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: PathPainter(routePoints
                            .map((p) => _pixelToScreen(p, rect))
                            .toList()),
                      ),

                      // DEBUG nodes — remove once routing is verified
                      ..._floor.navNodes.values.map((node) {
                        final s = _pixelToScreen(node.position, rect);
                        return Positioned(
                          left: s.dx - 6, top: s.dy - 6,
                          child: Container(
                            width: 12, height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),
                    ]),
                  ),
                );
              }),
            ),

            // ── Bottom bar: floor selector + building picker ───
            _BottomBar(
              building:       _building,
              currentFloor:   _currentFloorNum,
              onFloorChanged: (f) => setState(() {
                _currentFloorNum = f;
                _selectedStart   = null;
                _selectedEnd     = null;
                routePoints      = [];
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _TopBar
// ─────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final TextEditingController startController;
  final TextEditingController endController;
  final VoidCallback          onSearch;
  final VoidCallback          onToggleTheme;
  final bool                  isDark;

  const _TopBar({
    required this.startController,
    required this.endController,
    required this.onSearch,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: startController,
              decoration: const InputDecoration(
                hintText:    'Search Box 1',
                border:      OutlineInputBorder(),
                isDense:     true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: endController,
              decoration: const InputDecoration(
                hintText:    'Search Box 2',
                border:      OutlineInputBorder(),
                isDense:     true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearch,
            tooltip: 'Find route',
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _SelectionBar  — shows tapped room selections
// ─────────────────────────────────────────────────────────────
class _SelectionBar extends StatelessWidget {
  final String? selectedStart;
  final String? selectedEnd;

  const _SelectionBar({this.selectedStart, this.selectedEnd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _RoomField(
              label: selectedStart ?? 'Source',
              isSet: selectedStart != null,
              color: Colors.teal,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _RoomField(
              label: selectedEnd ?? 'Destination',
              isSet: selectedEnd != null,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 4),
          // View toggle placeholder
          IconButton(
            icon: const Icon(Icons.view_carousel_outlined),
            onPressed: () {
              // TODO: toggle between map view and list view
            },
            tooltip: 'Change view',
          ),
        ],
      ),
    );
  }
}

class _RoomField extends StatelessWidget {
  final String label;
  final bool   isSet;
  final Color  color;

  const _RoomField({
    required this.label,
    required this.isSet,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSet ? color : Theme.of(context).dividerColor,
          width: isSet ? 1.5 : 1.0,
        ),
        borderRadius: BorderRadius.circular(4),
        color: isSet ? color.withAlpha(20) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color:      isSet ? color : Theme.of(context).hintColor,
          fontWeight: isSet ? FontWeight.bold : FontWeight.normal,
          fontSize:   14,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _BottomBar  — floor selector + building picker
// ─────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final BuildingData building;
  final int          currentFloor;
  final ValueChanged<int> onFloorChanged;

  const _BottomBar({
    required this.building,
    required this.currentFloor,
    required this.onFloorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          // Floor dropdown
          Expanded(
            child: DropdownButtonFormField<int>(
              value: currentFloor,
              decoration: const InputDecoration(
                border:      OutlineInputBorder(),
                isDense:     true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              items: building.floors
                  .map((f) => DropdownMenuItem(
                        value: f.floorNumber,
                        child: Text(f.name),
                      ))
                  .toList(),
              onChanged: (v) { if (v != null) onFloorChanged(v); },
            ),
          ),
          const SizedBox(width: 12),
          // Building selection
          Expanded(
            child: FilledButton(
              onPressed: () {
                // TODO: open building picker
              },
              child: const Text('Building Selection'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Painters & helpers  (unchanged)
// ─────────────────────────────────────────────────────────────
class _ImageRect {
  final double offsetX, offsetY;
  final double renderedWidth, renderedHeight;
  final double nativeWidth, nativeHeight;

  const _ImageRect({
    required this.offsetX,    required this.offsetY,
    required this.renderedWidth, required this.renderedHeight,
    required this.nativeWidth,  required this.nativeHeight,
  });
}

class RoomPolygonPainter extends CustomPainter {
  final List<RoomPolygon> rooms;
  final List<Offset>?     buildingOutline;
  final _ImageRect        rect;
  final String?           selectedStartId;
  final String?           selectedEndId;

  const RoomPolygonPainter({
    required this.rooms,
    required this.rect,
    this.buildingOutline,
    this.selectedStartId,
    this.selectedEndId,
  });

  Offset _toScreen(Offset p) => Offset(
        rect.offsetX + (p.dx / rect.nativeWidth)  * rect.renderedWidth,
        rect.offsetY + (p.dy / rect.nativeHeight) * rect.renderedHeight,
      );

  Path _makePath(List<Offset> pixels) {
    final pts  = pixels.map(_toScreen).toList();
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final pt in pts.skip(1)) path.lineTo(pt.dx, pt.dy);
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Building outline — stroke only
    if (buildingOutline != null && buildingOutline!.isNotEmpty) {
      canvas.drawPath(
        _makePath(buildingOutline!),
        Paint()
          ..color      = Colors.white70
          ..style      = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }

    // Room polygons
    for (final room in rooms) {
      final isStart = room.id == selectedStartId;
      final isEnd   = room.id == selectedEndId;

      final fillColor   = isStart ? Colors.tealAccent.withAlpha(80)
                        : isEnd   ? Colors.redAccent.withAlpha(80)
                        :           Colors.cyan.withAlpha(40);
      final strokeColor = isStart ? Colors.tealAccent
                        : isEnd   ? Colors.redAccent
                        :           Colors.cyanAccent;

      final path = _makePath(room.pixels);
      canvas.drawPath(path,
          Paint()..color = fillColor..style = PaintingStyle.fill);
      canvas.drawPath(path, Paint()
        ..color      = strokeColor
        ..style      = PaintingStyle.stroke
        ..strokeWidth = (isStart || isEnd) ? 2.5 : 1.5);
    }
  }

  @override
  bool shouldRepaint(covariant RoomPolygonPainter old) =>
      old.rect != rect ||
      old.selectedStartId != selectedStartId ||
      old.selectedEndId   != selectedEndId;
}

class PathPainter extends CustomPainter {
  final List<Offset> points;
  PathPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final pt in points.skip(1)) path.lineTo(pt.dx, pt.dy);
    canvas.drawPath(path, Paint()
      ..color      = Colors.blue
      ..strokeWidth = 10
      ..strokeCap  = StrokeCap.round
      ..style      = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
