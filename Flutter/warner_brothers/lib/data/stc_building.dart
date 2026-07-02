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
);

// ── Floor 1 ───────────────────────────────────────────────────
// Polygons and nav nodes to be added.
final FloorData _floor1 = FloorData(
  floorNumber: 1,
  name: 'Floor 1',
  imagePath: 'assets/images/stc_floor_1.png',
  rooms: const [],
  navNodes: const {},
  roomToNode: const <String, List<String>>{}, // TODO: add entries
);

// ── Floor 2 ───────────────────────────────────────────────────
final FloorData _floor2 = FloorData(
  floorNumber: 2,
  name: 'Floor 2',
  imagePath: 'assets/images/stc/floor_map/stc_floor_2.png',
  rooms: const [],
  navNodes: const {},
  roomToNode: const <String, List<String>>{}, // TODO: add entries
);

// ── Floor 3 ───────────────────────────────────────────────────
final FloorData _floor3 = FloorData(
  floorNumber: 3,
  name: 'Floor 3',
  imagePath: 'assets/images/stc/floor_map/stc_3.png',

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
      neighbors: ['N20', 'N23'],
    ),
    'N23': NavNode(
      id: 'N23',
      position: Offset(992, 294),
      neighbors: ['N22', 'N24'],
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
      neighbors: ['N16', 'N27'],
    ),
    'N27': NavNode(
      id: 'N27',
      position: Offset(728, 390),
      neighbors: ['N26', 'N28'],
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
      neighbors: ['N62'],
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