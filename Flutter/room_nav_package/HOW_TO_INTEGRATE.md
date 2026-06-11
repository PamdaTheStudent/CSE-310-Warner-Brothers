# How to Integrate the Room Navigation Widget

This package gives you an interactive floor-plan widget for any Flutter app.  
The whole thing is **two Dart files** — drop them in and you're done.

---

## What's in This Folder

```
room_nav_package/
│
├── lib/
│   ├── models/
│   │   └── building.dart       ← data model + pathfinding (copy this)
│   └── widgets/
│       └── room_layout.dart    ← the interactive widget (copy this)
│
├── room_tracer.html             ← open in a browser to trace room polygons
├── ROOM_LAYOUT_GUIDE.md         ← full feature reference
└── HOW_TO_INTEGRATE.md          ← this file
```

---

## Step 1 — Copy the Two Dart Files

Copy these into your Flutter project, keeping the same folder structure:

```
your_project/
└── lib/
    ├── models/
    │   └── building.dart       ← copy here
    └── widgets/
        └── room_layout.dart    ← copy here
```

> **Note:** If you already have a `models/` or `widgets/` folder, just drop the files in.  
> The two files only import from each other and from Flutter — no other dependencies.

---

## Step 2 — Add Your Floor Plan Images

Put your floor plan image(s) in `assets/images/`:

```
your_project/
└── assets/
    └── images/
        └── my_floor_1.png    ← your floor plan here
```

Then register the folder in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

---

## Step 3 — Use the Widget

In any screen, import the two files and drop in `RoomLayout`:

```dart
import '../models/building.dart';
import '../widgets/room_layout.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {

  // ── The only function you need to write ──────────────────
  void _onRoomsSelected(
    BuildingNode roomA, int floorA,
    BuildingNode roomB, int floorB,
  ) {
    // roomA.id, roomA.name, floorA — first room picked
    // roomB.id, roomB.name, floorB — second room picked

    // Example: just print them
    print('From ${roomA.name} (floor $floorA) → ${roomB.name} (floor $floorB)');

    // Example: navigate somewhere
    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ...));
  }
  // ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick a Room')),
      body: RoomLayout(
        building: buildMyBuilding(),      // your building data function
        onRoomsSelected: _onRoomsSelected,
      ),
    );
  }
}
```

That's the whole integration. **The widget handles everything else** — drawing the floor plan, highlighting tapped rooms, switching floors, and calling your function when two rooms are selected.

---

## Step 4 — Define Your Building

In `building.dart`, add a new builder function for your building.  
Each room needs an ID, a name, and a list of polygon coordinates (pixel coords from your floor plan image).

```dart
Building buildMyBuilding() => Building(
  id:     'my_building',
  name:   'My Building',
  floors: [_buildMyFloor1()],
);

BuildingFloor _buildMyFloor1() {
  final nodes = <String, BuildingNode>{};

  // Helper shorthand
  void n(String id, String name, NodeType t, double x, double y,
      List<String> connections, [List<Offset>? polygon]) {
    nodes[id] = BuildingNode(
      id: id, name: name, type: t, x: x, y: y,
      connectionIds: connections, polygon: polygon,
    );
  }

  // ── Rooms ─────────────────────────────────────────────────
  // Get polygon coordinates using room_tracer.html
  n('101', 'Room 101', NodeType.room, 25, 20, ['main_hall'], const [
    Offset(300, 80), Offset(300, 200), Offset(450, 200), Offset(450, 80),
  ]);

  n('102', 'Room 102', NodeType.room, 50, 20, ['main_hall'], const [
    Offset(460, 80), Offset(460, 200), Offset(600, 200), Offset(600, 80),
  ]);

  // ── Hallway (invisible — used only for routing) ────────────
  n('main_hall', 'Main Hallway', NodeType.hallway, 40, 50,
      ['101', '102']);

  return BuildingFloor(
    floorNumber: 1,
    name:        'Floor 1',
    imagePath:   'assets/images/my_floor_1.png',
    nodes:       nodes,
  );
}
```

### Getting Polygon Coordinates

Open `room_tracer.html` in any browser:
1. Load your floor plan image using the file picker
2. Type a room ID in the **Room ID** box (e.g. `101`)
3. Click around the room's corners on the image
4. Click **✔ Finish Room** — the `Offset(x, y)` list is printed in the sidebar
5. Copy and paste into your `n(...)` call

---

## Step 5 — Add More Floors (Optional)

```dart
Building buildMyBuilding() => Building(
  id:     'my_building',
  name:   'My Building',
  floors: [_buildMyFloor1(), _buildMyFloor2()],  // ← add floors here
);
```

The floor tabs appear **automatically** in the widget — no UI code needed.

---

## Quick Checklist

- [ ] Copied `building.dart` into `lib/models/`
- [ ] Copied `room_layout.dart` into `lib/widgets/`
- [ ] Added floor plan image to `assets/images/`
- [ ] Registered `assets/images/` in `pubspec.yaml`
- [ ] Created a `buildXxxBuilding()` function with at least one floor and one hallway node
- [ ] Connected all rooms to at least one hallway via `connectionIds`
- [ ] Added `RoomLayout(building: ..., onRoomsSelected: ...)` to a screen
- [ ] Wrote your `onRoomsSelected` function

---

## Common Mistakes

| Mistake | Fix |
|---|---|
| Rooms don't show as polygons, just dots | Polygon missing or coordinates are wrong — re-trace with `room_tracer.html` |
| Image not loading | Check `pubspec.yaml` has the asset path; run `flutter pub get` |
| Pathfinding returns empty | Room is not connected to any hallway via `connectionIds` |
| App crashes on floor switch | Second floor's `imagePath` doesn't exist in assets |
| Nothing happens when two rooms are tapped | Your `onRoomsSelected` function body is empty — add your code there |
