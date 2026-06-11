// ─────────────────────────────────────────────
//  pathfinding.dart  –  graph BFS & direction text
// ─────────────────────────────────────────────
import 'building.dart';

List<NodePosition> findPath(
  Building building,
  NodePosition start,
  NodePosition end,
) {
  if (start == end) return [start];

  if (start.floor == end.floor) {
    final floor = building.floors.firstWhere((f) => f.floorNumber == start.floor);
    return _bfsOnFloor(floor, start, end);
  }

  // Cross-floor routing (stub — expand when additional floors are added)
  return [];
}

List<NodePosition> _bfsOnFloor(
  BuildingFloor floor,
  NodePosition start,
  NodePosition end,
) {
  if (start == end) return [start];

  // Build reverse adjacency so asymmetric connection data still works
  final reverseAdj = <String, Set<String>>{};
  for (final node in floor.nodes.values) {
    for (final connId in node.connectionIds) {
      reverseAdj.putIfAbsent(connId, () => <String>{}).add(node.id);
    }
  }

  Set<String> neighborsOf(String id) {
    final node = floor.nodes[id];
    if (node == null) return {};
    return {
      ...node.connectionIds,
      ...(reverseAdj[id] ?? <String>{}),
    }.where(floor.nodes.containsKey).toSet();
  }

  final visited = <String>{start.nodeId};
  final queue = <List<NodePosition>>[[start]];

  while (queue.isNotEmpty) {
    final path = queue.removeAt(0);
    final cur = path.last.nodeId;

    for (final nextId in neighborsOf(cur)) {
      if (visited.contains(nextId)) continue;
      visited.add(nextId);
      final next = NodePosition(start.floor, nextId);
      final newPath = [...path, next];
      if (nextId == end.nodeId) return newPath;
      queue.add(newPath);
    }
  }

  return [];
}

// ─────────────────────────────────────────────
//  Direction text generation
// ─────────────────────────────────────────────

List<String> pathToDirections(
  List<NodePosition> path,
  Building building,
) {
  if (path.length < 2) return ['You are already here.'];

  final steps = <String>[];

  for (int i = 0; i < path.length - 1; i++) {
    final cur = path[i];
    final next = path[i + 1];
    final floor = building.floors.firstWhere((f) => f.floorNumber == cur.floor);
    final nextNode = floor.nodes[next.nodeId];
    if (nextNode == null) continue;

    if (cur.floor != next.floor) {
      final curNode = floor.nodes[cur.nodeId];
      final dir = next.floor > cur.floor ? 'up' : 'down';
      steps.add('Take ${curNode?.name ?? 'stairs'} $dir to Floor ${next.floor}');
      continue;
    }

    switch (nextNode.type) {
      case NodeType.elevator:
        steps.add('Take the ${nextNode.name}');
        break;
      case NodeType.stairs:
        steps.add('Head to ${nextNode.name}');
        break;
      case NodeType.hallway:
        steps.add('Head to ${nextNode.name}');
        break;
      case NodeType.room:
        steps.add('Head to ${nextNode.name}');
        break;
    }
  }

  final dest = path.last;
  final destFloor = building.floors.firstWhere((f) => f.floorNumber == dest.floor);
  final destNode = destFloor.nodes[dest.nodeId];
  steps.add('Arrive at ${destNode?.name ?? 'Destination'}');

  return steps;
}
