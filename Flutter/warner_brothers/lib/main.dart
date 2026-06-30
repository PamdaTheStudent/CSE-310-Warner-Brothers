import 'dart:collection';
import 'package:flutter/material.dart';
import 'models/nav_models.dart';
import 'data/stc_building.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Pull floor 3 data from the STC building file.
  final _floor = stcBuilding.floor(3)!;

  // Tracks which rooms the user has tapped (by RoomPolygon id).
  String? _selectedStart;
  String? _selectedEnd;

  // Called when the user taps the map inside the InteractiveViewer.
  // localPosition is already in the widget's local coordinate space,
  // so it matches the screen coords produced by _pixelToScreen.
  void _handleMapTap(Offset localPos, _ImageRect rect) {
    for (final room in _floor.rooms) {
      final pts = room.pixels
          .map((p) => _pixelToScreen(p, rect))
          .toList();
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

  List<Offset> routePoints = [];

  final TextEditingController startController = TextEditingController();
  final TextEditingController endController   = TextEditingController();

  /// FIND PATH USING BFS
  List<String> findPath(String start, String goal) {
    Queue<String> queue = Queue();
    Map<String, String?> cameFrom = {};

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

    List<String> path = [];
    String? current = goal;

    while (current != null) {
      path.insert(0, current);
      current = cameFrom[current];
    }

    return path;
  }

  // Looks up a nav node by room number. Input is trimmed before lookup.
  String? _resolveRoom(String input) => _floor.roomToNode[input.trim()];

  void generateRoute() {
    // Prefer tapped polygon selections; fall back to text fields.
    final startNode = _selectedStart != null
        ? _resolveRoom(_selectedStart!)
        : _resolveRoom(startController.text);
    final endNode = _selectedEnd != null
        ? _resolveRoom(_selectedEnd!)
        : _resolveRoom(endController.text);

    if (startNode == null || endNode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(startNode == null
              ? 'No start room selected'
              : 'No destination room selected'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final nodePath = findPath(startNode, endNode);

    setState(() {
      routePoints = nodePath
          .map((id) => _floor.navNodes[id]!.position)
          .toList();
    });
  }

  /// Converts a raw pixel coordinate from the native image
  /// into a screen position accounting for BoxFit.contain letterboxing.
  Offset _pixelToScreen(Offset pixel, _ImageRect rect) {
    return Offset(
      rect.offsetX + (pixel.dx / rect.nativeWidth)  * rect.renderedWidth,
      rect.offsetY + (pixel.dy / rect.nativeHeight) * rect.renderedHeight,
    );
  }

  /// IMAGE RECT HELPER — paste into your Flutter file
/// (nativeWidth / nativeHeight match your map.png pixel size)
_ImageRect _getImageRect(double containerWidth, double containerHeight) {
  const double nativeWidth  = 1201;
  const double nativeHeight = 666;
  const double aspect = nativeWidth / nativeHeight;
  double renderedWidth, renderedHeight;
  if (containerWidth / containerHeight > aspect) {
    renderedHeight = containerHeight;
    renderedWidth  = containerHeight * aspect;
  } else {
    renderedWidth  = containerWidth;
    renderedHeight = containerWidth / aspect;
  }
  final offsetX = (containerWidth  - renderedWidth)  / 2;
  final offsetY = (containerHeight - renderedHeight) / 2;
  return _ImageRect(
    offsetX: offsetX, offsetY: offsetY,
    renderedWidth: renderedWidth, renderedHeight: renderedHeight,
    nativeWidth: nativeWidth, nativeHeight: nativeHeight,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("School Navigation"),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startController,
                    decoration: const InputDecoration(
                      labelText: "Start Room #",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: endController,
                    decoration: const InputDecoration(
                      labelText: "End Room #",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: generateRoute,
                  child: const Text("Go"),
                ),
              ],
            ),
          ),

          // Selection status bar
          if (_selectedStart != null || _selectedEnd != null)
            Container(
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _SelectionChip(
                    label: _selectedStart != null ? 'Start: $_selectedStart' : 'Tap a room',
                    color: Colors.tealAccent,
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white54, size: 16),
                  const SizedBox(width: 8),
                  _SelectionChip(
                    label: _selectedEnd != null ? 'End: $_selectedEnd' : 'Tap a room',
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final containerWidth  = constraints.maxWidth;
                final containerHeight = constraints.maxHeight;
                final rect = _getImageRect(containerWidth, containerHeight);

                return InteractiveViewer(
                  maxScale: 5,
                  minScale: 1,

                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapUp: (d) => _handleMapTap(d.localPosition, rect),
                    child: Stack(
                      children: [
                        /// MAP IMAGE
                        SizedBox(
                          width:  containerWidth,
                          height: containerHeight,
                          child: Image.asset(
                            "assets/images/stc/floor_map/stc_3.png",
                            fit: BoxFit.contain,
                          ),
                        ),

                        /// ROOM POLYGONS
                        CustomPaint(
                          size: Size(containerWidth, containerHeight),
                          painter: RoomPolygonPainter(
                            rooms:           _floor.rooms,
                            rect:            rect,
                            selectedStartId: _selectedStart,
                            selectedEndId:   _selectedEnd,
                          ),
                        ),

                        /// ROUTE
                        CustomPaint(
                          size: Size(containerWidth, containerHeight),
                          painter: PathPainter(
                            routePoints
                                .map((p) => _pixelToScreen(p, rect))
                                .toList(),
                          ),
                        ),

                        /// DEBUG NODES — remove once routing is verified
                        ..._floor.navNodes.values.map((node) {
                          final screen = _pixelToScreen(node.position, rect);
                          return Positioned(
                            left: screen.dx - 6,
                            top:  screen.dy - 6,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageRect {
  final double offsetX;
  final double offsetY;
  final double renderedWidth;
  final double renderedHeight;
  final double nativeWidth;
  final double nativeHeight;

  const _ImageRect({
    required this.offsetX,
    required this.offsetY,
    required this.renderedWidth,
    required this.renderedHeight,
    required this.nativeWidth,
    required this.nativeHeight,
  });
}

/// Draws room polygon outlines over the map image.
/// Converts each polygon's pixel coords to screen coords using the
/// same letterbox math as _pixelToScreen.
class RoomPolygonPainter extends CustomPainter {
  final List<RoomPolygon> rooms;
  final _ImageRect        rect;
  final String?           selectedStartId;
  final String?           selectedEndId;

  const RoomPolygonPainter({
    required this.rooms,
    required this.rect,
    this.selectedStartId,
    this.selectedEndId,
  });

  Offset _toScreen(Offset pixel) {
    return Offset(
      rect.offsetX + (pixel.dx / rect.nativeWidth)  * rect.renderedWidth,
      rect.offsetY + (pixel.dy / rect.nativeHeight) * rect.renderedHeight,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final room in rooms) {
      final isStart = room.id == selectedStartId;
      final isEnd   = room.id == selectedEndId;

      final fillColor = isStart
          ? Colors.tealAccent.withAlpha(80)
          : isEnd
              ? Colors.redAccent.withAlpha(80)
              : Colors.cyan.withAlpha(40);

      final strokeColor = isStart
          ? Colors.tealAccent
          : isEnd
              ? Colors.redAccent
              : Colors.cyanAccent;

      final pts = room.pixels.map(_toScreen).toList();
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final pt in pts.skip(1)) path.lineTo(pt.dx, pt.dy);
      path.close();

      canvas.drawPath(path, Paint()..color = fillColor..style = PaintingStyle.fill);
      canvas.drawPath(path, Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = isStart || isEnd ? 2.5 : 1.5);
    }
  }

  @override
  bool shouldRepaint(covariant RoomPolygonPainter old) =>
      old.rect            != rect ||
      old.selectedStartId != selectedStartId ||
      old.selectedEndId   != selectedEndId;
}

class _SelectionChip extends StatelessWidget {
  final String label;
  final Color  color;
  const _SelectionChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:        color.withAlpha(30),
        border:       Border.all(color: color.withAlpha(150)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}

class PathPainter extends CustomPainter {
  final List<Offset> points;

  PathPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paintLine = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(points.first.dx, points.first.dy);

    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
