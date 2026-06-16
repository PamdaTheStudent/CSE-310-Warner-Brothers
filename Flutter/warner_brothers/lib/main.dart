import 'dart:collection';
import 'package:flutter/material.dart';

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

class NavNode {
  final String id;

  /// STORED AS RAW PIXEL COORDINATES matching map.png
  final Offset position;

  final List<String> neighbors;

  NavNode({
    required this.id,
    required this.position,
    required this.neighbors,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  /// HALLWAY GRAPH
  ///
  /// POSITIONS ARE RAW PIXEL COORDINATES from map.png
  /// x = pixels from left edge
  /// y = pixels from top edge
  /// NAV GRAPH
final Map<String, NavNode> nodes = {

  // ── STC Floor 3 ─────────────────
  "N1": NavNode(
    id: "N1",
    position: const Offset(453, 184),
    neighbors: ["N5", "N2"],
  ),
  "N2": NavNode(
    id: "N2",
    position: const Offset(560, 184),
    neighbors: ["N1", "N3"],
  ),
  "N3": NavNode(
    id: "N3",
    position: const Offset(591, 185),
    neighbors: ["N2", "N4"],
  ),
  "N4": NavNode(
    id: "N4",
    position: const Offset(694, 183),
    neighbors: ["N3"],
  ),
  "N5": NavNode(
    id: "N5",
    position: const Offset(433, 186),
    neighbors: ["N6", "N1"],
  ),
  "N6": NavNode(
    id: "N6",
    position: const Offset(329, 183),
    neighbors: ["N7", "N5"],
  ),
  "N7": NavNode(
    id: "N7",
    position: const Offset(306, 181),
    neighbors: ["N10", "N8", "N6"],
  ),
  "N8": NavNode(
    id: "N8",
    position: const Offset(305, 164),
    neighbors: ["N7", "N9"],
  ),
  "N9": NavNode(
    id: "N9",
    position: const Offset(305, 139),
    neighbors: ["N8"],
  ),
  "N10": NavNode(
    id: "N10",
    position: const Offset(312, 294),
    neighbors: ["N11", "N7"],
  ),
  "N11": NavNode(
    id: "N11",
    position: const Offset(321, 459),
    neighbors: ["N12", "N10"],
  ),
  "N12": NavNode(
    id: "N12",
    position: const Offset(334, 513),
    neighbors: ["N13", "N11"],
  ),
  "N13": NavNode(
    id: "N13",
    position: const Offset(286, 522),
    neighbors: ["N14", "N12"],
  ),
  "N14": NavNode(
    id: "N14",
    position: const Offset(279, 497),
    neighbors: ["N13"],
  ),
};

/// FLOOR GROUPS
final Map<String, List<String>> floorNodes = {
  "STC Floor 3": ["N1", "N2", "N3", "N4", "N5", "N6", "N7", "N8", "N9", "N10", "N11", "N12", "N13", "N14"],
};

/// ROOM → NODE
final Map<String, String> roomToNode = {
  "STC 361": "N1",
  "STC 361": "N2",
  "STC 367": "N3",
  "STC 367": "N4",
  "STC 353": "N5",
  "STC 353": "N6",
  "STC 341": "N8",
  "STC 347": "N9",
  "STC 341": "N10",
  "STC 300F": "N14",
};


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

      for (final next in nodes[current]!.neighbors) {
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

  void generateRoute() {
    String startRoom = startController.text.trim();
    String endRoom   = endController.text.trim();

    if (!roomToNode.containsKey(startRoom) ||
        !roomToNode.containsKey(endRoom)) {
      return;
    }

    String startNode = roomToNode[startRoom]!;
    String endNode   = roomToNode[endRoom]!;

    List<String> nodePath = findPath(startNode, endNode);

    setState(() {
      routePoints = nodePath
          .map((id) => nodes[id]!.position)
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
                      labelText: "Current Room",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: endController,
                    decoration: const InputDecoration(
                      labelText: "Destination Room",
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

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final containerWidth  = constraints.maxWidth;
                final containerHeight = constraints.maxHeight;
                final rect = _getImageRect(containerWidth, containerHeight);

                return InteractiveViewer(
                  maxScale: 5,
                  minScale: 1,

                  child: Stack(
                    children: [
                      /// MAP IMAGE
                      SizedBox(
                        width:  containerWidth,
                        height: containerHeight,
                        child: Image.asset(
                          "assets/map.png",
                          fit: BoxFit.contain,
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

                      /// DEBUG NODE DOTS
                      ...nodes.values.map((node) {
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
  final double nativeWidth;   // ← added
  final double nativeHeight;  // ← added

  const _ImageRect({
    required this.offsetX,
    required this.offsetY,
    required this.renderedWidth,
    required this.renderedHeight,
    required this.nativeWidth,
    required this.nativeHeight,
  });
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