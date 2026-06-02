// ─────────────────────────────────────────────
//  selection_screen.dart
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../models/building.dart';
import '../theme.dart';
import '../widgets/building_map.dart';
import 'directions_screen.dart';

enum _PickMode { start, end }

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  late List<BuildingFloor> _building;
  int _displayedFloor = 1;
  BuildingNode? _startNode;
  int? _startFloorNum;
  BuildingNode? _endNode;
  int? _endFloorNum;
  _PickMode _mode = _PickMode.start;

  @override
  void initState() {
    super.initState();
    _building = buildSTCBuilding();
  }

  BuildingFloor get _currentFloor =>
      _building.firstWhere((f) => f.floorNumber == _displayedFloor);

  bool get _canProceed =>
      _startNode != null &&
      _endNode != null &&
      !(_startFloorNum == _endFloorNum && _startNode!.id == _endNode!.id);

  void _onNodeTap(BuildingNode node) {
    setState(() {
      if (_mode == _PickMode.start) {
        _startNode = node;
        _startFloorNum = _displayedFloor;
        if (_endFloorNum == _displayedFloor && _endNode?.id == node.id) {
          _endNode = null;
          _endFloorNum = null;
        }
        _mode = _PickMode.end;
      } else {
        if (_startFloorNum == _displayedFloor && _startNode?.id == node.id) {
          return;
        }
        _endNode = node;
        _endFloorNum = _displayedFloor;
      }
    });
  }

  void _swap() {
    setState(() {
      final tmpNode = _startNode;
      final tmpFloor = _startFloorNum;
      _startNode = _endNode;
      _startFloorNum = _endFloorNum;
      _endNode = tmpNode;
      _endFloorNum = tmpFloor;
      if (_startNode == null) _mode = _PickMode.start;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final startPos = _startNode != null
        ? NodePosition(_startFloorNum!, _startNode!.id)
        : null;
    final endPos = _endNode != null
        ? NodePosition(_endFloorNum!, _endNode!.id)
        : null;

    return Scaffold(
      backgroundColor: Palette.scaffold(context),
      appBar: AppBar(
        backgroundColor: Palette.surface(context),
        title: Text(
          'Building Navigator',
          style: TextStyle(
            color: Palette.accent(context),
            fontWeight: FontWeight.bold,
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
            onPressed: () {
              themeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
              height: 1, color: Palette.accent(context).withOpacity(0.3)),
        ),
      ),
      body: Column(
        children: [
          _ModeIndicator(mode: _mode),
          _FloorTabs(
            building: _building,
            selectedFloor: _displayedFloor,
            onFloorTap: (f) => setState(() => _displayedFloor = f),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Palette.surface(context),
                  border: Border.all(color: Palette.border(context)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: BuildingMap(
                        floor: _currentFloor,
                        path: const [],
                        highlightStep: -1,
                        startId: startPos?.nodeId,
                        endId: endPos?.nodeId,
                        onNodeTap: _onNodeTap,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Material(
                        color: Palette.surface(context).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _SelectionSummary(
            startLabel: _startNode != null
                ? '${_building.firstWhere((f) => f.floorNumber == _startFloorNum!).name}  ·  ${_startNode!.name}'
                : null,
            endLabel: _endNode != null
                ? '${_building.firstWhere((f) => f.floorNumber == _endFloorNum!).name}  ·  ${_endNode!.name}'
                : null,
            mode: _mode,
            canSwap: _startNode != null || _endNode != null,
            canProceed: _canProceed,
            onModeChange: (m) => setState(() => _mode = m),
            onSwap: _swap,
            onGo: _canProceed
                ? () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DirectionsScreen(
                          building: _building,
                          start: startPos!,
                          end: endPos!,
                        ),
                      ),
                    )
                : null,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Mode indicator banner
// ─────────────────────────────────────────────
class _ModeIndicator extends StatelessWidget {
  final _PickMode mode;
  const _ModeIndicator({required this.mode});

  @override
  Widget build(BuildContext context) {
    final isStart = mode == _PickMode.start;
    final color =
        isStart ? Palette.accentTeal(context) : Palette.accentRed(context);
    final label =
        isStart ? 'Tap a room to set Start' : 'Tap a room to set End';
    final icon = isStart ? Icons.my_location : Icons.flag;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: color.withOpacity(0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 15),
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

// ─────────────────────────────────────────────
//  Floor tab bar
// ─────────────────────────────────────────────
class _FloorTabs extends StatelessWidget {
  final List<BuildingFloor> building;
  final int selectedFloor;
  final ValueChanged<int> onFloorTap;

  const _FloorTabs({
    required this.building,
    required this.selectedFloor,
    required this.onFloorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.surface(context),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: building.map((f) {
          final selected = f.floorNumber == selectedFloor;
          return Expanded(
            child: GestureDetector(
              onTap: () => onFloorTap(f.floorNumber),
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

// ─────────────────────────────────────────────
//  Bottom summary: chips + swap + go
// ─────────────────────────────────────────────
class _SelectionSummary extends StatelessWidget {
  final String? startLabel;
  final String? endLabel;
  final _PickMode mode;
  final bool canSwap;
  final bool canProceed;
  final ValueChanged<_PickMode> onModeChange;
  final VoidCallback onSwap;
  final VoidCallback? onGo;

  const _SelectionSummary({
    required this.startLabel,
    required this.endLabel,
    required this.mode,
    required this.canSwap,
    required this.canProceed,
    required this.onModeChange,
    required this.onSwap,
    required this.onGo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Palette.surface(context),
        border: Border(top: BorderSide(color: Palette.border(context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onModeChange(_PickMode.start),
                  child: _LocationChip(
                    label: startLabel ?? 'Start',
                    sublabel: startLabel == null ? 'Tap to pick' : null,
                    color: Palette.accentTeal(context),
                    isActive: mode == _PickMode.start,
                    isEmpty: startLabel == null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: canSwap ? onSwap : null,
                  child: AnimatedOpacity(
                    opacity: canSwap ? 1.0 : 0.3,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Palette.borderSubtle(context)),
                        borderRadius: BorderRadius.circular(20),
                        color: Palette.overlayBg(context),
                      ),
                      child: Icon(Icons.swap_horiz,
                          color: Palette.textSecondary(context), size: 18),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onModeChange(_PickMode.end),
                  child: _LocationChip(
                    label: endLabel ?? 'End',
                    sublabel: endLabel == null ? 'Tap to pick' : null,
                    color: Palette.accentRed(context),
                    isActive: mode == _PickMode.end,
                    isEmpty: endLabel == null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedOpacity(
            opacity: canProceed ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              onPressed: onGo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.accent(context),
                disabledBackgroundColor: Palette.accent(context),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: canProceed ? 8 : 0,
                shadowColor: Palette.accent(context).withOpacity(0.4),
              ),
              child: const Text(
                'GET DIRECTIONS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  final String label;
  final String? sublabel;
  final Color color;
  final bool isActive;
  final bool isEmpty;

  const _LocationChip({
    required this.label,
    required this.color,
    required this.isActive,
    required this.isEmpty,
    this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? color.withOpacity(0.15)
            : (isEmpty ? Colors.transparent : color.withOpacity(0.08)),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive
              ? color
              : (isEmpty ? Palette.border(context) : color.withOpacity(0.4)),
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isEmpty ? Palette.textHint(context) : color,
              fontWeight: isEmpty ? FontWeight.normal : FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (sublabel != null) ...[
            const SizedBox(height: 2),
            Text(
              sublabel!,
              style: TextStyle(
                  color: Palette.textDisabled(context), fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
