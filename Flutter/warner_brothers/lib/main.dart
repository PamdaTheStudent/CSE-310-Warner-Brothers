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

  /// STORED AS PERCENTAGES (0 → 1)
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
  /// POSITIONS ARE NOW RELATIVE VALUES
  /// x = % across image
  /// y = % down image
  final Map<String, NavNode> nodes = {
    "347": NavNode(
      id: "347",
      position: const Offset(0.249, 0.162),
      neighbors: ["341_A"],
    ),

    "341_A": NavNode(
      id: "341_A",
      position: const Offset(0.252, 0.205),
      neighbors: ["347", "341_B", "353_A"],
    ),

    "341_B": NavNode(
      id: "341_B",
      position: const Offset(0.252, 0.367),
      neighbors: ["341_A"],
    ),

    "353_A": NavNode(
      id: "353_A",
      position: const Offset(0.272, 0.231),
      neighbors: ["341_A", "353_B"],
    ),

    "353_B": NavNode(
      id: "353_B",
      position: const Offset(0.362, 0.232),
      neighbors: ["353_A", "361_A"],
    ),

    "361_A": NavNode(
      id: "361_A",
      position: const Offset(0.379, 0.235),
      neighbors: ["353_B", "361_B"],
    ),

    "361_B": NavNode(
      id: "361_B",
      position: const Offset(0.466, 0.230),
      neighbors: ["361_A"],
    ),
  };

  /// ROOM → NODE CONNECTIONS
  final Map<String, String> roomToNode = {
    "STC 347": "347",
    "STC 341": "341_A",
    "STC 353": "353_A",
    "STC 361": "361_A",
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

  /// Computes the actual rendered image rect inside a container
  /// when using BoxFit.contain, accounting for letterboxing.
  _ImageRect _getImageRect(double containerWidth, double containerHeight) {
    // ⚠️ Replace these with your actual map.png pixel dimensions
    const double nativeWidth  = 1201;
    const double nativeHeight = 666;
    const double aspect = nativeWidth / nativeHeight;

    double renderedWidth, renderedHeight;

    if (containerWidth / containerHeight > aspect) {
      // Letterbox on left/right
      renderedHeight = containerHeight;
      renderedWidth  = containerHeight * aspect;
    } else {
      // Letterbox on top/bottom
      renderedWidth  = containerWidth;
      renderedHeight = containerWidth / aspect;
    }

    final offsetX = (containerWidth  - renderedWidth)  / 2;
    final offsetY = (containerHeight - renderedHeight) / 2;

    return _ImageRect(
      offsetX:        offsetX,
      offsetY:        offsetY,
      renderedWidth:  renderedWidth,
      renderedHeight: renderedHeight,
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
                          routePoints.map((p) => Offset(
                            rect.offsetX + p.dx * rect.renderedWidth,
                            rect.offsetY + p.dy * rect.renderedHeight,
                          )).toList(),
                        ),
                      ),

                      /// DEBUG NODE DOTS
                      ...nodes.values.map((node) {
                        final scaledX =
                            rect.offsetX + node.position.dx * rect.renderedWidth;
                        final scaledY =
                            rect.offsetY + node.position.dy * rect.renderedHeight;

                        return Positioned(
                          left: scaledX - 6,
                          top:  scaledY - 6,
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

/// Simple data class to hold the computed image rect
class _ImageRect {
  final double offsetX;
  final double offsetY;
  final double renderedWidth;
  final double renderedHeight;

  const _ImageRect({
    required this.offsetX,
    required this.offsetY,
    required this.renderedWidth,
    required this.renderedHeight,
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