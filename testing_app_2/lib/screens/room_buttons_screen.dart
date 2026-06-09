// ─────────────────────────────────────────────────────────────
//  room_buttons_screen.dart  –  tap-two-rooms navigation entry point
//
//  Self-contained: only depends on building.dart, theme.dart, and
//  directions_screen.dart. Can be wired into main.dart independently.
// ─────────────────────────────────────────────────────────────
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/building.dart';
import '../theme.dart';
import 'directions_screen.dart';

class RoomButtonsScreen extends StatefulWidget {
  const RoomButtonsScreen({Key? key}) : super(key: key);

  @override
  State<RoomButtonsScreen> createState() => _RoomButtonsScreenState();
}

class _RoomButtonsScreenState extends State<RoomButtonsScreen> {
  late List<BuildingFloor> _building;
  int _currentFloor = 1;

  // The two rooms the user has tapped. A is always picked first.
  BuildingNode? _selectedA;
  int? _floorA;
  BuildingNode? _selectedB;
  int? _floorB;

  @override
  void initState() {
    super.initState();
    _building = buildSTCBuilding();
  }

  BuildingFloor get _floor =>
      _building.firstWhere((f) => f.floorNumber == _currentFloor);

  // ── Core tap handler ──────────────────────────────────────
  // Called by every room button with its own BuildingNode.
  void _onRoomTap(BuildingNode node) {
    setState(() {
      if (_selectedA == null) {
        // Nothing selected yet — this room becomes the first pick.
        _selectedA = node;
        _floorA = _currentFloor;
      } else if (_floorA == _currentFloor && _selectedA!.id == node.id) {
        // Tapped the already-selected room — deselect it.
        _selectedA = null;
        _floorA = null;
      } else {
        // Second different room tapped — find the path and navigate.
        _selectedB = node;
        _floorB = _currentFloor;
        _findPathAndNavigate();
      }
    });
  }

