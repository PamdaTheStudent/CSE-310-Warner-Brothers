// ─────────────────────────────────────────────
//  directions_screen.dart  –  navigation instructions
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../models/building.dart';
import '../models/pathfinding.dart';
import '../theme.dart';
import '../widgets/building_map.dart';
import '../widgets/Indoor_view.dart';
import '../screens/in-door_screen.dart';

class DirectionsScreen extends StatefulWidget {
  final Building building;
  final NodePosition start;
  final NodePosition end;
  final bool indoor = false;

  const DirectionsScreen({
    super.key,
    required this.building,
    required this.start,
    required this.end,
  });

  @override
  State<DirectionsScreen> createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen>
    with TickerProviderStateMixin {
  late List<NodePosition> _path;
  late List<String> _steps;
  late int _currentStep = 0;
  late int _displayedFloor;
  late bool _indoor = false;
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _path = findPath(widget.building, widget.start, widget.end);
    _steps = pathToDirections(_path, widget.building);
    _displayedFloor = widget.start.floor;
    _indoor = widget.indoor;
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  BuildingFloor get _currentFloor =>
      widget.building.floors.firstWhere((f) => f.floorNumber == _displayedFloor);

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
        _displayedFloor = _path[_currentStep].floor;
        _slideCtrl.forward(from: 0.0);
      });
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _displayedFloor = _path[_currentStep].floor;
        _slideCtrl.forward(from: 0.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DIRECTIONS', style: TextStyle(letterSpacing: 2, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Floor tab switcher
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.building.floors.map((f) {
                  final isCurrent = f.floorNumber == _displayedFloor;
                  return GestureDetector(
                    onTap: () => setState(() => _displayedFloor = f.floorNumber),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isCurrent ? Palette.accent(context) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isCurrent ? Palette.accent(context) : Palette.border(context)),
                      ),
                      child: Text(
                        f.name.toUpperCase(),
                        style: TextStyle(
                          color: isCurrent ? Colors.black : Palette.textSecondary(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                    ),
                  );
                }).toList(),
              ),
            ),

            // Map Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(4),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Palette.surface(context),
                  border: Border.all(color: Palette.borderSubtle(context)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: _indoor?
                      IndoorView(
                          floor: _currentFloor,
                          path: _path,
                          highlightStep: _currentStep
                      ) : BuildingMap(
                        floor: _currentFloor,
                        path: _path,
                        highlightStep: _currentStep,
                        startId: widget.start.nodeId,
                        endId: widget.end.nodeId,
                        indoor: _indoor,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Material(
                        color: Palette.surface(context).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),

                        child: IconButton(
                          icon: Icon(Icons.image_outlined,
                              color: Palette.accent(context)),
                          tooltip: 'Open Room View',
                          onPressed: () {
                            setState(() {
                              _indoor = !_indoor;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Card Instructions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(top: BorderSide(color: Palette.borderSubtle(context))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STEP ${_currentStep + 1} OF ${_steps.length}',
                        style: TextStyle(color: Palette.textHint(context), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      if (_path.isNotEmpty)
                        Text(
                          'FLOOR ${_path[_currentStep].floor}',
                          style: TextStyle(color: Palette.accent(context), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Text(
                        _steps.isEmpty ? 'No instructions available.' : _steps[_currentStep],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _NavButton(
                          label: 'BACK',
                          icon: Icons.arrow_back,
                          enabled: _currentStep > 0,
                          onTap: _prevStep,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _NavButton(
                          label: _currentStep == _steps.length - 1 ? 'ARRIVED' : 'NEXT',
                          icon: _currentStep == _steps.length - 1 ? Icons.check : Icons.arrow_forward,
                          enabled: _currentStep < _steps.length - 1,
                          isPrimary: true,
                          onTap: _nextStep,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final bool isPrimary;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.enabled,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPrimary ? Palette.accent(context) : Palette.textSecondary(context);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.3,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isPrimary ? color.withOpacity(0.1) : Colors.transparent,
            border: Border.all(color: isPrimary ? color : Palette.borderSubtle(context)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isPrimary) ...[
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 13),
              ),
              if (isPrimary && enabled && label != 'ARRIVED') ...[
                const SizedBox(width: 8),
                Icon(icon, color: color, size: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

