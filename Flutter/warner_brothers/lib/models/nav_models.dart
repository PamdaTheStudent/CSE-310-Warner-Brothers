import 'dart:ui' show Offset;

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
// The tappable shape of a room, traced from the floor plan image.
// pixels are raw pixel coordinates matching the floor's image asset.
class RoomPolygon {
  final String       id;
  final String       name;
  final List<Offset> pixels;

  const RoomPolygon({
    required this.id,
    required this.name,
    required this.pixels,
  });
}

// ── FloorData ─────────────────────────────────────────────────
// Everything needed to display and navigate one floor.
class FloorData {
  final int                    floorNumber;
  final String                 name;
  final String                 imagePath;      // asset path for the floor plan image
  final List<RoomPolygon>      rooms;          // tappable room polygons
  final Map<String, NavNode>   navNodes;       // pathfinding graph
  final Map<String, String>    roomToNode;     // room id → nav node id

  const FloorData({
    required this.floorNumber,
    required this.name,
    required this.imagePath,
    required this.rooms,
    required this.navNodes,
    required this.roomToNode,
  });
}

// ── BuildingData ──────────────────────────────────────────────
// A named building containing one or more floors.
class BuildingData {
  final String          id;
  final String          name;
  final List<FloorData> floors;

  const BuildingData({
    required this.id,
    required this.name,
    required this.floors,
  });

  FloorData? floor(int number) {
    for (final f in floors) {
      if (f.floorNumber == number) return f;
    }
    return null;
  }
}
