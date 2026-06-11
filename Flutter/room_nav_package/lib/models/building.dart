// ─────────────────────────────────────────────
//  building.dart  –  graph-based data model
// ─────────────────────────────────────────────
import 'dart:ui' show Offset;

enum NodeType { room, hallway, elevator, stairs }

class BuildingNode {
  final String id;
  final String name;
  final NodeType type;
  final double x;
  final double y;
  final List<String> connectionIds;
  // Optional polygon shape in 0–100 grid coordinates.
  // When provided, the room is drawn as this polygon instead of a small dot.
  final List<Offset>? polygon;

  const BuildingNode({
    required this.id,
    required this.name,
    required this.type,
    required this.x,
    required this.y,
    required this.connectionIds,
    this.polygon,
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
  final int    floorNumber;
  final String name;
  /// Asset path for this floor's background image, e.g.
  /// 'assets/images/stc_floor_1.png'
  final String imagePath;
  final Map<String, BuildingNode> nodes;

  const BuildingFloor({
    required this.floorNumber,
    required this.name,
    required this.imagePath,
    required this.nodes,
  });

  List<BuildingNode> get rooms =>
      nodes.values.where((n) => n.type == NodeType.room).toList();
}

// ── Building ────────────────────────────────────────────────
// A named collection of floors.  Create one of these for each
// physical building and pass it to RoomLayout.
class Building {
  final String id;
  final String name;
  final List<BuildingFloor> floors;

  const Building({
    required this.id,
    required this.name,
    required this.floors,
  });
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

Building buildSTCBuilding() => Building(
  id:     'stc',
  name:   'STC Building',
  floors: [_buildFloor1()],
);

BuildingFloor _buildFloor1() {
  final nodes = <String, BuildingNode>{};

  // Optional trailing parameter accepts a pixel-space polygon from the tracer.
  void n(String id, String name, NodeType t, double x, double y,
      List<String> c, [List<Offset>? poly]) {
    nodes[id] = BuildingNode(
      id: id, name: name, type: t, x: x, y: y,
      connectionIds: c, polygon: poly,
    );
  }

  // Rooms
  n('161',  'Room 161',  NodeType.room, 25, 18, ['159', '161A', '161B', '161C', 'hw_west_main'], const [
    Offset(306, 86),  Offset(307, 223), Offset(440, 220), Offset(440, 196),
    Offset(452, 195), Offset(452, 85),
  ]);
  n('161A', 'Room 161A', NodeType.room, 18, 22, ['161'], const [
    Offset(244, 181), Offset(244, 223), Offset(306, 222), Offset(305, 179),
  ]);
  n('161B', 'Room 161B', NodeType.room, 18, 18, ['161'], const [
    Offset(245, 142), Offset(245, 181), Offset(307, 179), Offset(306, 139),
  ]);
  n('161C', 'Room 161C', NodeType.room, 18, 12, ['161'], const [
    Offset(246, 82),  Offset(244, 136), Offset(306, 138), Offset(307, 83),
  ]);
  n('159',  'Room 159',  NodeType.room, 24, 32, ['155', '161', 'hw_west_main'], const [
    Offset(243, 224), Offset(245, 366), Offset(440, 366), Offset(440, 341),
    Offset(453, 342), Offset(451, 244), Offset(439, 244), Offset(440, 223),
  ]);
  n('155',  'Room 155',  NodeType.room, 24, 49, ['151', '159', 'hw_west_main'], const [
    Offset(439, 367), Offset(440, 387), Offset(449, 387), Offset(450, 485),
    Offset(439, 486), Offset(441, 505), Offset(244, 505), Offset(244, 365),
  ]);
  n('151',  'Room 151',  NodeType.room, 24, 66, ['155', 'hw_west_main'], const [
    Offset(245, 507), Offset(245, 649), Offset(441, 647), Offset(441, 627),
    Offset(453, 626), Offset(454, 528), Offset(441, 527), Offset(442, 507),
  ]);
  n('104',  'Room 104',  NodeType.room, 39, 19, ['104A', '104B', '103', 'hw_west_main'], const [
    Offset(500, 135), Offset(501, 223), Offset(674, 222), Offset(674, 132),
  ]);
  n('104A', 'Room 104A', NodeType.room, 38, 12, ['104'], const [
    Offset(518, 90),  Offset(518, 133), Offset(612, 131), Offset(611, 82),
  ]);
  n('104B', 'Room 104B', NodeType.room, 43, 12, ['104'], const [
    Offset(611, 87),  Offset(612, 132), Offset(671, 131), Offset(669, 81), Offset(611, 82),
  ]);
  n('106',  'Room 106',  NodeType.room, 35, 31, ['hw_west_main', '108'], const [
    Offset(489, 249), Offset(489, 327), Offset(545, 326), Offset(545, 249),
  ]);
  n('108',  'Room 108',  NodeType.room, 38, 31, ['106', '110'], const [
    Offset(591, 249), Offset(591, 327), Offset(545, 326), Offset(545, 249),
  ]);
  n('110',  'Room 110',  NodeType.room, 41, 31, ['108', 'hw_center'], const [
    Offset(591, 250), Offset(591, 327), Offset(632, 327), Offset(633, 249),
  ]);
  n('108A', 'Room 108A', NodeType.room, 38, 43, ['hw_west_main', '116'], const [
    Offset(501, 327), Offset(502, 456), Offset(619, 454), Offset(621, 326),
  ]);
  n('116',  'Room 116',  NodeType.room, 43, 41, ['108A', 'hw_center'], const [
    Offset(621, 329), Offset(621, 415), Offset(672, 416), Offset(673, 326),
  ]);
  n('152',  'Room 152',  NodeType.room, 39, 56, ['hw_west_main', '148'], const [
    Offset(502, 455), Offset(502, 517), Offset(515, 516), Offset(515, 538),
    Offset(674, 539), Offset(674, 454),
  ]);
  n('148',  'Room 148',  NodeType.room, 41, 66, ['hw_west_main', '152'], const [
    Offset(501, 538), Offset(502, 582), Offset(546, 583), Offset(546, 648),
    Offset(674, 648), Offset(674, 536),
  ]);
  n('132',  'Room 132',  NodeType.room, 35, 69, ['hw_west_main', 'hw_south'], const [
    Offset(489, 580), Offset(489, 649), Offset(546, 648), Offset(545, 581),
  ]);
  n('125',  'Room 125',  NodeType.room, 50, 67, ['hw_center'], const [
    Offset(787, 536), Offset(785, 654), Offset(708, 669), Offset(710, 537),
  ]);
  n('129',  'Room 129',  NodeType.room, 38, 79, ['hw_south', '131'], const [
    Offset(543, 674), Offset(544, 731), Offset(582, 722), Offset(583, 674),
  ]);
  n('131',  'Room 131',  NodeType.room, 35, 79, ['hw_south', '129'], const [
    Offset(503, 674), Offset(504, 732), Offset(517, 732), Offset(517, 735),
    Offset(543, 730), Offset(543, 674),
  ]);
  n('141',  'Room 141',  NodeType.room, 26, 81, ['hw_south'], const [
    Offset(409, 685), Offset(408, 754), Offset(395, 757), Offset(357, 757), Offset(357, 683),
  ]);
  n('145',  'Room 145',  NodeType.room, 21, 85, ['hw_south', 'stairs_southwest'], const [
    Offset(328, 744), Offset(334, 768), Offset(356, 764), Offset(355, 739),
  ]);

  // Rooms newly traced (were missing from original model)
  n('101',  'Room 101',  NodeType.room, 49, 13, ['101A'], const [
    Offset(711, 80),  Offset(711, 98),  Offset(764, 98),  Offset(764, 80),
  ]);
  n('101A', 'Room 101A', NodeType.room, 49, 15, ['101', '103'], const [
    Offset(711, 101), Offset(711, 130), Offset(764, 130), Offset(764, 102),
  ]);
  n('103',  'Room 103',  NodeType.room, 49, 18, ['101A', '104'], const [
    Offset(709, 134), Offset(709, 177), Offset(766, 176), Offset(766, 134),
  ]);

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

  return BuildingFloor(
    floorNumber: 1,
    name:        'Floor 1',
    imagePath:   'assets/images/stc_floor_1.png',
    nodes:       nodes,
  );
}

