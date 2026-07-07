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
    // East staircase (floor 3 N71 ↔ floor 2 N73)
    CrossFloorLink(fromFloor: 3, fromNodeId: 'N71', toFloor: 2, toNodeId: 'N73'),
    CrossFloorLink(fromFloor: 2, fromNodeId: 'N73', toFloor: 3, toNodeId: 'N71'),

    // West/south staircase (floor 3 N77 ↔ floor 2 N76)
    CrossFloorLink(fromFloor: 3, fromNodeId: 'N77', toFloor: 2, toNodeId: 'N76'),
    CrossFloorLink(fromFloor: 2, fromNodeId: 'N76', toFloor: 3, toNodeId: 'N77'),

    // East elevator (floor 3 N81 ↔ floor 2 N79)
    CrossFloorLink(fromFloor: 3, fromNodeId: 'N81', toFloor: 2, toNodeId: 'N79'),
    CrossFloorLink(fromFloor: 2, fromNodeId: 'N79', toFloor: 3, toNodeId: 'N81'),

    // West/south elevator (floor 3 N83 ↔ floor 2 N82)
    CrossFloorLink(fromFloor: 3, fromNodeId: 'N83', toFloor: 2, toNodeId: 'N82'),
    CrossFloorLink(fromFloor: 2, fromNodeId: 'N82', toFloor: 3, toNodeId: 'N83'),

    // West staircase (floor 2 N76 ↔ floor 1 F1_stairW)
    CrossFloorLink(fromFloor: 2, fromNodeId: 'N76',       toFloor: 1, toNodeId: 'F1_stairW'),
    CrossFloorLink(fromFloor: 1, fromNodeId: 'F1_stairW', toFloor: 2, toNodeId: 'N76'),

    // West elevator (floor 2 N82 ↔ floor 1 F1_elevW)
    CrossFloorLink(fromFloor: 2, fromNodeId: 'N82',      toFloor: 1, toNodeId: 'F1_elevW'),
    CrossFloorLink(fromFloor: 1, fromNodeId: 'F1_elevW', toFloor: 2, toNodeId: 'N82'),
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
  rooms: const [
    RoomPolygon(id: 'elev_west',      name: 'West Elevator',       type: AreaType.elevator,  pixels: [
      Offset(67, 669), Offset(75, 712), Offset(98, 707), Offset(92, 664),
    ]),
    RoomPolygon(id: 'entrance_north', name: 'North Entrance',                                pixels: [
      Offset(453, 89), Offset(454, 133), Offset(517, 131), Offset(518, 87),
    ]),
    RoomPolygon(id: 'entrance_wn',    name: 'West North Entrance',                           pixels: [
      Offset(113, 624), Offset(117, 652), Offset(180, 641), Offset(172, 607),
    ]),
    RoomPolygon(id: 'entrance_ws',    name: 'West South Entrance',                           pixels: [
      Offset(138, 768), Offset(150, 808), Offset(209, 794), Offset(199, 756),
    ]),
    RoomPolygon(id: 'stair_west',     name: 'West Stairs',         type: AreaType.staircase, pixels: [
      Offset(75, 711), Offset(94, 821), Offset(146, 810), Offset(126, 700),
    ]),
    RoomPolygon(id: '141',  name: 'Room 141',  pixels: [
      Offset(408, 685), Offset(408, 757), Offset(357, 757), Offset(356, 685),
    ]),
    RoomPolygon(id: '131',  name: 'Room 131',  pixels: [
      Offset(504, 674), Offset(503, 732), Offset(543, 731), Offset(543, 674),
    ]),
    RoomPolygon(id: '129',  name: 'Room 129',  pixels: [
      Offset(583, 674), Offset(583, 722), Offset(544, 731), Offset(544, 674),
    ]),
    RoomPolygon(id: '132',  name: 'Room 132',  pixels: [
      Offset(489, 582), Offset(490, 649), Offset(545, 649), Offset(545, 581),
    ]),
    RoomPolygon(id: '151',  name: 'Room 151',  pixels: [
      Offset(244, 508), Offset(244, 649), Offset(441, 648), Offset(441, 628),
      Offset(453, 627), Offset(454, 529), Offset(442, 529), Offset(442, 508),
    ]),
    RoomPolygon(id: '155',  name: 'Room 155',  pixels: [
      Offset(245, 369), Offset(244, 508), Offset(442, 508), Offset(442, 486),
      Offset(449, 485), Offset(450, 387), Offset(441, 386), Offset(440, 365),
    ]),
    RoomPolygon(id: '159',  name: 'Room 159',  pixels: [
      Offset(246, 223), Offset(246, 366), Offset(440, 365), Offset(441, 343),
      Offset(454, 343), Offset(452, 245), Offset(441, 244), Offset(441, 223),
    ]),
    RoomPolygon(id: '161A', name: 'Room 161A', pixels: [
      Offset(245, 181), Offset(246, 222), Offset(307, 223), Offset(307, 180),
    ]),
    RoomPolygon(id: '161B', name: 'Room 161B', pixels: [
      Offset(246, 141), Offset(246, 181), Offset(306, 181), Offset(306, 139),
    ]),
    RoomPolygon(id: '161C', name: 'Room 161C', pixels: [
      Offset(245, 81), Offset(246, 138), Offset(306, 139), Offset(307, 82),
    ]),
    RoomPolygon(id: '161',  name: 'Room 161',  pixels: [
      Offset(306, 86), Offset(452, 85), Offset(453, 199), Offset(440, 198),
      Offset(441, 223), Offset(307, 223),
    ]),
    RoomPolygon(id: '148',  name: 'Room 148',  pixels: [
      Offset(501, 538), Offset(502, 581), Offset(546, 581), Offset(545, 649),
      Offset(674, 648), Offset(674, 538),
    ]),
    RoomPolygon(id: '152',  name: 'Room 152',  pixels: [
      Offset(674, 454), Offset(673, 538), Offset(516, 538), Offset(515, 517),
      Offset(502, 517), Offset(502, 456),
    ]),
    RoomPolygon(id: '108A', name: 'Room 108A', pixels: [
      Offset(621, 327), Offset(619, 455), Offset(502, 456), Offset(502, 326),
    ]),
    RoomPolygon(id: '106',  name: 'Room 106',  pixels: [
      Offset(488, 250), Offset(489, 327), Offset(545, 326), Offset(544, 249),
    ]),
    RoomPolygon(id: '108',  name: 'Room 108',  pixels: [
      Offset(545, 249), Offset(546, 325), Offset(591, 326), Offset(591, 249),
    ]),
    RoomPolygon(id: '110',  name: 'Room 110',  pixels: [
      Offset(591, 248), Offset(592, 327), Offset(632, 327), Offset(633, 249),
    ]),
    RoomPolygon(id: '116',  name: 'Room 116',  pixels: [
      Offset(622, 328), Offset(620, 417), Offset(672, 417), Offset(673, 326),
    ]),
    RoomPolygon(id: '104',  name: 'Room 104',  pixels: [
      Offset(503, 133), Offset(501, 223), Offset(674, 224), Offset(674, 131),
    ]),
    RoomPolygon(id: '104A', name: 'Room 104A', pixels: [
      Offset(518, 87), Offset(518, 133), Offset(610, 130), Offset(610, 87),
    ]),
    RoomPolygon(id: '104B', name: 'Room 104B', pixels: [
      Offset(611, 81), Offset(611, 131), Offset(670, 131), Offset(669, 80),
    ]),
    RoomPolygon(id: '101',  name: 'Room 101',  pixels: [
      Offset(711, 80), Offset(712, 99), Offset(765, 99), Offset(765, 81),
    ]),
    RoomPolygon(id: '101A', name: 'Room 101A', pixels: [
      Offset(712, 102), Offset(765, 102), Offset(764, 131), Offset(711, 130),
    ]),
    RoomPolygon(id: '103',  name: 'Room 103',  pixels: [
      Offset(708, 134), Offset(766, 135), Offset(766, 177), Offset(708, 177),
    ]),
    RoomPolygon(id: '125',  name: 'Room 125',  pixels: [
      Offset(788, 537), Offset(788, 654), Offset(709, 669), Offset(710, 538),
    ]),
  ],
  navNodes: const {
    // Stair / elevator cross-floor nodes — neighbors filled in once hallway graph is built
    'F1_stairW': NavNode(id: 'F1_stairW', position: Offset(110, 760), neighbors: []),
    'F1_elevW':  NavNode(id: 'F1_elevW',  position: Offset(83,  688), neighbors: []),
  },
  roomToNode: const <String, List<String>>{},
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
    'N73':  NavNode(id: 'N73',  position: Offset(1253, 396), neighbors: ['N92']),
    'N74':  NavNode(id: 'N74',  position: Offset(1045, 466), neighbors: ['N138', 'N146', 'N91']),
    'N75':  NavNode(id: 'N75',  position: Offset(975,  464), neighbors: []),
    'N76':  NavNode(id: 'N76',  position: Offset(106,  800), neighbors: ['N84']),
    'N79':  NavNode(id: 'N79',  position: Offset(1255, 310), neighbors: ['N93']),
    'N80':  NavNode(id: 'N80',  position: Offset(1374, 421), neighbors: []),
    'N82':  NavNode(id: 'N82',  position: Offset(78,   727), neighbors: ['N85']),
    'N84':  NavNode(id: 'N84',  position: Offset(147,  792), neighbors: ['N76', 'N85']),
    'N85':  NavNode(id: 'N85',  position: Offset(128,  720), neighbors: ['N84', 'N86', 'N82']),
    'N86':  NavNode(id: 'N86',  position: Offset(122,  688), neighbors: ['N85', 'N87']),
    'N87':  NavNode(id: 'N87',  position: Offset(153,  685), neighbors: ['N86', 'N90']),
    'N88':  NavNode(id: 'N88',  position: Offset(350,  649), neighbors: ['N90', 'N133']),
    'N89':  NavNode(id: 'N89',  position: Offset(376,  646), neighbors: ['N90', 'N133']),
    'N90':  NavNode(id: 'N90',  position: Offset(294,  656), neighbors: ['N87', 'N88', 'N89', 'N117', 'N133']),
    'N91':  NavNode(id: 'N91',  position: Offset(1206, 462), neighbors: ['N74', 'N138', 'N147', 'N92']),
    'N92':  NavNode(id: 'N92',  position: Offset(1207, 394), neighbors: ['N91', 'N73', 'N93']),
    'N93':  NavNode(id: 'N93',  position: Offset(1211, 312), neighbors: ['N92', 'N79', 'N94']),
    'N94':  NavNode(id: 'N94',  position: Offset(1208, 270), neighbors: ['N93', 'N95']),
    'N95':  NavNode(id: 'N95',  position: Offset(1176, 273), neighbors: ['N94', 'N96', 'N97', 'N98']),
    'N96':  NavNode(id: 'N96',  position: Offset(1175, 245), neighbors: ['N95']),
    'N97':  NavNode(id: 'N97',  position: Offset(1180, 300), neighbors: ['N95']),
    'N98':  NavNode(id: 'N98',  position: Offset(1069, 276), neighbors: ['N95', 'N99']),
    'N99':  NavNode(id: 'N99',  position: Offset(986,  276), neighbors: ['N98', 'N100']),
    'N100': NavNode(id: 'N100', position: Offset(939,  276), neighbors: ['N99', 'N101']),
    'N101': NavNode(id: 'N101', position: Offset(920,  276), neighbors: ['N100', 'N102']),
    'N102': NavNode(id: 'N102', position: Offset(900,  276), neighbors: ['N101', 'N103', 'N149']),
    'N103': NavNode(id: 'N103', position: Offset(837,  274), neighbors: ['N102', 'N104']),
    'N104': NavNode(id: 'N104', position: Offset(715,  275), neighbors: ['N103', 'N105', 'N148']),
    'N105': NavNode(id: 'N105', position: Offset(684,  273), neighbors: ['N104', 'N106']),
    'N106': NavNode(id: 'N106', position: Offset(654,  275), neighbors: ['N105', 'N121']),
    'N107': NavNode(id: 'N107', position: Offset(591,  275), neighbors: ['N121', 'N108']),
    'N108': NavNode(id: 'N108', position: Offset(563,  276), neighbors: ['N107', 'N120']),
    'N109': NavNode(id: 'N109', position: Offset(442,  273), neighbors: ['N120', 'N119']),
    'N110': NavNode(id: 'N110', position: Offset(391,  274), neighbors: ['N119', 'N111']),
    'N111': NavNode(id: 'N111', position: Offset(356,  275), neighbors: ['N110', 'N118']),
    'N112': NavNode(id: 'N112', position: Offset(331,  276), neighbors: ['N118', 'N114']),
    'N113': NavNode(id: 'N113', position: Offset(227,  273), neighbors: ['N114']),
    'N114': NavNode(id: 'N114', position: Offset(286,  275), neighbors: ['N112', 'N113', 'N115']),
    'N115': NavNode(id: 'N115', position: Offset(286,  310), neighbors: ['N114', 'N116']),
    'N116': NavNode(id: 'N116', position: Offset(286,  339), neighbors: ['N117', 'N115']),
    'N117': NavNode(id: 'N117', position: Offset(287,  431), neighbors: ['N90', 'N116', 'N133']),
    'N118': NavNode(id: 'N118', position: Offset(343,  277), neighbors: ['N111', 'N112']),
    'N119': NavNode(id: 'N119', position: Offset(415,  278), neighbors: ['N109', 'N110']),
    'N120': NavNode(id: 'N120', position: Offset(524,  278), neighbors: ['N108', 'N109']),
    'N121': NavNode(id: 'N121', position: Offset(628,  279), neighbors: ['N106', 'N107']),
    'N122': NavNode(id: 'N122', position: Offset(487,  627), neighbors: ['N125']),
    'N123': NavNode(id: 'N123', position: Offset(668,  592), neighbors: ['N126']),
    'N124': NavNode(id: 'N124', position: Offset(701,  586), neighbors: ['N127']),
    'N125': NavNode(id: 'N125', position: Offset(473,  572), neighbors: ['N128', 'N122', 'N134', 'N129']),
    'N126': NavNode(id: 'N126', position: Offset(657,  540), neighbors: ['N131', 'N123', 'N127', 'N136', 'N135']),
    'N127': NavNode(id: 'N127', position: Offset(689,  532), neighbors: ['N124', 'N126', 'N132', 'N136', 'N135', 'N148']),
    'N128': NavNode(id: 'N128', position: Offset(424,  582), neighbors: ['N133', 'N134', 'N125']),
    'N129': NavNode(id: 'N129', position: Offset(526,  563), neighbors: ['N125', 'N130', 'N135', 'N134']),
    'N130': NavNode(id: 'N130', position: Offset(574,  558), neighbors: ['N129', 'N131', 'N135', 'N134']),
    'N131': NavNode(id: 'N131', position: Offset(620,  546), neighbors: ['N130', 'N126', 'N135', 'N134']),
    'N132': NavNode(id: 'N132', position: Offset(724,  530), neighbors: ['N127', 'N136', 'N135', 'N144']),
    'N133': NavNode(id: 'N133', position: Offset(345,  527), neighbors: ['N88', 'N89', 'N90', 'N134', 'N128', 'N117']),
    'N134': NavNode(id: 'N134', position: Offset(482,  512), neighbors: ['N133', 'N128', 'N125', 'N135', 'N129', 'N130', 'N131']),
    'N135': NavNode(id: 'N135', position: Offset(629,  496), neighbors: ['N134', 'N136', 'N132', 'N127', 'N126', 'N131', 'N130', 'N129', 'N148']),
    'N136': NavNode(id: 'N136', position: Offset(734,  486), neighbors: ['N135', 'N132', 'N127', 'N126', 'N144', 'N148', 'N149', 'N150']),
    'N137': NavNode(id: 'N137', position: Offset(966,  503), neighbors: ['N141', 'N144', 'N145', 'N146', 'N150']),
    'N138': NavNode(id: 'N138', position: Offset(1125, 517), neighbors: ['N142', 'N145', 'N74', 'N146', 'N91', 'N147']),
    'N139': NavNode(id: 'N139', position: Offset(1217, 509), neighbors: ['N147']),
    'N140': NavNode(id: 'N140', position: Offset(965,  716), neighbors: ['N141']),
    'N141': NavNode(id: 'N141', position: Offset(988,  627), neighbors: ['N140', 'N144', 'N145', 'N137']),
    'N142': NavNode(id: 'N142', position: Offset(1142, 637), neighbors: ['N145', 'N143', 'N138', 'N147']),
    'N143': NavNode(id: 'N143', position: Offset(1276, 673), neighbors: ['N142']),
    'N144': NavNode(id: 'N144', position: Offset(882,  533), neighbors: ['N136', 'N132', 'N145', 'N141', 'N137', 'N150']),
    'N145': NavNode(id: 'N145', position: Offset(1041, 581), neighbors: ['N144', 'N141', 'N137', 'N142', 'N138', 'N146']),
    'N146': NavNode(id: 'N146', position: Offset(1045, 514), neighbors: ['N137', 'N138', 'N74', 'N145']),
    'N147': NavNode(id: 'N147', position: Offset(1169, 509), neighbors: ['N138', 'N139', 'N91', 'N142']),
    'N148': NavNode(id: 'N148', position: Offset(707,  456), neighbors: ['N135', 'N136', 'N127', 'N104']),
    'N149': NavNode(id: 'N149', position: Offset(892,  455), neighbors: ['N136', 'N150', 'N102']),
    'N150': NavNode(id: 'N150', position: Offset(885,  495), neighbors: ['N144', 'N137', 'N136', 'N149']),
  },

  // ── Room → nav node mapping ───────────────────────────────
  roomToNode: const {
    // Staircases / elevators
    'stair_east':    ['N73'],
    'stair_lobby':   ['N75'],
    'stair_west':    ['N76'],
    'elevator_east': ['N79'],
    'elevator_west': ['N82'],
    'entrance_east': ['N139'],
    'entrance_south':['N140'],

    // North rooms
    '295':  ['N96'],
    '294':  ['N97'],
    '291':  ['N98', 'N100'],
    '290':  ['N99'],
    '285':  ['N102'],
    '275':  ['N103', 'N104'],
    '267':  ['N106'],
    '261':  ['N108', 'N109'],
    '259':  ['N110'],
    '257':  ['N111'],
    '255':  ['N112', 'N113'],
    '253':  ['N115'],
    '251':  ['N116'],
    '247':  ['N117'],
    '252':  ['N118'],
    '262':  ['N119'],
    '264':  ['N120'],
    '268':  ['N121'],

    // South rooms
    '243':  ['N87', 'N88'],
    '239':  ['N89'],
    '235':  ['N128'],
    '231':  ['N122'],
    '227':  ['N129'],
    '225':  ['N130'],
    '223':  ['N131'],
    '221':  ['N123'],
    '217':  ['N132'],
    '215':  ['N124'],
    '207':  ['N144'],
    '205':  ['N141'],
    '201':  ['N142', 'N143'],
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
      neighbors: ['N20', 'N72', 'N81'],
    ),
    'N23': NavNode(
      id: 'N23',
      position: Offset(992, 294),
      neighbors: ['N24', 'N72'],
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
      neighbors: ['N19', 'N20'],
    ),
    // ── Staircase / elevator nodes (cross-floor anchors) ─────
    'N_stairLobby': NavNode(
      id: 'N_stairLobby',
      position: Offset(803, 323),
      neighbors: ['N26', 'N27'],
    ),
    'N71': NavNode(id: 'N71', position: Offset(1030, 247), neighbors: ['N72']),
    'N72': NavNode(id: 'N72', position: Offset(995,  247), neighbors: ['N22', 'N23', 'N71']),
    'N77': NavNode(id: 'N77', position: Offset(70,   577), neighbors: ['N78']),
    'N78': NavNode(id: 'N78', position: Offset(101,  565), neighbors: ['N62', 'N63', 'N77']),
    'N81': NavNode(id: 'N81', position: Offset(1034, 198), neighbors: ['N22']),
    'N83': NavNode(id: 'N83', position: Offset(51,   543), neighbors: ['N61']),

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
      neighbors: ['N62', 'N83'],
    ),
    'N62': NavNode(
      id: 'N62',
      position: Offset(106, 536),
      neighbors: ['N60', 'N63', 'N61', 'N78'],
    ),
    'N63': NavNode(
      id: 'N63',
      position: Offset(118, 587),
      neighbors: ['N64', 'N62', 'N78'],
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
    'stair_east':    ['N71'],
    'elevator_east': ['N81'],
    'stair_west':    ['N77'],
    'elevator_west': ['N83'],
    'stair_lobby':   ['N_stairLobby'],

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