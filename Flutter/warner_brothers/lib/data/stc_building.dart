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
  id: 'STC',
  name: 'STC Building',
  floors: [_floor1, _floor2, _floor3],
  // ── Cross-floor links ───────────────────────────────────────
  // Each staircase/elevator needs one entry per direction.
  // Add matching nodes to the other floors when they are mapped.
  crossFloorLinks: const [
    // West staircase (floor 3 ↔ floor 2) — both directions
    CrossFloorLink(fromFloor: 3, fromNodeId: 'N_stairW',  toFloor: 2, toNodeId: 'F2_stairW'),
    CrossFloorLink(fromFloor: 2, fromNodeId: 'F2_stairW', toFloor: 3, toNodeId: 'N_stairW'),

    // East staircase (floor 3 ↔ floor 2) — both directions
    CrossFloorLink(fromFloor: 3, fromNodeId: 'N_stairE',  toFloor: 2, toNodeId: 'F2_stairE'),
    CrossFloorLink(fromFloor: 2, fromNodeId: 'F2_stairE', toFloor: 3, toNodeId: 'N_stairE'),

    // West elevator (floor 3 ↔ floor 2)
    CrossFloorLink(fromFloor: 3, fromNodeId: 'N_elevW',  toFloor: 2, toNodeId: 'F2_elevW'),
    CrossFloorLink(fromFloor: 2, fromNodeId: 'F2_elevW', toFloor: 3, toNodeId: 'N_elevW'),

    // East elevator (floor 3 ↔ floor 2)
    CrossFloorLink(fromFloor: 3, fromNodeId: 'N_elevE',  toFloor: 2, toNodeId: 'F2_elevE'),
    CrossFloorLink(fromFloor: 2, fromNodeId: 'F2_elevE', toFloor: 3, toNodeId: 'N_elevE'),
  ],
);

// ── Floor 1 ───────────────────────────────────────────────────
// Polygons and nav nodes to be added.
final FloorData _floor1 = FloorData(
  floorNumber: 1,
  name: 'Floor 1',
  imagePath: 'assets/images/stc/floor_map/stc_1.png',
  nativeWidth:  1479.0,
  nativeHeight: 883.0,
  rooms: const [],
  navNodes: const {},
  roomToNode: const <String, List<String>>{}, // TODO: add entries
);

