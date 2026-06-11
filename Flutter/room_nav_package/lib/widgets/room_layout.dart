// ─────────────────────────────────────────────────────────────
//  room_layout.dart  –  self-contained room-selection widget
//
//  DEPENDENCIES: only Flutter + building.dart (no theme.dart needed)
//
//  Drop this widget anywhere and pass ONE callback:
//
//    RoomLayout(
//      building: myBuilding,
//      onRoomsSelected: (roomA, floorA, roomB, floorB) {
//        // ← YOUR FUNCTION GOES HERE
//      },
//    )
//
//  The widget handles all rendering (polygon shapes, colors,
//  floor tabs, selection state). It calls onRoomsSelected the
//  moment the user taps a second room — what happens next is
//  entirely up to the caller.
// ─────────────────────────────────────────────────────────────
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/building.dart';

// ─────────────────────────────────────────────────────────────
//  Built-in colors — edit these to restyle the widget.
//  No external theme file needed.
// ─────────────────────────────────────────────────────────────
class _C {
  _C._();

  static bool _dark(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark;

  // Backgrounds
  static Color surface(BuildContext ctx) =>
      _dark(ctx) ? const Color(0xFF161B22) : Colors.white;

  // Borders
  static Color border(BuildContext ctx) =>
      _dark(ctx) ? Colors.white12 : Colors.black12;

  // Accent / primary
  static Color accent(BuildContext ctx) =>
      _dark(ctx) ? Colors.cyanAccent : Colors.cyan.shade700;

  // Status banner colors
  static Color teal(BuildContext ctx) =>
      _dark(ctx) ? Colors.tealAccent : Colors.teal.shade600;

  static Color red(BuildContext ctx) =>
      _dark(ctx) ? Colors.redAccent : Colors.red.shade700;

  // Hint text
  static Color hint(BuildContext ctx) =>
      _dark(ctx) ? Colors.white38 : Colors.black38;

  // Unselected room polygon
  static Color roomBorder(BuildContext ctx) =>
      _dark(ctx) ? const Color(0xFF546E7A) : const Color(0xFF90A4AE);

  static Color roomText(BuildContext ctx) =>
      _dark(ctx)
          ? Colors.blueGrey.shade300
          : Colors.blueGrey.shade700;

  // Selected room (first tap) — teal fill
  static const Color roomStart       = Color(0xFF00897B);
  static const Color roomStartBorder = Colors.tealAccent;
}

// ── Public callback type ──────────────────────────────────────
// roomA / floorA = first room tapped
// roomB / floorB = second room tapped
typedef RoomsSelectedCallback = void Function(
  BuildingNode roomA, int floorA,
  BuildingNode roomB, int floorB,
);

// ─────────────────────────────────────────────────────────────
//  RoomLayout widget
// ─────────────────────────────────────────────────────────────
class RoomLayout extends StatefulWidget {
  /// The building to display.
  final Building building;

  /// Called when the user has tapped two distinct rooms.
  final RoomsSelectedCallback onRoomsSelected;

  const RoomLayout({
    Key? key,
    required this.building,
    required this.onRoomsSelected,
  }) : super(key: key);

  @override
  State<RoomLayout> createState() => _RoomLayoutState();
}

class _RoomLayoutState extends State<RoomLayout> {
  int _currentFloor = 1;
  BuildingNode? _selectedA;
  int?          _floorA;

  BuildingFloor get _floor =>
      widget.building.floors.firstWhere((f) => f.floorNumber == _currentFloor);

