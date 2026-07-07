import 'dart:ui' show Offset;

// ── AreaType ──────────────────────────────────────────────────
// Controls how a polygon is colored on the map.
enum AreaType { room, staircase, elevator }

// ── NavNode ───────────────────────────────────────────────────
// A single waypoint in a floor's pathfinding graph.
// position is in raw pixel coordinates matching the floor's image asset.
class NavNode {
  final String       id;
  final Offset       position;
  final List<String> neighbors;

  const NavNode({
    required this.id,
    required this.position,
    required this.neighbors,
  });
}

// ── RoomPolygon ───────────────────────────────────────────────
// The tappable shape of a room, staircase, or elevator.
// pixels are raw pixel coordinates matching the floor's image asset.
// type defaults to AreaType.room so existing entries need no changes.
class RoomPolygon {
  final String       id;
  final String       name;
  final AreaType     type;
  final List<Offset> pixels;

  const RoomPolygon({
    required this.id,
    required this.name,
    this.type = AreaType.room,
    required this.pixels,
  });
}

// ── CrossFloorLink ────────────────────────────────────────────
// Connects a nav node on one floor to a nav node on another floor.
// Add one link per direction (up and down are separate entries).
class CrossFloorLink {
  final int    fromFloor;
  final String fromNodeId;
  final int    toFloor;
  final String toNodeId;

  const CrossFloorLink({
    required this.fromFloor,
    required this.fromNodeId,
    required this.toFloor,
    required this.toNodeId,
  });
}

// ── PathStep ─────────────────────────────────────────────────
// One waypoint in a resolved route, carrying its floor so the
// map can auto-switch floors as the user steps through.
class PathStep {
  final int    floor;
  final String nodeId;
  final Offset position;

  const PathStep({
    required this.floor,
    required this.nodeId,
    required this.position,
  });
}

// ── FloorData ─────────────────────────────────────────────────
// Everything needed to display and navigate one floor.
class FloorData {
  final int                       floorNumber;
  final String                    name;
  final String                    imagePath;
  /// Native pixel dimensions of the floor plan image asset.
  /// Used to convert polygon/node pixel coords to screen coords.
  final double                    nativeWidth;
  final double                    nativeHeight;
  final List<RoomPolygon>         rooms;
  final Map<String, NavNode>      navNodes;
  final Map<String, List<String>> roomToNode;   // room id → door node ids
  final List<Offset>?             buildingOutline;

  const FloorData({
    required this.floorNumber,
    required this.name,
    required this.imagePath,
    this.nativeWidth  = 1201.0,
    this.nativeHeight = 666.0,
    required this.rooms,
    required this.navNodes,
    required this.roomToNode,
    this.buildingOutline,
  });
}

// ── BuildingData ──────────────────────────────────────────────
// A named building containing one or more floors and the
// cross-floor links that connect staircase/elevator nodes.
class BuildingData {
  final String               id;
  final String               name;
  final List<FloorData>      floors;
  final List<CrossFloorLink> crossFloorLinks;

  const BuildingData({
    required this.id,
    required this.name,
    required this.floors,
    this.crossFloorLinks = const [],
  });

  FloorData? floor(int number) {
    for (final f in floors) {
      if (f.floorNumber == number) return f;
    }
    return null;
  }
}