// ── Floor 2 ───────────────────────────────────────────────────
// Nav nodes to be added.
final FloorData _floor2 = FloorData(
  floorNumber: 2,
  name: 'Floor 2',
  imagePath: 'assets/images/stc/floor_map/stc_2.png',

  // ── Room polygons ──────────────────────────────────────────
  rooms: const [
    RoomPolygon(id: '201', name: 'Room 201', pixels: [
      Offset(1123, 660), Offset(1097, 761), Offset(1105, 763),
      Offset(1103, 769), Offset(1253, 809), Offset(1255, 803),
      Offset(1258, 805), Offset(1287, 702), Offset(1261, 697),
      Offset(1262, 685), Offset(1154, 658), Offset(1152, 668),
    ]),
    RoomPolygon(id: '205', name: 'Room 205', pixels: [
      Offset(1025, 622), Offset(1124, 648), Offset(1097, 761),
      Offset(1088, 759), Offset(1088, 764), Offset(983, 735),
      Offset(1007, 642), Offset(1019, 646),
    ]),
    RoomPolygon(id: '207', name: 'Room 207', pixels: [
      Offset(831, 679), Offset(840, 723), Offset(888, 712), Offset(882, 671),
    ]),
    RoomPolygon(id: '217', name: 'Room 217', pixels: [
      Offset(706, 551), Offset(716, 595), Offset(787, 582), Offset(776, 534),
    ]),
    RoomPolygon(id: '215', name: 'Room 215', pixels: [
      Offset(680, 606), Offset(709, 746), Offset(838, 718), Offset(812, 576),
    ]),
    RoomPolygon(id: '221', name: 'Room 221', pixels: [
      Offset(581, 620), Offset(607, 767), Offset(711, 746), Offset(684, 602),
    ]),
    RoomPolygon(id: '223', name: 'Room 223', pixels: [
      Offset(649, 557), Offset(658, 602), Offset(612, 615), Offset(605, 569),
    ]),
    RoomPolygon(id: '225', name: 'Room 225', pixels: [
      Offset(601, 569), Offset(609, 611), Offset(561, 617), Offset(553, 576),
    ]),
    RoomPolygon(id: '227', name: 'Room 227', pixels: [
      Offset(551, 575), Offset(560, 616), Offset(513, 623), Offset(505, 585),
    ]),
    RoomPolygon(id: '231', name: 'Room 231', pixels: [
      Offset(579, 620), Offset(606, 764), Offset(490, 786), Offset(463, 642),
    ]),
    RoomPolygon(id: '235', name: 'Room 235', pixels: [
      Offset(453, 592), Offset(461, 641), Offset(389, 653), Offset(377, 607),
    ]),
    RoomPolygon(id: '239', name: 'Room 239', pixels: [
      Offset(462, 643), Offset(489, 786), Offset(392, 800),
      Offset(370, 669), Offset(388, 666), Offset(387, 653),
    ]),
    RoomPolygon(id: '243', name: 'Room 243', pixels: [
      Offset(147, 713), Offset(169, 844), Offset(392, 800),
      Offset(370, 670), Offset(346, 674), Offset(344, 664),
      Offset(166, 695), Offset(169, 706),
    ]),
    RoomPolygon(id: '294', name: 'Room 294', pixels: [
      Offset(1083, 292), Offset(1083, 439), Offset(1190, 437),
      Offset(1190, 305), Offset(1168, 306), Offset(1169, 292),
    ]),
    RoomPolygon(id: '290', name: 'Room 290', pixels: [
      Offset(1082, 292), Offset(1081, 440), Offset(975, 439),
      Offset(975, 304), Offset(996, 304), Offset(995, 292),
    ]),
    RoomPolygon(id: '286', name: 'Room 286', pixels: [
      Offset(974, 292), Offset(974, 439), Offset(910, 439),
      Offset(908, 323), Offset(922, 323), Offset(920, 294),
    ]),
    RoomPolygon(id: '2-R', name: 'Room 2-R', pixels: [
      Offset(1189, 117), Offset(1191, 334), Offset(1242, 333),
      Offset(1240, 289), Offset(1280, 291), Offset(1279, 117),
    ]),
    RoomPolygon(id: '295', name: 'Room 295', pixels: [
      Offset(1187, 115), Offset(1190, 246), Offset(1164, 244),
      Offset(1163, 253), Offset(1083, 253), Offset(1082, 118),
    ]),
    RoomPolygon(id: '291', name: 'Room 291', pixels: [
      Offset(1079, 119), Offset(1082, 246), Offset(1053, 246),
      Offset(1051, 254), Offset(949, 254), Offset(949, 244),
      Offset(917, 243), Offset(917, 114),
    ]),
    RoomPolygon(id: '285', name: 'Room 285', pixels: [
      Offset(915, 116), Offset(917, 246), Offset(888, 245),
      Offset(889, 258), Offset(849, 257), Offset(849, 117),
    ]),
    RoomPolygon(id: '275', name: 'Room 275', pixels: [
      Offset(848, 116), Offset(849, 243), Offset(821, 242),
      Offset(820, 254), Offset(725, 255), Offset(724, 246),
      Offset(692, 243), Offset(689, 115),
    ]),
    RoomPolygon(id: '267', name: 'Room 267', pixels: [
      Offset(688, 154), Offset(690, 243), Offset(646, 244),
      Offset(645, 257), Offset(598, 256), Offset(597, 161),
      Offset(641, 160), Offset(643, 149),
    ]),
    RoomPolygon(id: '267B', name: 'Room 267B', pixels: [
      Offset(641, 113), Offset(643, 150), Offset(690, 151), Offset(688, 114),
    ]),
    RoomPolygon(id: '261', name: 'Room 261', pixels: [
      Offset(593, 118), Offset(595, 246), Offset(560, 245),
      Offset(560, 252), Offset(452, 253), Offset(453, 246),
      Offset(424, 246), Offset(422, 117),
    ]),
    RoomPolygon(id: '257', name: 'Room 257', pixels: [
      Offset(422, 115), Offset(423, 221), Offset(371, 222),
      Offset(371, 255), Offset(345, 254), Offset(347, 115),
    ]),
    RoomPolygon(id: '255', name: 'Room 255', pixels: [
      Offset(343, 117), Offset(344, 246), Offset(324, 245),
      Offset(324, 259), Offset(240, 259), Offset(240, 248),
      Offset(215, 247), Offset(215, 117),
    ]),
    RoomPolygon(id: '259', name: 'Room 259', pixels: [
      Offset(371, 221), Offset(370, 260), Offset(407, 258), Offset(409, 223),
    ]),
    RoomPolygon(id: '253', name: 'Room 253', pixels: [
      Offset(215, 295), Offset(217, 325), Offset(275, 325), Offset(275, 293),
    ]),
    RoomPolygon(id: '251', name: 'Room 251', pixels: [
      Offset(216, 325), Offset(275, 325), Offset(275, 352), Offset(214, 352),
    ]),
    RoomPolygon(id: '247', name: 'Room 247', pixels: [
      Offset(214, 353), Offset(214, 441), Offset(275, 442), Offset(275, 352),
    ]),
    RoomPolygon(id: '252', name: 'Room 252', pixels: [
      Offset(301, 294), Offset(298, 446), Offset(379, 445), Offset(378, 293),
    ]),
    RoomPolygon(id: '262', name: 'Room 262', pixels: [
      Offset(378, 292), Offset(501, 292), Offset(500, 439),
      Offset(398, 440), Offset(398, 445), Offset(379, 445),
    ]),
    RoomPolygon(id: '264', name: 'Room 264', pixels: [
      Offset(613, 294), Offset(614, 329), Offset(500, 328), Offset(500, 292),
    ]),
    RoomPolygon(id: '264A', name: 'Room 264A', pixels: [
      Offset(611, 329), Offset(615, 440), Offset(499, 439), Offset(502, 328),
    ]),
    RoomPolygon(id: '268', name: 'Room 268', pixels: [
      Offset(615, 294), Offset(616, 439), Offset(650, 439),
      Offset(651, 397), Offset(660, 397), Offset(661, 307),
      Offset(672, 307), Offset(672, 292),
    ]),
    RoomPolygon(id: '268A', name: 'Room 268A', pixels: [
      Offset(651, 398), Offset(650, 439), Offset(694, 437), Offset(693, 397),
    ]),

    // ── Staircases & elevators ────────────────────────────────
    RoomPolygon(
      id:    'stair_lobby',
      name:  'Lobby Stairs',
      type:  AreaType.staircase,
      pixels: [
        Offset(912, 444), Offset(912, 482), Offset(1046, 482), Offset(1047, 443),
      ],
    ),
    RoomPolygon(
      id:    'stair_east',
      name:  'East Staircase',
      type:  AreaType.staircase,
      pixels: [
        Offset(1228, 332), Offset(1228, 442), Offset(1283, 441), Offset(1282, 332),
      ],
    ),
    RoomPolygon(
      id:    'elevator_east',
      name:  'East Elevator',
      type:  AreaType.elevator,
      pixels: [
        Offset(1241, 288), Offset(1241, 331), Offset(1282, 331), Offset(1281, 290),
      ],
    ),
    RoomPolygon(
      id:    'stair_west',
      name:  'West Staircase',
      type:  AreaType.staircase,
      pixels: [
        Offset(72, 749), Offset(91, 856), Offset(142, 846), Offset(123, 739),
      ],
    ),
    RoomPolygon(
      id:    'elevator_west',
      name:  'West Elevator',
      type:  AreaType.elevator,
      pixels: [
        Offset(63, 707), Offset(72, 749), Offset(98, 744), Offset(91, 702),
      ],
    ),

    // ── Entrances ──────────────────────────────────────────────
    RoomPolygon(id: 'entrance_south', name: '2nd South Entrance', pixels: [
      Offset(948, 681), Offset(937, 722), Offset(981, 738), Offset(992, 692),
    ]),
    RoomPolygon(id: 'entrance_east', name: '2nd East Entrance', pixels: [
      Offset(1191, 485), Offset(1191, 562), Offset(1225, 561), Offset(1225, 485),
    ]),
  ],

  nativeWidth:  1465.0,
  nativeHeight: 912.0,

  // ── Nav nodes ──────────────────────────────────────────────
  navNodes: const {
    // ── Top hallway spine (y ≈ 270) ──────────────────────────
    'F2_N1':  NavNode(id: 'F2_N1',  position: Offset(250, 270), neighbors: ['F2_N2', 'F2_N10']),
    'F2_N2':  NavNode(id: 'F2_N2',  position: Offset(380, 270), neighbors: ['F2_N1', 'F2_N3']),
    'F2_N3':  NavNode(id: 'F2_N3',  position: Offset(500, 270), neighbors: ['F2_N2', 'F2_N4']),
    'F2_N4':  NavNode(id: 'F2_N4',  position: Offset(595, 270), neighbors: ['F2_N3', 'F2_N5']),
    'F2_N5':  NavNode(id: 'F2_N5',  position: Offset(695, 270), neighbors: ['F2_N4', 'F2_N6']),
    'F2_N6':  NavNode(id: 'F2_N6',  position: Offset(860, 270), neighbors: ['F2_N5', 'F2_N7']),
    'F2_N7':  NavNode(id: 'F2_N7',  position: Offset(1000, 270), neighbors: ['F2_N6', 'F2_N8']),
    'F2_N8':  NavNode(id: 'F2_N8',  position: Offset(1085, 270), neighbors: ['F2_N7', 'F2_N9', 'F2_N13']),
    'F2_N9':  NavNode(id: 'F2_N9',  position: Offset(1190, 270), neighbors: ['F2_N8', 'F2_N12', 'F2_elevE']),

    // ── Left-side vertical (connecting rooms 247/251/253) ────
    'F2_N10': NavNode(id: 'F2_N10', position: Offset(250, 360), neighbors: ['F2_N1', 'F2_N11']),
    'F2_N11': NavNode(id: 'F2_N11', position: Offset(250, 440), neighbors: ['F2_N10']),

    // ── East-side vertical ────────────────────────────────────
    'F2_N12': NavNode(id: 'F2_N12', position: Offset(1190, 370), neighbors: ['F2_N9', 'F2_N13', 'F2_stairE']),
    'F2_N13': NavNode(id: 'F2_N13', position: Offset(1085, 440), neighbors: ['F2_N8', 'F2_N12', 'F2_N14']),

    // ── Lobby staircase (center-east, connects south) ─────────
    'F2_N14': NavNode(id: 'F2_N14', position: Offset(979, 465), neighbors: ['F2_N13', 'F2_N7', 'F2_N15', 'F2_stairLobby']),

    // ── South corridor spine ──────────────────────────────────
    'F2_N15': NavNode(id: 'F2_N15', position: Offset(979, 555), neighbors: ['F2_N14', 'F2_N16']),
    'F2_N16': NavNode(id: 'F2_N16', position: Offset(940, 640), neighbors: ['F2_N15', 'F2_N17']),
    'F2_N17': NavNode(id: 'F2_N17', position: Offset(840, 620), neighbors: ['F2_N16', 'F2_N18']),
    'F2_N18': NavNode(id: 'F2_N18', position: Offset(730, 590), neighbors: ['F2_N17', 'F2_N19']),
    'F2_N19': NavNode(id: 'F2_N19', position: Offset(645, 620), neighbors: ['F2_N18', 'F2_N20']),
    'F2_N20': NavNode(id: 'F2_N20', position: Offset(530, 630), neighbors: ['F2_N19', 'F2_N21']),
    'F2_N21': NavNode(id: 'F2_N21', position: Offset(370, 660), neighbors: ['F2_N20', 'F2_N22']),
    'F2_N22': NavNode(id: 'F2_N22', position: Offset(210, 700), neighbors: ['F2_N21', 'F2_stairW', 'F2_elevW']),

    // ── Staircase / elevator nodes (cross-floor anchors) ─────
    'F2_stairW':    NavNode(id: 'F2_stairW',    position: Offset(107, 793), neighbors: ['F2_N22']),
    'F2_elevW':     NavNode(id: 'F2_elevW',     position: Offset(80,  725), neighbors: ['F2_N22']),
    'F2_stairE':    NavNode(id: 'F2_stairE',    position: Offset(1255, 387), neighbors: ['F2_N12']),
    'F2_elevE':     NavNode(id: 'F2_elevE',     position: Offset(1262, 310), neighbors: ['F2_N9']),
    'F2_stairLobby':NavNode(id: 'F2_stairLobby',position: Offset(979, 465), neighbors: ['F2_N14']),
  },

  // ── Room → nav node mapping ───────────────────────────────
  roomToNode: const {
    // Staircases / elevators
    'stair_west':    ['F2_stairW'],
    'elevator_west': ['F2_elevW'],
    'stair_east':    ['F2_stairE'],
    'elevator_east': ['F2_elevE'],
    'stair_lobby':   ['F2_stairLobby'],
    'entrance_south':['F2_N16'],
    'entrance_east': ['F2_N12'],

    // North rooms
    '295':   ['F2_N8', 'F2_N9'],
    '291':   ['F2_N7', 'F2_N8'],
    '285':   ['F2_N6', 'F2_N7'],
    '275':   ['F2_N5', 'F2_N6'],
    '267':   ['F2_N4', 'F2_N5'],
    '267B':  ['F2_N5'],
    '261':   ['F2_N3', 'F2_N4'],
    '259':   ['F2_N2'],
    '257':   ['F2_N2', 'F2_N3'],
    '255':   ['F2_N1', 'F2_N2'],
    '253':   ['F2_N10'],
    '251':   ['F2_N10', 'F2_N11'],
    '247':   ['F2_N10', 'F2_N11'],
    '2-R':   ['F2_N9', 'F2_N12'],

    // East rooms
    '294':   ['F2_N8', 'F2_N13'],
    '290':   ['F2_N7', 'F2_N8'],
    '286':   ['F2_N7', 'F2_N13'],

    // Middle rooms
    '252':   ['F2_N2'],
    '262':   ['F2_N3'],
    '264':   ['F2_N4'],
    '264A':  ['F2_N4'],
    '268':   ['F2_N4'],
    '268A':  ['F2_N4'],

    // South rooms
    '201':   ['F2_N16'],
    '205':   ['F2_N15', 'F2_N16'],
    '207':   ['F2_N17'],
    '215':   ['F2_N17', 'F2_N18'],
    '217':   ['F2_N18'],
    '221':   ['F2_N19'],
    '223':   ['F2_N19'],
    '225':   ['F2_N19', 'F2_N20'],
    '227':   ['F2_N20'],
    '231':   ['F2_N20'],
    '235':   ['F2_N21'],
    '239':   ['F2_N21'],
    '243':   ['F2_N22'],
  },
);

