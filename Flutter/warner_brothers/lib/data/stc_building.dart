import 'dart:ui' show Offset;
import '../models/nav_models.dart';

// ─────────────────────────────────────────────────────────────
//  STC Building
//
//  One file per building.  Add a new FloorData entry below for
//  each floor you map.  Floors 1 and 2 are stubs ready to fill.
//
//  POLYGON PIXEL COORDS — traced from each floor's image asset.
//  NAV NODE PIXEL COORDS — placed on each floor's image asset.
//    x = pixels from left edge of image
//    y = pixels from top edge of image
// ─────────────────────────────────────────────────────────────

final BuildingData stcBuilding = BuildingData(
  id:     'STC',
  name:   'STC Building',
  floors: [_floor1, _floor2, _floor3],
);

// ── Floor 1 ───────────────────────────────────────────────────
// Polygons and nav nodes to be added.
final FloorData _floor1 = FloorData(
  floorNumber: 1,
  name:        'Floor 1',
  imagePath:   'assets/images/stc_floor_1.png',
  rooms:       const [],   // TODO: add RoomPolygon entries
  navNodes:    const {},   // TODO: add NavNode entries
  roomToNode:  const {},   // TODO: map room ids to nav node ids
);

// ── Floor 2 ───────────────────────────────────────────────────
// Polygons and nav nodes to be added.
final FloorData _floor2 = FloorData(
  floorNumber: 2,
  name:        'Floor 2',
  imagePath:   'assets/images/stc_floor_2.png',
  rooms:       const [],
  navNodes:    const {},
  roomToNode:  const {},
);

// ── Floor 3 ───────────────────────────────────────────────────
final FloorData _floor3 = FloorData(
  floorNumber: 3,
  name:        'Floor 3',
  imagePath:   'assets/map.png',

  // ── Room polygons ──────────────────────────────────────────
  rooms: const [

    RoomPolygon(id: '341', name: 'Room 341', pixels: [
      Offset(166, 150), Offset(163, 307), Offset(284, 305),
      Offset(281, 281), Offset(292, 280), Offset(292, 172),
      Offset(282, 172), Offset(281, 149),
    ]),

    RoomPolygon(id: '347', name: 'Room 347', pixels: [
      Offset(164,  32), Offset(166, 149), Offset(282, 149),
      Offset(282, 115), Offset(292, 115), Offset(290,  55),
      Offset(281,  57), Offset(280,  32),
    ]),

    RoomPolygon(id: '353', name: 'Room 353', pixels: [
      Offset(319, 33), Offset(320, 159),
      Offset(442, 158), Offset(443, 32),
    ]),

    RoomPolygon(id: '361', name: 'Room 361', pixels: [
      Offset(444,  31), Offset(443, 158), Offset(461, 157),
      Offset(461, 170), Offset(551, 171), Offset(551, 157),
      Offset(575, 157), Offset(576,  31),
    ]),

    RoomPolygon(id: '367', name: 'Room 367', pixels: [
      Offset(576,  32), Offset(576, 159), Offset(597, 160),
      Offset(599, 169), Offset(685, 169), Offset(686, 159),
      Offset(703, 158), Offset(704,  31),
    ]),

    RoomPolygon(id: '342', name: 'Room 342', pixels: [
      Offset(337, 241), Offset(349, 303), Offset(397, 303),
      Offset(397, 278), Offset(394, 263), Offset(386, 252),
      Offset(376, 244), Offset(363, 239),
    ]),

    RoomPolygon(id: '356', name: 'Room 356', pixels: [
      Offset(397, 205), Offset(398, 299), Offset(404, 303),
      Offset(528, 302), Offset(528, 204), Offset(506, 203),
      Offset(507, 214), Offset(421, 213), Offset(420, 205),
    ]),

    RoomPolygon(id: '362', name: 'Room 362', pixels: [
      Offset(527, 198), Offset(528, 303), Offset(567, 303),
      Offset(567, 220), Offset(549, 219), Offset(547, 196),
    ]),

    // TODO: confirm the room number for this small south-corridor room
    RoomPolygon(id: '367_south', name: 'Room 367 (South)', pixels: [
      Offset(601, 233), Offset(601, 258),
      Offset(624, 259), Offset(625, 231),
    ]),

    RoomPolygon(id: '375', name: 'Room 375', pixels: [
      Offset(751, 189), Offset(754, 214), Offset(754, 302),
      Offset(862, 300), Offset(862, 184),
    ]),

    RoomPolygon(id: '385', name: 'Room 385', pixels: [
      Offset(754,  70), Offset(755,  85), Offset(750,  87),
      Offset(748, 157), Offset(751, 156), Offset(754, 185),
      Offset(863, 178), Offset(863,  67),
    ]),

    RoomPolygon(id: '394', name: 'Room 394', pixels: [
      Offset(864,  66), Offset(863, 185), Offset(969, 182),
      Offset(971, 156), Offset(978, 156), Offset(977,  87),
      Offset(972,  86), Offset(971,  69),
    ]),

    RoomPolygon(id: '393', name: 'Room 393', pixels: [
      Offset(1010, 114), Offset(1009, 179),
      Offset(1054, 178), Offset(1052, 111),
    ]),

    RoomPolygon(id: '398', name: 'Room 398', pixels: [
      Offset(862, 188), Offset(863, 302), Offset(970, 302),
      Offset(972, 278), Offset(976, 276), Offset(976, 211),
      Offset(970, 211), Offset(970, 185),
    ]),

  ],

  // ── Nav nodes (pathfinding graph) ──────────────────────────
  navNodes: const {
    'N1':  NavNode(id: 'N1',  position: Offset(453, 184), neighbors: ['N5', 'N2']),
    'N2':  NavNode(id: 'N2',  position: Offset(560, 184), neighbors: ['N1', 'N3']),
    'N3':  NavNode(id: 'N3',  position: Offset(591, 185), neighbors: ['N2', 'N4']),
    'N4':  NavNode(id: 'N4',  position: Offset(694, 183), neighbors: ['N3']),
    'N5':  NavNode(id: 'N5',  position: Offset(433, 186), neighbors: ['N6', 'N1']),
    'N6':  NavNode(id: 'N6',  position: Offset(329, 183), neighbors: ['N7', 'N5']),
    'N7':  NavNode(id: 'N7',  position: Offset(306, 181), neighbors: ['N10', 'N8', 'N6']),
    'N8':  NavNode(id: 'N8',  position: Offset(305, 164), neighbors: ['N7', 'N9']),
    'N9':  NavNode(id: 'N9',  position: Offset(305, 139), neighbors: ['N8']),
    'N10': NavNode(id: 'N10', position: Offset(312, 294), neighbors: ['N11', 'N7']),
    'N11': NavNode(id: 'N11', position: Offset(321, 459), neighbors: ['N12', 'N10']),
    'N12': NavNode(id: 'N12', position: Offset(334, 513), neighbors: ['N13', 'N11']),
    'N13': NavNode(id: 'N13', position: Offset(286, 522), neighbors: ['N14', 'N12']),
    'N14': NavNode(id: 'N14', position: Offset(279, 497), neighbors: ['N13']),
  },

  // ── Room → nav node mapping ─────────────────────────────────
  // Keys are room numbers only (no building prefix).
  roomToNode: const {
    '341':  'N8',
    '342':  'N10',
    '347':  'N9',
    '353':  'N5',
    '354':  'N6',
    '361':  'N1',
    '362':  'N2',
    '367':  'N3',
    '368':  'N4',
    '300F': 'N14',
  },
);
