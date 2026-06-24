// ─────────────────────────────────────────────────────────────
//  room_layout.dart  –  room-selection widget with built-in
//  pathfinding and navigation to DirectionsScreen.
//
//  Usage:
//    RoomLayout(building: buildSTCBuilding())
//
//  Tap a room → start is set.
//  Tap a second room → bottom bar appears with swap + GET DIRECTIONS.
//  GET DIRECTIONS runs findPath and pushes DirectionsScreen.
// ─────────────────────────────────────────────────────────────
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/building.dart';
import '../screens/directions_screen.dart';

// ─────────────────────────────────────────────────────────────
//  Internal color constants — no external theme.dart needed.
// ─────────────────────────────────────────────────────────────
class _C {
  _C._();

  static bool _dark(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark;

  static Color surface(BuildContext ctx) =>
      _dark(ctx) ? const Color(0xFF161B22) : Colors.white;

  static Color border(BuildContext ctx) =>
      _dark(ctx) ? Colors.white12 : Colors.black12;

  static Color accent(BuildContext ctx) =>
      _dark(ctx) ? Colors.cyanAccent : Colors.cyan.shade700;

  static Color teal(BuildContext ctx) =>
      _dark(ctx) ? Colors.tealAccent : Colors.teal.shade600;

  static Color red(BuildContext ctx) =>
      _dark(ctx) ? Colors.redAccent : Colors.red.shade700;

  static Color hint(BuildContext ctx) =>
      _dark(ctx) ? Colors.white38 : Colors.black38;

  static Color roomBorder(BuildContext ctx) =>
      _dark(ctx) ? const Color(0xFF546E7A) : const Color(0xFF90A4AE);

  static Color roomText(BuildContext ctx) =>
      _dark(ctx) ? Colors.blueGrey.shade300 : Colors.blueGrey.shade700;

  // Start room (first tap) — teal
  static const Color roomStart       = Color(0xFF00897B);
  static const Color roomStartBorder = Colors.tealAccent;

  // End room (second tap) — red
  static const Color roomEnd         = Color(0xFFB71C1C);
  static const Color roomEndBorder   = Colors.redAccent;
}

// ─────────────────────────────────────────────────────────────
//  RoomLayout
// ─────────────────────────────────────────────────────────────
class RoomLayout extends StatefulWidget {
  final Building building;

  const RoomLayout({super.key, required this.building});

  @override
  State<RoomLayout> createState() => _RoomLayoutState();
}

class _RoomLayoutState extends State<RoomLayout> {
  int           _currentFloor = 1;
  BuildingNode? _selectedA;
  int?          _floorA;
  BuildingNode? _selectedB;
  int?          _floorB;

  bool get _bothSelected => _selectedA != null && _selectedB != null;

  BuildingFloor get _floor =>
      widget.building.floors.firstWhere((f) => f.floorNumber == _currentFloor);

  void _onRoomTap(BuildingNode node) {
    setState(() {
      if (_selectedA == null) {
        _selectedA = node;
        _floorA    = _currentFloor;
      } else if (_selectedB == null) {
        if (_floorA == _currentFloor && _selectedA!.id == node.id) {
          // Tap start again → deselect it
          _selectedA = null;
          _floorA    = null;
        } else {
          _selectedB = node;
          _floorB    = _currentFloor;
        }
      } else {
        // Both selected: tap either to deselect, tap other to replace end
        if (_floorA == _currentFloor && _selectedA!.id == node.id) {
          _selectedA = null;
          _floorA    = null;
        } else if (_floorB == _currentFloor && _selectedB!.id == node.id) {
          _selectedB = null;
          _floorB    = null;
        } else {
          _selectedB = node;
          _floorB    = _currentFloor;
        }
      }
    });
  }

  void _swap() {
    setState(() {
      final tmpNode  = _selectedA;
      final tmpFloor = _floorA;
      _selectedA = _selectedB;
      _floorA    = _floorB;
      _selectedB = tmpNode;
      _floorB    = tmpFloor;
    });
  }

