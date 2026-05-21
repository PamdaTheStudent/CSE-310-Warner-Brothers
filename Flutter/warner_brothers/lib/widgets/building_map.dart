// ─────────────────────────────────────────────────────────────
//  building_map.dart  –  blueprint overlay graph map renderer
// ─────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../models/building.dart';
import '../theme.dart';

class BuildingMap extends StatefulWidget {
  final BuildingFloor floor;
  final List<NodePosition> path;
  final int highlightStep;
  final String? startId;
  final String? endId;
  final ValueChanged<BuildingNode>? onNodeTap; // null = read-only navigation mode

  const BuildingMap({
    Key? key,
    required this.floor,
    required this.path,
    required this.highlightStep,
    this.startId,
    this.endId,
    this.onNodeTap,
  }) : super(key: key);

  @override
  State<BuildingMap> createState() => _BuildingMapState();
}

class _BuildingMapState extends State<BuildingMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;
  final TransformationController _transformController = TransformationController();

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    _transformController.dispose();
    super.dispose();
  }

  Set<String> get _pathNodeIds => widget.path
      .where((p) => p.floor == widget.floor.floorNumber)
      .map((p) => p.nodeId)
      .toSet();

  BuildingNode? get _currentNode {
    if (widget.highlightStep < 0 || widget.highlightStep >= widget.path.length) return null;
    final pos = widget.path[widget.highlightStep];
    return pos.floor == widget.floor.floorNumber ? widget.floor.nodes[pos.nodeId] : null;
  }

  @override
  Widget build(BuildContext context) {
    final pathNodeIds = _pathNodeIds;
    final currentNode = _currentNode;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Map bounds scale grid to match your 0-100 coordinates from building.dart
        const double mapWidth = 100.0;
        const double mapHeight = 100.0;

        final scaleX = constraints.maxWidth / mapWidth;
        final scaleY = constraints.maxHeight / mapHeight;
        final scale = scaleX < scaleY ? scaleX : scaleY;

        Offset toCanvas(double x, double y) => Offset(x * scale, y * scale);

        return Center(
          child: InteractiveViewer(
            transformationController: _transformController,
            boundaryMargin: const EdgeInsets.all(100.0), // Padding boundary outside map limits
            minScale: 0.5,
            maxScale: 5.0,
            child: SizedBox(
              width: mapWidth * scale,
              height: mapHeight * scale,
              child: Stack(
                children: [
                  // 1. Blueprint Floor Plan Background Image Layer
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/stc_floor_1.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Missing background asset:\nassets/images/stc_floor_1.png',
                                style: TextStyle(color: Colors.redAccent, fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 2. Continuous Path Vector Overlay (Draws lines between graph nodes)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _EdgePainter(
                        floor: widget.floor,
                        pathIds: pathNodeIds,
                        toCanvas: toCanvas,
                        context: context,
                      ),
                    ),
                  ),

                  // 3. Interactive Room Buttons & Selectors
                  ...widget.floor.nodes.values.map((node) {
                    final pos = toCanvas(node.x, node.y);
                    final isStart = widget.startId == node.id;
                    final isEnd = widget.endId == node.id;
                    final isOnPath = pathNodeIds.contains(node.id);

                    // Hallways are kept completely transparent as background lines do the work
                    if (node.type == NodeType.hallway) return const SizedBox.shrink();

                    // Style configs fetched from your theme palette
                    Color nodeColor = Palette.cellRoom(context).withOpacity(0.85);
                    Color borderColor = Palette.cellRoomBorder(context);
                    Color textColor = Palette.cellRoomText(context);

                    if (isStart) {
                      nodeColor = Palette.cellRoomStart;
                      borderColor = Palette.cellRoomStartBorder;
                      textColor = Colors.white;
                    } else if (isEnd) {
                      nodeColor = Palette.cellRoomEnd;
                      borderColor = Palette.cellRoomEndBorder;
                      textColor = Colors.white;
                    } else if (isOnPath) {
                      nodeColor = Palette.cellRoomPath(context);
                      borderColor = Palette.cellRoomPathBorder(context);
                      textColor = Colors.white;
                    }

                    final double radius = node.type == NodeType.room ? 16.0 : 14.0;

                    return Positioned(
                      left: pos.dx - radius,
                      top: pos.dy - radius,
                      child: GestureDetector(
                        onTap: widget.onNodeTap != null ? () => widget.onNodeTap!(node) : null,
                        child: Container(
                          width: radius * 2,
                          height: radius * 2,
                          decoration: BoxDecoration(
                            color: nodeColor,
                            shape: node.type == NodeType.room ? BoxShape.rectangle : BoxShape.circle,
                            borderRadius: node.type == NodeType.room ? BorderRadius.circular(4) : null,
                            border: Border.all(color: borderColor, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              node.label,
                              style: TextStyle(
                                fontSize: 8.0,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // 4. Current Target Step Navigation Location Pulse Dot
                  if (currentNode != null)
                    Positioned(
                      left: toCanvas(currentNode.x, currentNode.y).dx - 12,
                      top: toCanvas(currentNode.x, currentNode.y).dy - 12,
                      child: AnimatedBuilder(
                        animation: _scale,
                        builder: (_, __) => Transform.scale(
                          scale: _scale.value,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.cyanAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyanAccent.withOpacity(0.7),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EdgePainter extends CustomPainter {
  final BuildingFloor floor;
  final Set<String> pathIds;
  final Offset Function(double x, double y) toCanvas;
  final BuildContext context;

  const _EdgePainter({
    required this.floor,
    required this.pathIds,
    required this.toCanvas,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Hidden structures get a subtle hint, active routes get a prominent highlight
    final basePaint = Paint()
      ..color = Palette.border(context).withOpacity(0.15)
      ..strokeWidth = 2.0;

    final pathPaint = Paint()
      ..color = Palette.accent(context).withOpacity(0.85)
      ..strokeWidth = 5.5
      ..strokeCap = StrokeCap.round;

    final drawn = <String>{};
    for (final node in floor.nodes.values) {
      for (final connId in node.connectionIds) {
        final other = floor.nodes[connId];
        if (other == null) continue;

        final key = ([node.id, connId]..sort()).join('-');
        if (!drawn.add(key)) continue;

        final isPathEdge = pathIds.contains(node.id) && pathIds.contains(connId);
        final p1 = toCanvas(node.x, node.y);
        final p2 = toCanvas(other.x, other.y);

        if (isPathEdge) {
          canvas.drawLine(p1, p2, pathPaint);
        } else {
          canvas.drawLine(p1, p2, basePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EdgePainter oldDelegate) => true;
}