// ── Floor 3 ───────────────────────────────────────────────────
final FloorData _floor3 = FloorData(
  floorNumber: 3,
  name: 'Floor 3',
  imagePath: 'assets/images/stc/floor_map/stc_3.png',
  nativeWidth:  1201.0,
  nativeHeight: 666.0,

  // ── Room polygons ──────────────────────────────────────────
  rooms: const [

    // ── North row rooms ──────────────────────────────────────
    RoomPolygon(id: '347', name: 'Room 347', pixels: [
      Offset(164,  32), Offset(166, 149), Offset(282, 149),
      Offset(282, 115), Offset(292, 115), Offset(290,  55),
      Offset(281,  57), Offset(280,  32),
    ]),
    RoomPolygon(id: '341', name: 'Room 341', pixels: [
      Offset(166, 150), Offset(163, 307), Offset(284, 305),
      Offset(281, 281), Offset(292, 280), Offset(292, 172),
      Offset(282, 172), Offset(281, 149),
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

    // ── Center / south corridor rooms ────────────────────────
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
    // TODO: confirm room number for this small south-corridor room
    RoomPolygon(id: '367_south', name: 'Room 367 (South)', pixels: [
      Offset(601, 233), Offset(601, 258),
      Offset(624, 259), Offset(625, 231),
    ]),
    RoomPolygon(id: '375', name: 'Room 375', pixels: [
      Offset(751, 189), Offset(754, 214), Offset(754, 302),
      Offset(862, 300), Offset(862, 184),
    ]),
    RoomPolygon(id: '398', name: 'Room 398', pixels: [
      Offset(862, 188), Offset(863, 302), Offset(970, 302),
      Offset(972, 278), Offset(976, 276), Offset(976, 211),
      Offset(970, 211), Offset(970, 185),
    ]),

    // ── 310-series rooms ─────────────────────────────────────
    RoomPolygon(id: '310A', name: 'Room 310A', pixels: [
      Offset(801, 386), Offset(791, 421),
      Offset(744, 409), Offset(755, 375),
    ]),
    RoomPolygon(id: '310B', name: 'Room 310B', pixels: [
      Offset(851, 399), Offset(838, 435),
      Offset(791, 423), Offset(802, 386),
    ]),
    RoomPolygon(id: '310C', name: 'Room 310C', pixels: [
      Offset(896, 411), Offset(886, 447),
      Offset(840, 435), Offset(851, 400),
    ]),
    RoomPolygon(id: '310D', name: 'Room 310D', pixels: [
      Offset(945, 423), Offset(934, 461),
      Offset(887, 447), Offset(897, 411),
    ]),
    RoomPolygon(id: '310E', name: 'Room 310E', pixels: [
      Offset(972, 430), Offset(961, 474),
      Offset(995, 483), Offset(1006, 440),
    ]),
    RoomPolygon(id: '310H', name: 'Room 310H', pixels: [
      Offset(1078, 460), Offset(1065, 503),
      Offset(1100, 512), Offset(1112, 470),
    ]),
    RoomPolygon(id: '310K', name: 'Room 310K', pixels: [
      Offset(1146, 480), Offset(1135, 521),
      Offset(1170, 530), Offset(1181, 488),
    ]),
    RoomPolygon(id: '310L', name: 'Room 310L', pixels: [
      Offset(1110, 534), Offset(1087, 628),
      Offset(1140, 641), Offset(1165, 548),
    ]),
    RoomPolygon(id: '310M', name: 'Room 310M', pixels: [
      Offset(1053, 580), Offset(1095, 590),
      Offset(1086, 625), Offset(1045, 615),
    ]),
    RoomPolygon(id: '310P', name: 'Room 310P', pixels: [
      Offset(1038, 518), Offset(1028, 551),
      Offset(987, 541), Offset(997, 506),
    ]),
    RoomPolygon(id: '310Q', name: 'Room 310Q', pixels: [
      Offset(1012, 569), Offset(1003, 604),
      Offset(961, 593), Offset(971, 556),
    ]),
    RoomPolygon(id: '310S', name: 'Room 310S', pixels: [
      Offset(906, 539), Offset(894, 583),
      Offset(957, 600), Offset(970, 556),
    ]),
    RoomPolygon(id: '310U', name: 'Room 310U', pixels: [
      Offset(863, 529), Offset(853, 564),
      Offset(896, 575), Offset(905, 539),
    ]),
    RoomPolygon(id: '310V', name: 'Room 310V', pixels: [
      Offset(852, 466), Offset(842, 501),
      Offset(883, 513), Offset(893, 477),
    ]),
    RoomPolygon(id: '310X', name: 'Room 310X', pixels: [
      Offset(822, 516), Offset(813, 554),
      Offset(769, 541), Offset(779, 506),
    ]),
    RoomPolygon(id: '310Z', name: 'Room 310Z', pixels: [
      Offset(768, 445), Offset(759, 479),
      Offset(800, 491), Offset(809, 456),
    ]),

    // ── 320-series rooms ─────────────────────────────────────
    RoomPolygon(id: '320A', name: 'Room 320A', pixels: [
      Offset(589, 392), Offset(607, 481), Offset(644, 473),
      Offset(638, 443), Offset(697, 429), Offset(686, 374),
    ]),
    RoomPolygon(id: '320B', name: 'Room 320B', pixels: [
      Offset(685, 496), Offset(692, 538),
      Offset(730, 532), Offset(722, 488),
    ]),
    RoomPolygon(id: '320F', name: 'Room 320F', pixels: [
      Offset(579, 515), Offset(587, 558),
      Offset(621, 551), Offset(614, 509),
    ]),
    RoomPolygon(id: '320J', name: 'Room 320J', pixels: [
      Offset(542, 521), Offset(550, 564),
      Offset(515, 570), Offset(508, 527),
    ]),
    RoomPolygon(id: '320M', name: 'Room 320M', pixels: [
      Offset(401, 547), Offset(408, 589),
      Offset(444, 583), Offset(436, 539),
    ]),
    RoomPolygon(id: '320P', name: 'Room 320P', pixels: [
      Offset(360, 530), Offset(373, 604), Offset(286, 620),
      Offset(278, 568), Offset(293, 565), Offset(293, 542),
    ]),
    RoomPolygon(id: '320R', name: 'Room 320R', pixels: [
      Offset(219, 522), Offset(225, 559),
      Offset(267, 549), Offset(262, 516),
    ]),
    RoomPolygon(id: '320S', name: 'Room 320S', pixels: [
      Offset(205, 583), Offset(213, 625),
      Offset(249, 618), Offset(241, 576),
    ]),
    RoomPolygon(id: '320V', name: 'Room 320V', pixels: [
      Offset(99, 599), Offset(106, 643),
      Offset(140, 637), Offset(134, 594),
    ]),
    RoomPolygon(id: '320W', name: 'Room 320W', pixels: [
      Offset(33, 492), Offset(42, 534),
      Offset(85, 526), Offset(77, 484),
    ]),

    // ── Staircases & Elevators ────────────────────────────────
    RoomPolygon(
      id:   'stair_east',
      name: 'East Staircase',
      type: AreaType.staircase,
      pixels: [
        Offset(1051, 279), Offset(1052, 214),
        Offset(1010, 216), Offset(1012, 285),
        Offset(1051, 285),
      ],
    ),
    RoomPolygon(
      id:   'elevator_east',
      name: 'East Elevator',
      type: AreaType.elevator,
      pixels: [
        Offset(1008, 180), Offset(1012, 213),
        Offset(1053, 214), Offset(1054, 181),
      ],
    ),
    RoomPolygon(
      id:   'stair_lobby',
      name: 'Lobby Staircase',
      type: AreaType.staircase,
      pixels: [
        Offset(748, 308), Offset(748, 339),
        Offset(859, 338), Offset(858, 307),
      ],
    ),
    RoomPolygon(
      id:   'stair_west',
      name: 'West Staircase',
      type: AreaType.staircase,
      pixels: [
        Offset(47, 562), Offset(64, 650),
        Offset(105, 643), Offset(90, 554),
      ],
    ),
    RoomPolygon(
      id:   'elevator_west',
      name: 'West Elevator',
      type: AreaType.elevator,
      pixels: [
        Offset(41, 527), Offset(49, 561),
        Offset(67, 557), Offset(61, 524),
      ],
    ),

    // ── 330-series rooms ─────────────────────────────────────
    RoomPolygon(id: '330A', name: 'Room 330A', pixels: [
      Offset(148, 471), Offset(157, 515),
      Offset(192, 507), Offset(185, 465),
    ]),
    RoomPolygon(id: '330F', name: 'Room 330F', pixels: [
      Offset(256, 451), Offset(267, 494),
      Offset(298, 488), Offset(292, 445),
    ]),
    RoomPolygon(id: '330G', name: 'Room 330G', pixels: [
      Offset(375, 430), Offset(384, 474),
      Offset(349, 480), Offset(340, 437),
    ]),
    RoomPolygon(id: '330J', name: 'Room 330J', pixels: [
      Offset(417, 487), Offset(424, 522),
      Offset(465, 516), Offset(459, 480),
    ]),
    RoomPolygon(id: '330M', name: 'Room 330M', pixels: [
      Offset(447, 417), Offset(457, 462),
      Offset(492, 453), Offset(482, 409),
    ]),
    RoomPolygon(id: '330P', name: 'Room 330P', pixels: [
      Offset(501, 472), Offset(508, 509),
      Offset(549, 499), Offset(545, 464),
    ]),
    RoomPolygon(id: '330R', name: 'Room 330R', pixels: [
      Offset(589, 394), Offset(598, 435),
      Offset(563, 441), Offset(554, 399),
    ]),

  ],

  // ── Nav nodes (pathfinding graph) ──────────────────────────
  // Nodes marked TODO need pixel positions placed on the floor map.
  navNodes: const {
    // ── STC Floor 3 ───────────────
    'N1': NavNode(
      id: 'N1',
      position: Offset(303, 138),
      neighbors: ['N2'],
    ),
    'N2': NavNode(
      id: 'N2',
      position: Offset(304, 166),
      neighbors: ['N1', 'N6'],
    ),
    'N3': NavNode(
      id: 'N3',
      position: Offset(320, 463),
      neighbors: ['N37', 'N5'],
    ),
    'N4': NavNode(
      id: 'N4',
      position: Offset(296, 290),
      neighbors: ['N5'],
    ),
    'N5': NavNode(
      id: 'N5',
      position: Offset(315, 290),
      neighbors: ['N6', 'N4', 'N13', 'N3'],
    ),
    'N6': NavNode(
      id: 'N6',
      position: Offset(306, 186),
      neighbors: ['N2', 'N7', 'N5'],
    ),
    'N7': NavNode(
      id: 'N7',
      position: Offset(330, 183),
      neighbors: ['N6', 'N35'],
    ),
    'N8': NavNode(
      id: 'N8',
      position: Offset(438, 187),
      neighbors: ['N36', 'N9'],
    ),
    'N9': NavNode(
      id: 'N9',
      position: Offset(460, 187),
      neighbors: ['N8', 'N34'],
    ),
    'N10': NavNode(
      id: 'N10',
      position: Offset(559, 180),
      neighbors: ['N34', 'N11'],
    ),
    'N11': NavNode(
      id: 'N11',
      position: Offset(593, 181),
      neighbors: ['N10', 'N25', 'N12'],
    ),
    'N12': NavNode(
      id: 'N12',
      position: Offset(693, 180),
      neighbors: ['N11', 'N14'],
    ),
    'N13': NavNode(
      id: 'N13',
      position: Offset(339, 289),
      neighbors: ['N5'],
    ),
    'N14': NavNode(
      id: 'N14',
      position: Offset(726, 186),
      neighbors: ['N12', 'N15', 'N16'],
    ),
    'N15': NavNode(
      id: 'N15',
      position: Offset(726, 164),
      neighbors: ['N14', 'N17'],
    ),
    'N16': NavNode(
      id: 'N16',
      position: Offset(729, 210),
      neighbors: ['N14', 'N26'],
    ),
    'N17': NavNode(
      id: 'N17',
      position: Offset(728, 78),
      neighbors: ['N15', 'N18'],
    ),
    'N18': NavNode(
      id: 'N18',
      position: Offset(725, 52),
      neighbors: ['N17', 'N21'],
    ),
    'N19': NavNode(
      id: 'N19',
      position: Offset(993, 78),
      neighbors: ['N21', 'N58'],
    ),
    'N20': NavNode(
      id: 'N20',
      position: Offset(995, 166),
      neighbors: ['N58', 'N22'],
    ),
    'N21': NavNode(
      id: 'N21',
      position: Offset(993, 49),
      neighbors: ['N18', 'N19'],
    ),
    'N22': NavNode(
      id: 'N22',
      position: Offset(995, 205),
      neighbors: ['N20', 'N23', 'N_stairE', 'N_elevE'],
    ),
    'N23': NavNode(
      id: 'N23',
      position: Offset(992, 294),
      neighbors: ['N22', 'N24', 'N_stairE'],
    ),
    'N24': NavNode(
      id: 'N24',
      position: Offset(945, 481),
      neighbors: ['N23', 'N29', 'N53', 'N51'],
    ),
    'N25': NavNode(
      id: 'N25',
      position: Offset(592, 247),
      neighbors: ['N11'],
    ),
    'N26': NavNode(
      id: 'N26',
      position: Offset(731, 289),
      neighbors: ['N16', 'N27', 'N_stairLobby'],
    ),
    'N27': NavNode(
      id: 'N27',
      position: Offset(728, 390),
      neighbors: ['N26', 'N28', 'N_stairLobby'],
    ),
    'N28': NavNode(
      id: 'N28',
      position: Offset(733, 434),
      neighbors: ['N27', 'N32', 'N47'],
    ),
    'N29': NavNode(
      id: 'N29',
      position: Offset(906, 470),
      neighbors: ['N30', 'N24'],
    ),
    'N30': NavNode(
      id: 'N30',
      position: Offset(861, 456),
      neighbors: ['N31', 'N29'],
    ),
    'N31': NavNode(
      id: 'N31',
      position: Offset(810, 444),
      neighbors: ['N32', 'N30'],
    ),
    'N32': NavNode(
      id: 'N32',
      position: Offset(764, 434),
      neighbors: ['N28', 'N31'],
    ),
    'N33': NavNode(
      id: 'N33',
      position: Offset(408, 185),
      neighbors: ['N35', 'N36'],
    ),
    'N34': NavNode(
      id: 'N34',
      position: Offset(516, 184),
      neighbors: ['N9', 'N10'],
    ),
    'N35': NavNode(
      id: 'N35',
      position: Offset(376, 184),
      neighbors: ['N7', 'N33'],
    ),
    'N36': NavNode(
      id: 'N36',
      position: Offset(420, 184),
      neighbors: ['N33', 'N8'],
    ),
    'N37': NavNode(
      id: 'N37',
      position: Offset(324, 499),
      neighbors: ['N38', 'N39', 'N3', 'N59'],
    ),
    'N38': NavNode(
      id: 'N38',
      position: Offset(367, 488),
      neighbors: ['N42', 'N37'],
    ),
    'N39': NavNode(
      id: 'N39',
      position: Offset(360, 516),
      neighbors: ['N40', 'N37'],
    ),
    'N40': NavNode(
      id: 'N40',
      position: Offset(380, 537),
      neighbors: ['N41', 'N39'],
    ),
    'N41': NavNode(
      id: 'N41',
      position: Offset(415, 533),
      neighbors: ['N44', 'N40'],
    ),
    'N42': NavNode(
      id: 'N42',
      position: Offset(475, 469),
      neighbors: ['N43', 'N38'],
    ),
    'N43': NavNode(
      id: 'N43',
      position: Offset(584, 450),
      neighbors: ['N45', 'N42'],
    ),
    'N44': NavNode(
      id: 'N44',
      position: Offset(521, 519),
      neighbors: ['N45', 'N41'],
    ),
    'N45': NavNode(
      id: 'N45',
      position: Offset(596, 502),
      neighbors: ['N46', 'N43', 'N44'],
    ),
    'N46': NavNode(
      id: 'N46',
      position: Offset(701, 480),
      neighbors: ['N47', 'N45'],
    ),
    'N47': NavNode(
      id: 'N47',
      position: Offset(740, 478),
      neighbors: ['N28', 'N48', 'N46'],
    ),
    'N48': NavNode(
      id: 'N48',
      position: Offset(741, 492),
      neighbors: ['N47', 'N49'],
    ),
    'N49': NavNode(
      id: 'N49',
      position: Offset(801, 504),
      neighbors: ['N48', 'N50'],
    ),
    'N50': NavNode(
      id: 'N50',
      position: Offset(885, 528),
      neighbors: ['N49', 'N51'],
    ),
    'N51': NavNode(
      id: 'N51',
      position: Offset(932, 540),
      neighbors: ['N50', 'N24', 'N52'],
    ),
    'N52': NavNode(
      id: 'N52',
      position: Offset(993, 557),
      neighbors: ['N51', 'N56'],
    ),
    'N53': NavNode(
      id: 'N53',
      position: Offset(972, 489),
      neighbors: ['N24', 'N54'],
    ),
    'N54': NavNode(
      id: 'N54',
      position: Offset(1081, 519),
      neighbors: ['N57', 'N53', 'N55'],
    ),
    'N55': NavNode(
      id: 'N55',
      position: Offset(1150, 534),
      neighbors: ['N54'],
    ),
    'N56': NavNode(
      id: 'N56',
      position: Offset(1076, 571),
      neighbors: ['N52', 'N57'],
    ),
    'N57': NavNode(
      id: 'N57',
      position: Offset(1082, 543),
      neighbors: ['N56', 'N54'],
    ),
    'N58': NavNode(
      id: 'N58',
      position: Offset(995, 138),
      neighbors: ['N19', 'N20', 'N_elevE'],
    ),
    // ── Staircase / elevator nodes (cross-floor anchors) ─────
    'N_stairW': NavNode(
      id: 'N_stairW',
      position: Offset(76, 602),
      neighbors: ['N61'],
    ),
    'N_elevW': NavNode(
      id: 'N_elevW',
      position: Offset(54, 543),
      neighbors: ['N61'],
    ),
    'N_stairLobby': NavNode(
      id: 'N_stairLobby',
      position: Offset(803, 323),
      neighbors: ['N26', 'N27'],
    ),
    'N_stairE': NavNode(
      id: 'N_stairE',
      position: Offset(1031, 250),
      neighbors: ['N22', 'N23'],
    ),
    'N_elevE': NavNode(
      id: 'N_elevE',
      position: Offset(1031, 197),
      neighbors: ['N22', 'N58'],
    ),

    'N59': NavNode(
      id: 'N59',
      position: Offset(282, 499),
      neighbors: ['N37', 'N66', 'N60'],
    ),
    'N60': NavNode(
      id: 'N60',
      position: Offset(174, 521),
      neighbors: ['N59', 'N62'],
    ),
    'N61': NavNode(
      id: 'N61',
      position: Offset(75, 540),
      neighbors: ['N62', 'N_stairW', 'N_elevW'],
    ),
    'N62': NavNode(
      id: 'N62',
      position: Offset(106, 536),
      neighbors: ['N60', 'N63', 'N61'],
    ),
    'N63': NavNode(
      id: 'N63',
      position: Offset(118, 587),
      neighbors: ['N64', 'N62'],
    ),
    'N64': NavNode(
      id: 'N64',
      position: Offset(221, 573),
      neighbors: ['N65', 'N63'],
    ),
    'N65': NavNode(
      id: 'N65',
      position: Offset(284, 558),
      neighbors: ['N66', 'N64'],
    ),
    'N66': NavNode(
      id: 'N66',
      position: Offset(280, 530),
      neighbors: ['N59', 'N65'],
    ),
  },

  // ── Room → nav node mapping ─────────────────────────────────
  // Keys MUST match the room polygon IDs defined in the rooms list above.
  // Rooms with two doors list both nodes — the router picks whichever
  // gives the shorter path automatically.
  roomToNode: const {
    // Staircases & elevators
    'stair_west':    ['N_stairW'],
    'elevator_west': ['N_elevW'],
    'stair_lobby':   ['N_stairLobby'],
    'stair_east':    ['N_stairE'],
    'elevator_east': ['N_elevE'],

    // North row
    '347':        ['N1', 'N2'],   // top door + hallway door
    '341':        ['N2', 'N4'],   // two doors along west wall
    '353':        ['N35', 'N36'], // two doors into main hallway
    '361':        ['N9', 'N10'],  // left door + right door
    '367':        ['N11', 'N12'], // left door + right door
    '385':        ['N15', 'N17'], // two doors
    '394':        ['N19', 'N20'], // two doors
    '393':        ['N58'],

    // Center corridor
    '342':        ['N13'],
    '356':        ['N13'],
    '362':        ['N25'],
    '367_south':  ['N25'],
    '375':        ['N16', 'N26'], // two doors
    '398':        ['N22', 'N23'], // two doors

    // 310-series
    '310A':  ['N32'],
    '310B':  ['N31'],
    '310C':  ['N30'],
    '310D':  ['N29'],
    '310E':  ['N53'],
    '310H':  ['N54'],
    '310K':  ['N55'],
    '310L':  ['N57'],
    '310M':  ['N56'],
    '310P':  ['N53'],
    '310Q':  ['N52'],
    '310S':  ['N51'],
    '310U':  ['N50'],
    '310V':  ['N30'],
    '310X':  ['N49'],
    '310Z':  ['N32'],

    // 320-series
    '320A':  ['N43'],
    '320B':  ['N46'],
    '320F':  ['N45'],
    '320J':  ['N44'],
    '320M':  ['N41'],
    '320P':  ['N65'],
    '320R':  ['N64'],
    '320S':  ['N64'],
    '320V':  ['N63'],
    '320W':  ['N61'],

    // 330-series
    '330A':  ['N60'],
    '330F':  ['N59'],
    '330G':  ['N38'],
    '330J':  ['N41'],
    '330M':  ['N42'],
    '330P':  ['N44'],
    '330R':  ['N43'],
  },
);