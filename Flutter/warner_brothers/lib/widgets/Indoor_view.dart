// ─────────────────────────────────────────────────────────────
//  building_map.dart  –  blueprint overlay graph map renderer
// ─────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../models/building.dart';
import '../theme.dart';

class _IndoorViewState extends State<IndoorView>
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
        return Center(
          child: InteractiveViewer(
            transformationController: _transformController,
            minScale: 1,
            maxScale: 2.0,
            child: SizedBox(
              width: 600,
              height: 600,
              child:
                Positioned.fill( //indoor viewer
                  child: Image.asset(
                    'assets/images/${widget.path[widget.highlightStep].nodeId}.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Missing background asset:\n${widget.floor.imagePath}',
                              style: const TextStyle(color: Colors.redAccent, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ),
          ),
        );
      },
    );
  }
}

class IndoorView extends StatefulWidget {
  final BuildingFloor floor;
  final List<NodePosition> path;
  final int highlightStep;
  final String? startId;
  final String? endId;
  final ValueChanged<BuildingNode>? onNodeTap; // null = read-only navigation mode

  const IndoorView({
    Key? key,
    required this.floor,
    required this.path,
    required this.highlightStep,
    this.startId,
    this.endId,
    this.onNodeTap,
  }) : super(key: key);

  @override
  State<IndoorView> createState() => _IndoorViewState();
}
