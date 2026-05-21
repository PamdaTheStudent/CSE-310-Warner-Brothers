// ─────────────────────────────────────────────
//  building.dart  –  graph-based model & pathfinding
// ─────────────────────────────────────────────

enum NodeType { room, hallway, elevator, stairs }

class BuildingNode {
  final String id;
  final String name;
  final NodeType type;
  final double x;
  final double y;
  final List<String> connectionIds;

  const BuildingNode({
    required this.id,
    required this.name,
    required this.type,
    required this.x,
    required this.y,
    required this.connectionIds,
  });

  String get label {
    switch (type) {
      case NodeType.room:     return id;
      case NodeType.elevator: return 'Elev';
      case NodeType.stairs:   return 'Stairs';
      case NodeType.hallway:  return '';
    }
  }
}

class BuildingFloor {
  final int floorNumber;
  final String name;
  final Map<String, BuildingNode> nodes;

  const BuildingFloor({
    required this.floorNumber,
    required this.name,
    required this.nodes,
  });

  List<BuildingNode> get rooms =>
      nodes.values.where((n) => n.type == NodeType.room).toList();
}

class NodePosition {
  final int floor;
  final String nodeId;

  const NodePosition(this.floor, this.nodeId);

  @override
  bool operator ==(Object other) =>
      other is NodePosition && other.floor == floor && other.nodeId == nodeId;

  @override
  int get hashCode => Object.hash(floor, nodeId);

  @override
  String toString() => 'F$floor($nodeId)';
}

// ─────────────────────────────────────────────
//  STC building  (Floor 1 only for now)
// ─────────────────────────────────────────────

List<BuildingFloor> buildSTCBuilding() => [_buildFloor1()];

BuildingFloor _buildFloor1() {
  final nodes = <String, BuildingNode>{};

  void n(String id, String name, NodeType t, double x, double y,
      List<String> c) {
    nodes[id] =
        BuildingNode(id: id, name: name, type: t, x: x, y: y, connectionIds: c);
  }

  // Rooms
  n('161',  'Room 161',  NodeType.room, 25, 18, ['159', '161A', '161B', '161C', 'hw_west_main']);
  n('161A', 'Room 161A', NodeType.room, 18, 22, ['161']);
  n('161B', 'Room 161B', NodeType.room, 18, 18, ['161']);
  n('161C', 'Room 161C', NodeType.room, 18, 12, ['161']);
  n('159',  'Room 159',  NodeType.room, 24, 32, ['155', '161', 'hw_west_main']);
  n('155',  'Room 155',  NodeType.room, 24, 49, ['151', '159', 'hw_west_main']);
  n('151',  'Room 151',  NodeType.room, 24, 66, ['155', 'hw_west_main']);
  n('104',  'Room 104',  NodeType.room, 39, 19, ['104A', '104B', 'hw_west_main']);
  n('104A', 'Room 104A', NodeType.room, 38, 12, ['104']);
  n('104B', 'Room 104B', NodeType.room, 43, 12, ['104']);
  n('106',  'Room 106',  NodeType.room, 35, 31, ['hw_west_main', '108']);
  n('108',  'Room 108',  NodeType.room, 38, 31, ['106', '110']);
  n('110',  'Room 110',  NodeType.room, 41, 31, ['108', 'hw_center']);
  n('108A', 'Room 108A', NodeType.room, 38, 43, ['hw_west_main', '116']);
  n('116',  'Room 116',  NodeType.room, 43, 41, ['108A', 'hw_center']);
  n('152',  'Room 152',  NodeType.room, 39, 56, ['hw_west_main', '148']);
  n('148',  'Room 148',  NodeType.room, 41, 66, ['hw_west_main', '152']);
  n('132',  'Room 132',  NodeType.room, 35, 69, ['hw_west_main', 'hw_south']);
  n('125',  'Room 125',  NodeType.room, 50, 67, ['hw_center']);
  n('129',  'Room 129',  NodeType.room, 38, 79, ['hw_south', '131']);
  n('131',  'Room 131',  NodeType.room, 35, 79, ['hw_south', '129']);
  n('141',  'Room 141',  NodeType.room, 26, 81, ['hw_south']);
  n('145',  'Room 145',  NodeType.room, 21, 85, ['hw_south', 'stairs_southwest']);

  // Hallways
  n('hw_west_main', 'Main West Hallway', NodeType.hallway, 32, 45,
      ['161', '159', '155', '151', '104', '106', '108A', '152', '148', '132', 'hw_south', 'stairs_north']);
  n('hw_center', 'Center Hallway', NodeType.hallway, 46, 45,
      ['110', '116', '125', 'hw_south', 'elev_center']);
  n('hw_south', 'South Hallway', NodeType.hallway, 28, 76,
      ['132', '131', '129', '141', '145', 'hw_west_main', 'hw_center', 'elev_sw']);

  // Elevators
  n('elev_center', 'Central Elevator',   NodeType.elevator, 50, 37, ['hw_center']);
  n('elev_sw',     'Southwest Elevator', NodeType.elevator,  5, 77, ['hw_south']);

  // Stairs
  n('stairs_north',     'North Stairs',     NodeType.stairs, 32, 12, ['161', '104', 'hw_west_main']);
  n('stairs_southwest', 'Southwest Stairs', NodeType.stairs, 10, 88, ['hw_south', '145']);

  return BuildingFloor(floorNumber: 1, name: 'Floor 1', nodes: nodes);
}

// ─────────────────────────────────────────────
//  Graph BFS pathfinding
// ─────────────────────────────────────────────

List<NodePosition> findPath(
  List<BuildingFloor> building,
  NodePosition start,
  NodePosition end,
) {
  if (start == end) return [start];

  if (start.floor == end.floor) {
    final floor = building.firstWhere((f) => f.floorNumber == start.floor);
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
  List<BuildingFloor> building,
) {
  if (path.length < 2) return ['You are already here.'];

  final steps = <String>[];

  for (int i = 0; i < path.length - 1; i++) {
    final cur = path[i];
    final next = path[i + 1];
    final floor = building.firstWhere((f) => f.floorNumber == cur.floor);
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
  final destFloor = building.firstWhere((f) => f.floorNumber == dest.floor);
  final destNode = destFloor.nodes[dest.nodeId];
  steps.add('Arrive at ${destNode?.name ?? 'Destination'}');

  return steps;
}
