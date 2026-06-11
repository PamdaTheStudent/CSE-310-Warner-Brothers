# Room Layout Widget — Team Guide

This document explains how the interactive room-selection widget works, how to add new rooms/floors/buildings, and how to plug your own function into it.

---

## How It Works (Big Picture)

The system is split into three independent pieces that you can change without touching each other:

```
1. DATA          2. WIDGET              3. YOUR FUNCTION
building.dart    room_layout.dart       your_screen.dart

Defines rooms,   Draws the floor plan,  Decides what happens
floors, and      handles tapping and    when the user picks
connections.     highlighting.          two rooms.
```

The widget takes two inputs:
- A **Building** object (the data)
- A **function** (what to do when two rooms are picked)

That's it. The widget doesn't care about navigation, directions, or anything else — it just calls your function.

---

## How to Use the Widget

Drop `RoomLayout` anywhere in your app and give it a building and a callback:

```dart
RoomLayout(
  building: buildSTCBuilding(),
  onRoomsSelected: (roomA, floorA, roomB, floorB) {
    // YOUR CODE GOES HERE
    // roomA  = the first room the user tapped  (BuildingNode)
    // floorA = the floor that room is on       (int)
    // roomB  = the second room the user tapped (BuildingNode)
    // floorB = the floor that room is on       (int)
  },
)
```

### What you get in the callback

| Variable | Type | What it is |
|---|---|---|
| `roomA` | `BuildingNode` | First room selected |
| `roomA.id` | `String` | e.g. `"161"` |
| `roomA.name` | `String` | e.g. `"Room 161"` |
| `floorA` | `int` | Floor number, e.g. `1` |
| `roomB` | `BuildingNode` | Second room selected |
| `roomB.id` | `String` | e.g. `"104"` |
| `floorB` | `int` | Floor number, e.g. `1` |

### Example: Navigate to the Directions screen

This is what `room_buttons_screen.dart` already does — the "swap this" comment shows exactly where to put your code:

```dart
void _onRoomsSelected(
  BuildingNode roomA, int floorA,
  BuildingNode roomB, int floorB,
) {
  final start = NodePosition(floorA, roomA.id);
  final end   = NodePosition(floorB, roomB.id);

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
```

### Example: Print to console (for testing)

```dart
onRoomsSelected: (roomA, floorA, roomB, floorB) {
  print('From: ${roomA.name} (Floor $floorA)');
  print('To:   ${roomB.name} (Floor $floorB)');
},
```

### Example: Show a dialog instead

```dart
onRoomsSelected: (roomA, floorA, roomB, floorB) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Rooms Selected'),
      content: Text('${roomA.name} → ${roomB.name}'),
    ),
  );
},
```

---

## How to Add Rooms

Open `lib/models/building.dart` and find `_buildFloor1()`.

Every room is one line using the `n(...)` helper:

```dart
n(
  '161',                    // Unique ID — must be a string, no spaces
  'Room 161',               // Display name shown in the UI
  NodeType.room,            // See node types below
  25, 18,                   // x, y — rough position on a 0-100 grid
  ['hw_west_main', '159'],  // List of connected node IDs (for pathfinding)
  const [                   // Polygon shape — pixel coordinates from the tracer
    Offset(306, 86),
    Offset(307, 223),
    Offset(440, 220),
    Offset(452, 85),
  ],
);
```

**Node types:**

| Type | Use for |
|---|---|
| `NodeType.room` | A tappable room |
| `NodeType.hallway` | A corridor/walkway (not tappable, used for routing) |
| `NodeType.elevator` | An elevator |
| `NodeType.stairs` | A staircase |

**Tips:**
- The polygon coordinates come from `room_tracer.html` — open that file in a browser, load your floor plan image, and click around each room to get the coordinates.
- If you skip the polygon, the room shows as a small dot at the x/y position instead.
- Always connect a new room to at least one hallway node so the pathfinder can reach it.

---

## How to Add a New Floor