  // ── Path-finding + navigation ─────────────────────────────
  void _findPathAndNavigate() {
    if (_selectedA == null || _selectedB == null) return;

    final start = NodePosition(_floorA!, _selectedA!.id);
    final end   = NodePosition(_floorB!, _selectedB!.id);

    // Clear selection before pushing so the screen is clean on back-press.
    setState(() {
      _selectedA = null; _floorA = null;
      _selectedB = null; _floorB = null;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DirectionsScreen(
          building: _building,
          start: start,
          end: end,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.scaffold(context),
      appBar: AppBar(
        backgroundColor: Palette.surface(context),
        title: Text(
          'Select Rooms',
          style: TextStyle(
            color: Palette.accent(context),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Palette.accent(context).withOpacity(0.3),
          ),
        ),
      ),
      body: Column(
        children: [
          // Shows which rooms are currently selected.
          _SelectionStatus(selectedA: _selectedA, selectedB: _selectedB),

          // Row of buttons to switch between floors.
          _FloorTabs(
            building: _building,
            currentFloor: _currentFloor,
            onFloorChanged: (f) => setState(() => _currentFloor = f),
          ),

          // The map — floor plan image + interactive room buttons.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.surface(context),
                  border: Border.all(color: Palette.border(context)),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: _RoomMap(
                  floor: _floor,
                  selectedAId: _selectedA?.id,
                  selectedBId: _selectedB?.id,
                  onRoomTap: _onRoomTap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _RoomMap  –  floor plan + polygon room buttons
//
//  Rooms with polygon data are drawn by _PolygonPainter and
//  hit-tested via Path.contains.  Rooms without polygon data
//  fall back to the small square _RoomButton.
// ─────────────────────────────────────────────────────────────
class _RoomMap extends StatefulWidget {
  final BuildingFloor floor;
  final String? selectedAId;
  final String? selectedBId;
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
  // Natural pixel dimensions of the floor plan image.
  // Loaded once in initState — needed to map tracer pixel coords → canvas coords.
  Size? _imgSize;

  @override
  void initState() {
    super.initState();
    _loadImageSize();
  }

  void _loadImageSize() {
    final completer = Completer<Size>();
    const AssetImage('assets/images/stc_floor_1.png')
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((info, _) {
      if (!completer.isCompleted) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }
    }));
    completer.future.then((size) {
      if (mounted) setState(() => _imgSize = size);
    });
  }

  // ── Coordinate conversion ──────────────────────────────────
  // The floor plan image is rendered with BoxFit.contain inside a
  // square canvas of side `canvasS`.  This function maps a point in
  // the image's natural pixel space to that canvas space.
  static Offset _pxToCanvas(Offset px, Size imgSize, double canvasS) {
    // BoxFit.contain scale = fit the whole image inside the square
    final s  = math.min(canvasS / imgSize.width, canvasS / imgSize.height);
    final ox = (canvasS - imgSize.width  * s) / 2;
    final oy = (canvasS - imgSize.height * s) / 2;
    return Offset(ox + px.dx * s, oy + px.dy * s);
  }

  // Returns true if `point` (in canvas coords) falls inside `polygon`
  // (stored in image pixel coords).
  bool _polygonHit(List<Offset> polygon, Offset point, double canvasS) {
    if (_imgSize == null) return false;
    final path = Path();
    final pts  = polygon.map((p) => _pxToCanvas(p, _imgSize!, canvasS)).toList();
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
      final scale  = math.min(
        constraints.maxWidth  / 100,
        constraints.maxHeight / 100,
      );
      final canvasS = 100.0 * scale;

      return InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 5.0,
        child: SizedBox(
          width:  canvasS,
          height: canvasS,
          child: Stack(
            children: [
              // ── 1. Floor plan background ─────────────────
              Positioned.fill(
                child: Image.asset(
                  'assets/images/stc_floor_1.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const ColoredBox(color: Color(0xFF161B22)),
                ),
              ),

              // ── 2. Polygon rooms (traced shapes) ─────────
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

              // ── 3. Fallback dots for un-traced rooms ──────
              ...widget.floor.nodes.values.map((node) {
                if (node.type    == NodeType.hallway) return const SizedBox.shrink();
                if (node.polygon != null)             return const SizedBox.shrink();

                final pos = Offset(node.x * scale, node.y * scale);
                const r   = 16.0;
                return Positioned(
                  left: pos.dx - r,
                  top:  pos.dy - r,
                  child: _RoomButton(
                    node:        node,
                    size:        r * 2,
                    isSelectedA: widget.selectedAId == node.id,
                    isSelectedB: widget.selectedBId == node.id,
                    onTap:       () => widget.onRoomTap(node),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
//  _PolygonPainter  –  draws traced room outlines on the canvas
// ─────────────────────────────────────────────────────────────
class _PolygonPainter extends CustomPainter {
  final BuildingFloor floor;
  final Size imgSize;
  final double canvasS;
  final String? selectedAId;
  final String? selectedBId;
  final BuildContext context;

  const _PolygonPainter({
    required this.floor,
    required this.imgSize,
    required this.canvasS,
    required this.selectedAId,
    required this.selectedBId,
    required this.context,
  });

  // Same conversion as _RoomMapState._pxToCanvas — kept here so the
  // painter is self-contained and doesn't need a reference to the state.
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

      final pts  = node.polygon!.map(_px).toList();
      final isA  = selectedAId == node.id;
      final isB  = selectedBId == node.id;

      // Build the path
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final pt in pts.skip(1)) path.lineTo(pt.dx, pt.dy);
      path.close();

      // Fill — only when selected
      if (isA || isB) {
        canvas.drawPath(path, Paint()
          ..color = (isA ? Palette.cellRoomStart : Palette.cellRoomEnd)
              .withOpacity(0.60)
          ..style = PaintingStyle.fill);
      }

      // Outline — always drawn
      canvas.drawPath(path, Paint()
        ..color = isA ? Palette.cellRoomStartBorder
                : isB ? Palette.cellRoomEndBorder
                : Palette.cellRoomBorder(context)
        ..style       = PaintingStyle.stroke
        ..strokeWidth = isA || isB ? 2.5 : 1.5);

      // Label at centroid
      final cx = pts.map((p) => p.dx).reduce((a, b) => a + b) / pts.length;
      final cy = pts.map((p) => p.dy).reduce((a, b) => a + b) / pts.length;

      final tp = TextPainter(
        text: TextSpan(
          text: node.label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isA || isB ? Colors.white : Palette.cellRoomText(context),
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
      old.selectedBId != selectedBId  ||
      old.canvasS     != canvasS;
}

// ─────────────────────────────────────────────────────────────
//  _RoomButton  –  single tappable room outline
//
//  Default:     outlined, transparent fill
//  Selected A:  teal fill  (first pick)
//  Selected B:  red fill   (second pick — briefly shown before navigation)
// ─────────────────────────────────────────────────────────────
class _RoomButton extends StatelessWidget {
  final BuildingNode node;
  final double size;
  final bool isSelectedA;
  final bool isSelectedB;
  final VoidCallback onTap;

  const _RoomButton({
    required this.node,
    required this.size,
    required this.isSelectedA,
    required this.isSelectedB,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Decide fill + border based on selection state.
    Color fill;
    Color border;
    Color textColor;

    if (isSelectedA) {
      fill      = Palette.cellRoomStart;
      border    = Palette.cellRoomStartBorder;
      textColor = Colors.white;
    } else if (isSelectedB) {
      fill      = Palette.cellRoomEnd;
      border    = Palette.cellRoomEndBorder;
      textColor = Colors.white;
    } else {
      // Outlined / unselected — transparent so the floor plan shows through.
      fill      = Colors.transparent;
      border    = Palette.cellRoomBorder(context);
      textColor = Palette.cellRoomText(context);
    }

    final isCircle = node.type != NodeType.room;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width:  size,
        height: size,
        decoration: BoxDecoration(
          color: fill,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(4),
          border: Border.all(color: border, width: 1.5),
          boxShadow: isSelectedA || isSelectedB
              ? [BoxShadow(color: border.withOpacity(0.5), blurRadius: 6)]
              : null,
        ),
        child: Center(
          child: Text(
            node.label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _SelectionStatus  –  banner showing what's selected so far
// ─────────────────────────────────────────────────────────────
class _SelectionStatus extends StatelessWidget {
  final BuildingNode? selectedA;
  final BuildingNode? selectedB;

  const _SelectionStatus({this.selectedA, this.selectedB});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color  color;

    if (selectedA == null) {
      label = 'Tap a room to set your start';
      color = Palette.accentTeal(context);
    } else {
      label = 'Start: ${selectedA!.name}  ·  Now tap your destination';
      color = Palette.accentRed(context);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: color.withOpacity(0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selectedA == null ? Icons.my_location : Icons.flag,
            color: color,
            size: 15,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  _FloorTabs  –  row of buttons to switch floors
// ─────────────────────────────────────────────────────────────
class _FloorTabs extends StatelessWidget {
  final List<BuildingFloor> building;
  final int currentFloor;
  final ValueChanged<int> onFloorChanged;

  const _FloorTabs({
    required this.building,
    required this.currentFloor,
    required this.onFloorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.surface(context),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: building.map((f) {
          final selected = f.floorNumber == currentFloor;
          return Expanded(
            child: GestureDetector(
              onTap: () => onFloorChanged(f.floorNumber),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? Palette.accent(context).withOpacity(0.15)
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: selected
                          ? Palette.accent(context)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  f.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? Palette.accent(context)
                        : Palette.textHint(context),
                    fontSize: 12,
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