  void _onRoomTap(BuildingNode node) {
    setState(() {
      if (_selectedA == null) {
        _selectedA = node;
        _floorA    = _currentFloor;
      } else if (_floorA == _currentFloor && _selectedA!.id == node.id) {
        // Tapped same room again — deselect
        _selectedA = null;
        _floorA    = null;
      } else {
        // ──────────────────────────────────────────────────
        //  Two rooms selected — fire the callback.
        //  Reset widget state first, then call the function.
        // ──────────────────────────────────────────────────
        final roomA  = _selectedA!;
        final floorA = _floorA!;
        _selectedA = null;
        _floorA    = null;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onRoomsSelected(roomA, floorA, node, _currentFloor);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatusBanner(selectedA: _selectedA),
        _FloorTabs(
          floors:         widget.building.floors,
          currentFloor:   _currentFloor,
          onFloorChanged: (f) => setState(() => _currentFloor = f),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color:        _C.surface(context),
                border:       Border.all(color: _C.border(context)),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: _RoomMap(
                floor:       _floor,
                selectedAId: _selectedA?.id,
                onRoomTap:   _onRoomTap,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _RoomMap  –  floor plan image + interactive polygon rooms
// ─────────────────────────────────────────────────────────────
class _RoomMap extends StatefulWidget {
  final BuildingFloor floor;
  final String?       selectedAId;
  final ValueChanged<BuildingNode> onRoomTap;

  const _RoomMap({
    required this.floor,
    required this.selectedAId,
    required this.onRoomTap,
  });

  @override
  State<_RoomMap> createState() => _RoomMapState();
}

class _RoomMapState extends State<_RoomMap> {
  Size? _imgSize;

  @override
  void initState() {
    super.initState();
    _loadImageSize();
  }

  void _loadImageSize() {
    final completer = Completer<Size>();
    AssetImage(widget.floor.imagePath)
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((info, _) {
      if (!completer.isCompleted) {
        completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }
    }));
    completer.future.then((s) {
      if (mounted) setState(() => _imgSize = s);
    });
  }

  @override
  void didUpdateWidget(covariant _RoomMap old) {
    super.didUpdateWidget(old);
    if (old.floor.imagePath != widget.floor.imagePath) {
      _imgSize = null;
      _loadImageSize();
    }
  }

  // Converts image pixel coords → canvas coords using BoxFit.contain math
  static Offset _pxToCanvas(Offset px, Size imgSize, double canvasS) {
    final s  = math.min(canvasS / imgSize.width, canvasS / imgSize.height);
    final ox = (canvasS - imgSize.width  * s) / 2;
    final oy = (canvasS - imgSize.height * s) / 2;
    return Offset(ox + px.dx * s, oy + px.dy * s);
  }

  bool _polygonHit(List<Offset> poly, Offset point, double canvasS) {
    if (_imgSize == null) return false;
    final path = Path();
    final pts  = poly.map((p) => _pxToCanvas(p, _imgSize!, canvasS)).toList();
    path.moveTo(pts.first.dx, pts.first.dy);
    for (final pt in pts.skip(1)) path.lineTo(pt.dx, pt.dy);
    path.close();
    return path.contains(point);
  }

  void _handleTap(Offset localPos, double canvasS) {
    for (final node in widget.floor.nodes.values) {
      if (node.polygon == null || node.type == NodeType.hallway) continue;
      if (_polygonHit(node.polygon!, localPos, canvasS)) {
        widget.onRoomTap(node);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final canvasS = math.min(constraints.maxWidth, constraints.maxHeight);

      return InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 5.0,
        child: SizedBox(
          width: canvasS, height: canvasS,
          child: Stack(children: [
            // Background floor plan image
            Positioned.fill(
              child: Image.asset(
                widget.floor.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const ColoredBox(color: Color(0xFF161B22)),
              ),
            ),

            // Polygon room overlays
            if (_imgSize != null)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapUp: (d) => _handleTap(d.localPosition, canvasS),
                  child: CustomPaint(
                    painter: _PolygonPainter(
                      floor:       widget.floor,
                      imgSize:     _imgSize!,
                      canvasS:     canvasS,
                      selectedAId: widget.selectedAId,
                      context:     context,
                    ),
                  ),
                ),
              ),

            // Fallback dots for rooms without a polygon
            ...widget.floor.nodes.values.map((node) {
              if (node.type == NodeType.hallway) return const SizedBox.shrink();
              if (node.polygon != null)          return const SizedBox.shrink();
              final scale = canvasS / 100;
              final pos   = Offset(node.x * scale, node.y * scale);
              const r     = 16.0;
              return Positioned(
                left: pos.dx - r, top: pos.dy - r,
                child: _FallbackDot(
                  node:       node,
                  isSelected: widget.selectedAId == node.id,
                  onTap:      () => widget.onRoomTap(node),
                ),
              );
            }),
          ]),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
//  _PolygonPainter
// ─────────────────────────────────────────────────────────────
class _PolygonPainter extends CustomPainter {
  final BuildingFloor floor;
  final Size          imgSize;
  final double        canvasS;
  final String?       selectedAId;
  final BuildContext  context;

  const _PolygonPainter({
    required this.floor,
    required this.imgSize,
    required this.canvasS,
    required this.selectedAId,
    required this.context,
  });

  Offset _px(Offset p) {
    final s  = math.min(canvasS / imgSize.width, canvasS / imgSize.height);
    final ox = (canvasS - imgSize.width  * s) / 2;
    final oy = (canvasS - imgSize.height * s) / 2;
    return Offset(ox + p.dx * s, oy + p.dy * s);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final node in floor.nodes.values) {
      if (node.polygon == null || node.type == NodeType.hallway) continue;

      final pts        = node.polygon!.map(_px).toList();
      final isSelected = selectedAId == node.id;

      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final pt in pts.skip(1)) path.lineTo(pt.dx, pt.dy);
      path.close();

      // Fill when selected
      if (isSelected) {
        canvas.drawPath(path, Paint()
          ..color = _C.roomStart.withOpacity(0.60)
          ..style = PaintingStyle.fill);
      }

      // Outline always
      canvas.drawPath(path, Paint()
        ..color       = isSelected ? _C.roomStartBorder : _C.roomBorder(context)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 2.5 : 1.5);

      // Centroid label
      final cx = pts.map((p) => p.dx).reduce((a, b) => a + b) / pts.length;
      final cy = pts.map((p) => p.dy).reduce((a, b) => a + b) / pts.length;
      final tp = TextPainter(
        text: TextSpan(
          text: node.label,
          style: TextStyle(
            fontSize: 9, fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : _C.roomText(context),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _PolygonPainter old) =>
      old.selectedAId != selectedAId || old.canvasS != canvasS;
}

// ─────────────────────────────────────────────────────────────
//  _FallbackDot  –  small square for rooms without a polygon
// ─────────────────────────────────────────────────────────────
class _FallbackDot extends StatelessWidget {
  final BuildingNode node;
  final bool         isSelected;
  final VoidCallback onTap;

  const _FallbackDot({
    required this.node,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: isSelected ? _C.roomStart : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? _C.roomStartBorder : _C.roomBorder(context),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(node.label,
              style: TextStyle(
                fontSize: 8, fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : _C.roomText(context),
              )),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _StatusBanner  –  tells the user what to tap next
// ─────────────────────────────────────────────────────────────
class _StatusBanner extends StatelessWidget {
  final BuildingNode? selectedA;
  const _StatusBanner({this.selectedA});

  @override
  Widget build(BuildContext context) {
    final picking = selectedA == null;
    final color   = picking ? _C.teal(context) : _C.red(context);
    final label   = picking
        ? 'Tap a room to set your start'
        : 'Start: ${selectedA!.name}  ·  Now tap your destination';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: color.withOpacity(0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(picking ? Icons.my_location : Icons.flag, color: color, size: 15),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold,
                  fontSize: 13, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _FloorTabs
// ─────────────────────────────────────────────────────────────
class _FloorTabs extends StatelessWidget {
  final List<BuildingFloor> floors;
  final int                 currentFloor;
  final ValueChanged<int>   onFloorChanged;

  const _FloorTabs({
    required this.floors,
    required this.currentFloor,
    required this.onFloorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color:   _C.surface(context),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: floors.map((f) {
          final sel = f.floorNumber == currentFloor;
          return Expanded(
            child: GestureDetector(
              onTap: () => onFloorChanged(f.floorNumber),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin:  const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: sel
                      ? _C.accent(context).withOpacity(0.15)
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: sel ? _C.accent(context) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(f.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: sel ? _C.accent(context) : _C.hint(context),
                      fontSize:   12,
                      fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                      letterSpacing: 0.5,
                    )),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