**Step 1** — Add a new image to `assets/images/` (e.g. `stc_floor_2.png`)

**Step 2** — Register it in `pubspec.yaml` under `assets:`:
```yaml
assets:
  - assets/images/stc_floor_1.png
  - assets/images/stc_floor_2.png   # add this
```

**Step 3** — Create a new builder function in `building.dart`, right below `_buildFloor1()`:

```dart
BuildingFloor _buildFloor2() {
  final nodes = <String, BuildingNode>{};

  void n(String id, String name, NodeType t, double x, double y,
      List<String> c, [List<Offset>? poly]) {
    nodes[id] = BuildingNode(
      id: id, name: name, type: t, x: x, y: y,
      connectionIds: c, polygon: poly,
    );
  }

  // Add your rooms here using the same n(...) pattern
  n('201', 'Room 201', NodeType.room, 25, 20, ['hw_f2_main'], const [
    Offset(300, 80), Offset(300, 200), Offset(450, 200), Offset(450, 80),
  ]);

  n('hw_f2_main', 'Floor 2 Hallway', NodeType.hallway, 50, 50, ['201']);

  return BuildingFloor(
    floorNumber: 2,
    name: 'Floor 2',
    imagePath: 'assets/images/stc_floor_2.png',
    nodes: nodes,
  );
}
```

**Step 4** — Add it to the building:

```dart
Building buildSTCBuilding() => Building(
  id: 'stc',
  name: 'STC Building',
  floors: [_buildFloor1(), _buildFloor2()],  // add _buildFloor2() here
);
```

The floor tabs in the widget appear **automatically** — no UI changes needed.

---

## How to Add a New Building

Create a new file (e.g. `lib/models/library_building.dart`) and follow the same pattern:

```dart
import 'dart:ui' show Offset;
import 'building.dart';

Building buildLibraryBuilding() => Building(
  id: 'library',
  name: 'Library',
  floors: [_buildLibFloor1()],
);

BuildingFloor _buildLibFloor1() {
  final nodes = <String, BuildingNode>{};

  void n(String id, String name, NodeType t, double x, double y,
      List<String> c, [List<Offset>? poly]) {
    nodes[id] = BuildingNode(
      id: id, name: name, type: t, x: x, y: y,
      connectionIds: c, polygon: poly,
    );
  }

  // Define rooms here...

  return BuildingFloor(
    floorNumber: 1,
    name: 'Floor 1',
    imagePath: 'assets/images/library_floor_1.png',
    nodes: nodes,
  );
}
```

Then use it in any screen by passing the different building to `RoomLayout`:

```dart
RoomLayout(
  building: buildLibraryBuilding(),  // just swap this
  onRoomsSelected: _onRoomsSelected,
)
```

Nothing else changes.

---

## File Map

```
lib/
├── models/
│   └── building.dart         ← ADD ROOMS / FLOORS / BUILDINGS here
│
├── widgets/
│   └── room_layout.dart      ← the reusable widget (don't need to touch this)
│
├── screens/
│   ├── room_buttons_screen.dart   ← CHANGE THE FUNCTION here
│   ├── directions_screen.dart     ← directions UI
│   └── selection_screen.dart      ← map-tap selection UI
│
└── main.dart                 ← sets the starting screen

room_tracer.html              ← open in browser to trace room polygons
```

---

## Quick Reference

| I want to... | File to open | What to change |
|---|---|---|
| Add a room | `building.dart` | Add an `n(...)` call inside the floor function |
| Add a floor | `building.dart` | New `_buildFloorN()` function + add to `floors: [...]` |
| Add a building | New `models/xyz_building.dart` | Copy the pattern, change IDs and image paths |
| Change what happens when 2 rooms are picked | `room_buttons_screen.dart` | Replace the body of `_onRoomsSelected` |
| Change colors / style | `room_layout.dart` | Edit `_PolygonPainter.paint()` |
| Trace new room polygons | `room_tracer.html` | Open in browser, load floor plan, click corners |
