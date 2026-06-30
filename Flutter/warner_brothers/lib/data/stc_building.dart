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
  rooms: const [], // TODO: add RoomPolygon entries
  navNodes: const {}, // TODO: add NavNode entries
  roomToNode: const {}, // TODO: map room ids to nav node ids
);

// ── Floor 2 ───────────────────────────────────────────────────
// Polygons and nav nodes to be added.
final FloorData _floor2 = FloorData(
  floorNumber: 2,
  name: 'Floor 2',
  imagePath: 'assets/images/stc/floor_map/stc_floor_2.png',
  rooms: const [],
  navNodes: const {},
  roomToNode: const {},
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
    // ── Mapped nodes ───────────────────────────────────────
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

    // ── TODO: north row ────────────────────────────────────
    // TODO: add node for 385  (upper right, ~Offset(808, 125))
    // TODO: add node for 394  (upper right, ~Offset(916, 125))
    // TODO: add node for 393  (far right,   ~Offset(1031, 145))

    // ── TODO: center / south corridor ─────────────────────
    // TODO: add node for 356        (~Offset(463, 253))
    // TODO: add node for 362        (~Offset(548, 250))
    // TODO: add node for 367_south  (~Offset(613, 245))
    // TODO: add node for 375        (~Offset(806, 243))
    // TODO: add node for 398        (~Offset(916, 245))

    // ── TODO: 310-series ──────────────────────────────────
    // TODO: add node for 310A  (~Offset(773, 398))
    // TODO: add node for 310B  (~Offset(821, 411))
    // TODO: add node for 310C  (~Offset(869, 424))
    // TODO: add node for 310D  (~Offset(916, 435))
    // TODO: add node for 310E  (~Offset(984, 456))
    // TODO: add node for 310H  (~Offset(1089, 486))
    // TODO: add node for 310K  (~Offset(1158, 505))
    // TODO: add node for 310L  (~Offset(1126, 588))
    // TODO: add node for 310M  (~Offset(1070, 600))
    // TODO: add node for 310P  (~Offset(1013, 529))
    // TODO: add node for 310Q  (~Offset(987, 580))
    // TODO: add node for 310S  (~Offset(932, 570))
    // TODO: add node for 310U  (~Offset(879, 552))
    // TODO: add node for 310V  (~Offset(868, 489))
    // TODO: add node for 310X  (~Offset(796, 530))
    // TODO: add node for 310Z  (~Offset(784, 468))

    // ── TODO: 320-series ──────────────────────────────────
    // TODO: add node for 320A  (~Offset(641, 427))
    // TODO: add node for 320B  (~Offset(707, 513))
    // TODO: add node for 320F  (~Offset(600, 533))
    // TODO: add node for 320J  (~Offset(529, 545))
    // TODO: add node for 320M  (~Offset(423, 563))
    // TODO: add node for 320P  (~Offset(328, 567))
    // TODO: add node for 320R  (~Offset(243, 537))
    // TODO: add node for 320S  (~Offset(227, 600))
    // TODO: add node for 320V  (~Offset(120, 618))
    // TODO: add node for 320W  (~Offset(59, 509))

    // ── TODO: 330-series ──────────────────────────────────
    // TODO: add node for 330A  (~Offset(170, 490))
    // TODO: add node for 330F  (~Offset(277, 470))
    // TODO: add node for 330G  (~Offset(362, 455))
    // TODO: add node for 330J  (~Offset(441, 500))
    // TODO: add node for 330M  (~Offset(470, 435))
    // TODO: add node for 330P  (~Offset(525, 486))
    // TODO: add node for 330R  (~Offset(576, 417))
  },

  // ── Building outline ────────────────────────────────────────
  buildingOutline: const [
    Offset( 164,  28),
    Offset( 163, 309),
    Offset( 184, 310),
    Offset( 187, 461),
    Offset(  28, 490),
    Offset(  59, 656),
    Offset( 734, 535),
    Offset( 730, 526),
    Offset( 893, 576),
    Offset( 889, 584),
    Offset( 956, 604),
    Offset( 959, 596),
    Offset(1142, 643),
    Offset(1183, 486),
    Offset(1011, 437),
    Offset(1010, 307),
    Offset(1057, 308),
    Offset(1057,  30),
  ],

  // ── Room → nav node mapping ─────────────────────────────────
  // Keys are room numbers only (no building prefix).
  // TODO: add entries for all rooms once nav nodes are placed above.
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
