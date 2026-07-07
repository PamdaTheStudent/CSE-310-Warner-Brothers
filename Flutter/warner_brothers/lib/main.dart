import 'dart:collection';
import 'package:flutter/material.dart';
import 'models/nav_models.dart';
import 'data/stc_building.dart';
import 'theme.dart';

bool __indoor = false;

void main() {
  runApp(const MyApp());
}

// MyApp listens to the global themeNotifier so any widget can toggle the theme.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme:     AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const MapScreen(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  MapScreen
// ─────────────────────────────────────────────────────────────
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Active building and floor.
  final _building       = stcBuilding;
  int   _currentFloorNum = 3;
  FloorData get _floor  => _building.floor(_currentFloorNum)!;

  // Tapped room selections and the floor each was selected on.
  String? _selectedStart;
  String? _selectedEnd;
  int?    _selectedStartFloor;
  int?    _selectedEndFloor;

  // Resolved route — each step carries its floor so the map auto-switches.
  List<PathStep> _pathSteps = [];

  // Index of the step the user is currently viewing.
  int _currentStep = 0;

  void switchView() {
    setState(() {
      __indoor = !__indoor;
    });
  }
  void _stepNext() {
    if (_currentStep < _pathSteps.length - 1) {
      setState(() {
        _currentStep++;
        _currentFloorNum = _pathSteps[_currentStep].floor;
      });
    }
  }

  void _stepPrev() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _currentFloorNum = _pathSteps[_currentStep].floor;
      });
    }
  }

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
          _selectedStart      = _selectedEnd;
          _selectedStartFloor = _selectedEndFloor;
          _selectedEnd        = null;
          _selectedEndFloor   = null;
          _pathSteps          = [];
          _currentStep        = 0;
        } else if (room.id == _selectedEnd) {
          _selectedEnd      = null;
          _selectedEndFloor = null;
          _pathSteps        = [];
          _currentStep      = 0;
        } else if (_selectedStart == null) {
          _selectedStart      = room.id;
          _selectedStartFloor = _currentFloorNum;
        } else {
          _selectedEnd      = room.id;
          _selectedEndFloor = _currentFloorNum;
        }
      });
      // Auto-route as soon as both endpoints are chosen
      if (_selectedStart != null && _selectedEnd != null) {
        generateRoute();
      }
      return;
    }
  }

  // ── Pathfinding ─────────────────────────────────────────────
  // BFS over the entire building graph, crossing floors via CrossFloorLinks.
  List<PathStep> _findBuildingPath(_NodeRef start, _NodeRef goal) {
    final queue    = Queue<_NodeRef>();
    final cameFrom = <_NodeRef, _NodeRef?>{};
    queue.add(start);
    cameFrom[start] = null;

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (current == goal) break;

      final floorData = _building.floor(current.floor);
      final node = floorData?.navNodes[current.nodeId];
      if (node == null) continue;

      // Same-floor neighbors
      for (final neighborId in node.neighbors) {
        if (!(floorData!.navNodes.containsKey(neighborId))) continue;
        final next = _NodeRef(current.floor, neighborId);
        if (!cameFrom.containsKey(next)) {
          queue.add(next);
          cameFrom[next] = current;
        }
      }

      // Cross-floor links (stairs / elevators)
      for (final link in _building.crossFloorLinks) {
        if (link.fromFloor == current.floor && link.fromNodeId == current.nodeId) {
          final next = _NodeRef(link.toFloor, link.toNodeId);
          if (!cameFrom.containsKey(next)) {
            queue.add(next);
            cameFrom[next] = current;
          }
        }
      }
    }

    // Reconstruct path
    final steps = <PathStep>[];
    _NodeRef? cur = goal;
    while (cur != null) {
      final pos = _building.floor(cur.floor)?.navNodes[cur.nodeId]?.position;
      if (pos != null) {
        steps.insert(0, PathStep(floor: cur.floor, nodeId: cur.nodeId, position: pos));
      }
      cur = cameFrom[cur];
    }
    return steps;
  }

  List<_NodeRef> _resolveNodeRefs(String roomId, int floor) {
    final floorData = _building.floor(floor);
    return (floorData?.roomToNode[roomId.trim()] ?? [])
        .map((id) => _NodeRef(floor, id))
        .toList();
  }

  void generateRoute() {
    final startRefs = _selectedStart != null
        ? _resolveNodeRefs(_selectedStart!, _selectedStartFloor ?? _currentFloorNum)
        : _resolveNodeRefs(startController.text, _currentFloorNum);
    final endRefs = _selectedEnd != null
        ? _resolveNodeRefs(_selectedEnd!, _selectedEndFloor ?? _currentFloorNum)
        : _resolveNodeRefs(endController.text, _currentFloorNum);

    if (startRefs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No start room selected'),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    if (endRefs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No destination room selected'),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    // Try every start-door × end-door combination; keep the shortest path.
    List<PathStep> best = [];
    for (final s in startRefs) {
      for (final e in endRefs) {
        final candidate = _findBuildingPath(s, e);
        if (best.isEmpty || candidate.length < best.length) best = candidate;
      }
    }

    setState(() {
      _pathSteps   = best;
      _currentStep = 0;
      if (best.isNotEmpty) _currentFloorNum = best.first.floor;
    });
  }

  // ── Path painter helper ─────────────────────────────────────
  // Filters _pathSteps to the current floor and builds the painter.
  PathPainter _buildPathPainter(_ImageRect rect, BuildContext ctx) {
    final points      = <Offset>[];
    int  travelled    = 0;
    Offset? dot;

    for (int i = 0; i < _pathSteps.length; i++) {
      final step = _pathSteps[i];
      if (step.floor != _currentFloorNum) continue;
      final sp = _pixelToScreen(step.position, rect);
      points.add(sp);
      if (i <= _currentStep) travelled++;
      if (i == _currentStep) dot = sp;
    }

    return PathPainter(
      points:      points,
      travelled:   travelled,
      currentDot:  dot,
      accentColor: Palette.accent(ctx),
    );
  }

  // ── Coordinate helpers ──────────────────────────────────────
  Offset _pixelToScreen(Offset pixel, _ImageRect rect) => Offset(
        rect.offsetX + (pixel.dx / rect.nativeWidth)  * rect.renderedWidth,
        rect.offsetY + (pixel.dy / rect.nativeHeight) * rect.renderedHeight,
      );

  _ImageRect _getImageRect(double w, double h) {
    final double nW = _floor.nativeWidth;
    final double nH = _floor.nativeHeight;
    final double aspect = nW / nH;
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: search inputs + icons ────────────────
            _TopBar(
              startController: startController,
              endController:   endController,
              onSearch:        generateRoute,
            ),

            // ── Selection bar: tapped room chips + view toggle ─
            SelectionBar(
              selectedStart: _selectedStart,
              selectedEnd:   _selectedEnd,
              onPressed:     switchView
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
<<<<<<< Updated upstream
                          __indoor ? "depression": _floor.imagePath,
=======
                          key: ValueKey(_floor.imagePath),
                          _floor.imagePath,
>>>>>>> Stashed changes
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

                      // Route line + current-step dot (current floor only)
                      CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: _buildPathPainter(rect, context),
                      ),

                      // Next / Prev step overlay (only shown when a route exists)
                      if (_pathSteps.isNotEmpty)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _StepButton(
                                icon:      Icons.arrow_back_rounded,
                                label:     'Prev',
                                onPressed: _currentStep > 0 ? _stepPrev : null,
                              ),
                              const SizedBox(width: 8),
                              // Step counter pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color:        Palette.surface(context).withAlpha(220),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Palette.border(context)),
                                ),
                                child: Text(
                                  'Step ${_currentStep + 1} / ${_pathSteps.length}',
                                  style: TextStyle(
                                    color:      Palette.textPrimary(context),
                                    fontWeight: FontWeight.bold,
                                    fontSize:   14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _StepButton(
                                icon:      Icons.arrow_forward_rounded,
                                label:     'Next',
                                onPressed: _currentStep < _pathSteps.length - 1 ? _stepNext : null,
                              ),
                            ],
                          ),
                        ),
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
                _pathSteps       = [];
                _currentStep     = 0;
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

  const _TopBar({
    required this.startController,
    required this.endController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Palette.surface(context),
        border: Border(
          bottom: BorderSide(color: Palette.border(context)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: startController,
              style: TextStyle(color: Palette.textPrimary(context)),
              decoration: InputDecoration(
                hintText:    'Start room',
                hintStyle:   TextStyle(color: Palette.textHint(context)),
                border:      const OutlineInputBorder(),
                isDense:     true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: endController,
              style: TextStyle(color: Palette.textPrimary(context)),
              decoration: InputDecoration(
                hintText:    'Destination room',
                hintStyle:   TextStyle(color: Palette.textHint(context)),
                border:      const OutlineInputBorder(),
                isDense:     true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.search, color: Palette.accent(context)),
            onPressed: onSearch,
            tooltip: 'Find route',
          ),
          // Theme toggle — writes directly to themeNotifier, no prop drilling
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Palette.textSecondary(context),
            ),
            onPressed: () {
              themeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
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


class SelectionBar extends StatelessWidget {
  final String? selectedStart;
  final String? selectedEnd;
  final VoidCallback onPressed;

  const SelectionBar({super.key, required this.onPressed, this.selectedStart, this.selectedEnd});

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
            onPressed: onPressed,
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
              initialValue: currentFloor,
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

    // Room / staircase / elevator polygons
    for (final room in rooms) {
      final isStart = room.id == selectedStartId;
      final isEnd   = room.id == selectedEndId;

      // Base color by area type; selection overrides to teal/red
      final Color baseFill, baseStroke;
      switch (room.type) {
        case AreaType.staircase:
          baseFill   = Colors.purple.withAlpha(60);
          baseStroke = Colors.purpleAccent;
        case AreaType.elevator:
          baseFill   = Colors.amber.withAlpha(60);
          baseStroke = Colors.amberAccent;
        case AreaType.room:
          baseFill   = Colors.cyan.withAlpha(40);
          baseStroke = Colors.cyanAccent;
      }

      final fillColor   = isStart ? Colors.tealAccent.withAlpha(80)
                        : isEnd   ? Colors.redAccent.withAlpha(80)
                        : baseFill;
      final strokeColor = isStart ? Colors.tealAccent
                        : isEnd   ? Colors.redAccent
                        : baseStroke;

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
  final int          travelled;   // how many points in the list are already done
  final Offset?      currentDot;  // screen pos of the step dot, null if off this floor
  final Color        accentColor;

  PathPainter({
    required this.points,
    required this.travelled,
    required this.accentColor,
    this.currentDot,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final dimPaint = Paint()
      ..color      = accentColor.withAlpha(80)
      ..strokeWidth = 6
      ..strokeCap  = StrokeCap.round
      ..style      = PaintingStyle.stroke;

    final brightPaint = Paint()
      ..color      = accentColor
      ..strokeWidth = 8
      ..strokeCap  = StrokeCap.round
      ..style      = PaintingStyle.stroke;

    // Full route dim
    final fullPath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final pt in points.skip(1)) fullPath.lineTo(pt.dx, pt.dy);
    canvas.drawPath(fullPath, dimPaint);

    // Travelled section bright
    if (travelled > 1) {
      final travelPath = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < travelled; i++) {
        travelPath.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(travelPath, brightPaint);
    }

    // Current position dot
    if (currentDot != null) {
      canvas.drawCircle(currentDot!, 10, Paint()..color = accentColor);
      canvas.drawCircle(currentDot!, 10, Paint()
        ..color      = accentColor.withAlpha(60)
        ..style      = PaintingStyle.stroke
        ..strokeWidth = 4);
    }
  }

  @override
  bool shouldRepaint(covariant PathPainter old) =>
      old.travelled != travelled || old.currentDot != currentDot || old.points != points;
}

// ── _NodeRef ─────────────────────────────────────────────────
// A (floor, nodeId) pair used as BFS state for cross-floor routing.
class _NodeRef {
  final int    floor;
  final String nodeId;
  const _NodeRef(this.floor, this.nodeId);

  @override
  bool operator ==(Object o) =>
      o is _NodeRef && o.floor == floor && o.nodeId == nodeId;

  @override
  int get hashCode => Object.hash(floor, nodeId);
}

// ─────────────────────────────────────────────────────────────
//  _StepButton  — Prev / Next overlay button
// ─────────────────────────────────────────────────────────────
class _StepButton extends StatelessWidget {
  final IconData    icon;
  final String      label;
  final VoidCallback? onPressed;

  const _StepButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon:  Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor:         enabled
            ? Palette.accent(context)
            : Palette.surface(context).withAlpha(200),
        foregroundColor:         enabled
            ? Palette.scaffold(context)
            : Palette.textDisabled(context),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: enabled ? 4 : 0,
      ),
    );
  }
}