  void _getDirections() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => DirectionsScreen(
        startBox: _selectedA!.name,
        endBox:   _selectedB!.name,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatusBanner(selectedA: _selectedA, selectedB: _selectedB),
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
                selectedBId: _selectedB?.id,
                onRoomTap:   _onRoomTap,
              ),
            ),
          ),
        ),
        if (_bothSelected)
          _DirectionsBar(
            startName: _selectedA!.name,
            endName:   _selectedB!.name,
            onSwap:    _swap,
            onGo:      _getDirections,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _DirectionsBar  –  shown when both rooms are selected
// ─────────────────────────────────────────────────────────────
class _DirectionsBar extends StatelessWidget {
  final String       startName;
  final String       endName;
  final VoidCallback onSwap;
  final VoidCallback onGo;

  const _DirectionsBar({
    required this.startName,
    required this.endName,
    required this.onSwap,
    required this.onGo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color:  _C.surface(context),
        border: Border(top: BorderSide(color: _C.border(context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: _RoomChip(label: startName, color: _C.teal(context))),
              GestureDetector(
                onTap: onSwap,
                child: Container(
                  margin:     const EdgeInsets.symmetric(horizontal: 8),
                  padding:    const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border:       Border.all(color: _C.border(context)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.swap_horiz,
                      color: _C.hint(context), size: 18),
                ),
              ),
              Expanded(child: _RoomChip(label: endName, color: _C.red(context))),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onGo,
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.accent(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                elevation: 6,
              ),
              child: const Text(
                'GET DIRECTIONS',
                style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold,
                  color: Colors.black, letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomChip extends StatelessWidget {
  final String label;
  final Color  color;
  const _RoomChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color:        color.withAlpha((0.12 * 255).round()),
        borderRadius: BorderRadius.circular(6),
        border:       Border.all(color: color.withAlpha((0.5 * 255).round())),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold, fontSize: 12),
        textAlign:  TextAlign.center,
        maxLines:   2,
        overflow:   TextOverflow.ellipsis,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _RoomMap  –  floor plan image + interactive polygon rooms
// ─────────────────────────────────────────────────────────────
class _RoomMap extends StatefulWidget {
  final BuildingFloor              floor;
  final String?                    selectedAId;
  final String?                    selectedBId;
  final ValueChanged<BuildingNode> onRoomTap;

  const _RoomMap({
    required this.floor,
    required this.selectedAId,
    required this.selectedBId,
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
            Positioned.fill(
              child: Image.asset(
                widget.floor.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                  const ColoredBox(color: Color(0xFF161B22)),
                ),
            ),

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
                      selectedBId: widget.selectedBId,
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
                  node:        node,
                  isStart:     widget.selectedAId == node.id,
                  isEnd:       widget.selectedBId == node.id,
                  onTap:       () => widget.onRoomTap(node),
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
  final String?       selectedBId;
  final BuildContext  context;

  const _PolygonPainter({
    required this.floor,
    required this.imgSize,
    required this.canvasS,
    required this.selectedAId,
    required this.selectedBId,
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

      final pts    = node.polygon!.map(_px).toList();
      final isA    = selectedAId == node.id;
      final isB    = selectedBId == node.id;

      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final pt in pts.skip(1)) {
        path.lineTo(pt.dx, pt.dy);
      }
      path.close();

      if (isA) {
        canvas.drawPath(path, Paint()
          ..color = _C.roomStart.withAlpha((0.60 * 255).round())
          ..style = PaintingStyle.fill);
      } else if (isB) {
        canvas.drawPath(path, Paint()
          ..color = _C.roomEnd.withAlpha((0.55 * 255).round())
          ..style = PaintingStyle.fill);
      }

      canvas.drawPath(path, Paint()
        ..color       = isA ? _C.roomStartBorder
                      : isB ? _C.roomEndBorder
                      : _C.roomBorder(context)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = (isA || isB) ? 2.5 : 1.5);

      final cx = pts.map((p) => p.dx).reduce((a, b) => a + b) / pts.length;
      final cy = pts.map((p) => p.dy).reduce((a, b) => a + b) / pts.length;
      final tp = TextPainter(
        text: TextSpan(
          text: node.label,
          style: TextStyle(
            fontSize: 9, fontWeight: FontWeight.bold,
            color: (isA || isB) ? Colors.white : _C.roomText(context),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _PolygonPainter old) =>
      old.selectedAId != selectedAId ||
      old.selectedBId != selectedBId ||
      old.canvasS     != canvasS;
}

// ─────────────────────────────────────────────────────────────
//  _FallbackDot  –  small square for rooms without a polygon
// ─────────────────────────────────────────────────────────────
class _FallbackDot extends StatelessWidget {
  final BuildingNode node;
  final bool         isStart;
  final bool         isEnd;
  final VoidCallback onTap;

  const _FallbackDot({
    required this.node,
    required this.isStart,
    required this.isEnd,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color fill   = isStart ? _C.roomStart
                       : isEnd   ? _C.roomEnd
                       : Colors.transparent;
    final Color stroke = isStart ? _C.roomStartBorder
                       : isEnd   ? _C.roomEndBorder
                       : _C.roomBorder(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32, height: 32,
        decoration: BoxDecoration(
          color:        fill,
          borderRadius: BorderRadius.circular(4),
          border:       Border.all(color: stroke, width: 1.5),
        ),
        child: Center(
          child: Text(node.label,
              style: TextStyle(
                fontSize: 8, fontWeight: FontWeight.bold,
                color: (isStart || isEnd) ? Colors.white : _C.roomText(context),
              )),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _StatusBanner
// ─────────────────────────────────────────────────────────────
class _StatusBanner extends StatelessWidget {
  final BuildingNode? selectedA;
  final BuildingNode? selectedB;
  const _StatusBanner({this.selectedA, this.selectedB});

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final Color    color;
    final String   label;

    if (selectedA == null) {
      icon  = Icons.my_location;
      color = _C.teal(context);
      label = 'Tap a room to set your start';
    } else if (selectedB == null) {
      icon  = Icons.flag;
      color = _C.red(context);
      label = 'Start: ${selectedA!.name}  ·  Now tap your destination';
    } else {
      icon  = Icons.directions;
      color = _C.accent(context);
      label = '${selectedA!.name}  →  ${selectedB!.name}';
    }

    return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    color:   color.withAlpha((0.08 * 255).round()),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold,
                    fontSize: 13, letterSpacing: 0.5),
                overflow: TextOverflow.ellipsis),
          ),
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
                        ? _C.accent(context).withAlpha((0.15 * 255).round())
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
                      color:      sel ? _C.accent(context) : _C.hint(context),
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
