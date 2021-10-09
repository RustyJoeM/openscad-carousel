include <carousel-config.scad>;
use <carousel-commons.scad>;

FX = FACE_WIDTH/2;
FY = FACE_HEIGHT;
FF = 0.85;
BEAM_SIZE = 1.1 * FACE_THICKNESS;

_face_xy_points = [
    [FX, -BLEED],
    [FX, FY * FF],
    [0, FY],
    [-FX, FY * FF],
    [-FX, -BLEED]
];

PEG_HEIGHT = FACE_THICKNESS/2 - EASE;
PEG_DIAMETER = 0.66 * BEAM_SIZE;

// positions of the pegs connecting the wooden struts and wall core
PEG_X = FX - BEAM_SIZE;
PEG_Y1 = FACE_DOOR_HEIGHT - BEAM_SIZE/2;
PEG_Y2 = (FY + FACE_DOOR_HEIGHT)/2;
PEG_Y3 = FACE_DOOR_HEIGHT - FACE_DOOR_WIDTH/2;
PEG_POINTS = [
    [0, FY - BEAM_SIZE],
    [0, 0.5 * (PEG_Y1 + PEG_Y2)],
    [PEG_X, PEG_Y1],
    [PEG_X, PEG_Y2],
    [PEG_X, PEG_Y3],
    [-PEG_X, PEG_Y1],
    [-PEG_X, PEG_Y2],
    [-PEG_X, PEG_Y3],
];

STRUT_OVERRUN = 0.25 * FACE_THICKNESS;

module _door_shape(width, height, thickness, ground_bleed = 0) {
    radius = width/2;
    straight_height = height - radius;

    translate([0, straight_height, 0])
        cylinder(h = thickness, r = radius, center = true);
    translate([0, (straight_height - ground_bleed)/2, 0])
        cube([width, straight_height + ground_bleed, thickness], center = true);
}

module carousel_wall_core() {
    color("Gold")
    difference() {
        // inner mass/wall
        linear_extrude(FACE_THICKNESS, center = true)
        polygon(_face_xy_points);
        // door hole
        _door_shape(width = FACE_DOOR_WIDTH, height = FACE_DOOR_HEIGHT, thickness = (FACE_THICKNESS + BLEED), ground_bleed = 2 * BLEED);
        // strut joint holes
        for (p = PEG_POINTS) {
            translate([p.x, p.y, 0])
            cylinder(h = FACE_THICKNESS + BLEED, d = PEG_DIAMETER + EASE, center = true);
        }
    }
}

module carousel_door_strut() {
    door_strut_thickness = FACE_THICKNESS + 2 * STRUT_OVERRUN;
    color("SaddleBrown")
    difference() {
        _door_shape(width = FACE_DOOR_WIDTH - EASE, height = FACE_DOOR_HEIGHT - EASE, thickness = door_strut_thickness, ground_bleed = 0);
        _door_shape(width = FACE_DOOR_WIDTH - 2 * BEAM_SIZE, height = FACE_DOOR_HEIGHT - BEAM_SIZE, thickness = (door_strut_thickness + BLEED), ground_bleed = 2 * BLEED);
    }
}

module _beam_stuts_shape() {
    door_straight_part_height = FACE_DOOR_HEIGHT - FACE_DOOR_WIDTH/2;

    beam_correction = BEAM_SIZE/2;
    bottom_horizontal_y = FACE_DOOR_HEIGHT - beam_correction;
    top_horizontal_y = (FY + FACE_DOOR_HEIGHT)/2;
    vertical_x = FACE_DOOR_WIDTH/2 - beam_correction - EASE;

    // all the horizontal and/or vertical struts
    straight_struts = [
        // horizontal full widths
        [[-FX + EASE, bottom_horizontal_y], [FX - EASE, bottom_horizontal_y]],
        [[-FX + EASE, top_horizontal_y], [FX - EASE, top_horizontal_y]],
        // central vertical
        [[0, FACE_DOOR_HEIGHT], [0, FY]],
        // side verticals
        [[vertical_x, -2 * BLEED], [vertical_x, top_horizontal_y - BLEED]],
        [[-vertical_x, -2 * BLEED], [-vertical_x, top_horizontal_y - BLEED]],
        // horizontal short sides
        [[-FX + BLEED, door_straight_part_height], [-FACE_DOOR_WIDTH/2 + BLEED, door_straight_part_height]],
        [[+FX - BLEED, door_straight_part_height], [+FACE_DOOR_WIDTH/2 - BLEED, door_straight_part_height]],
    ];

    for (s = straight_struts) {
        square_prism(BEAM_SIZE, [s[0].x, s[0].y, 0], [s[1].x, s[1].y, 0]);
    }

    // under-roof beams
    top_y = FY - 0.5 * BEAM_SIZE - EASE;
    square_prism(BEAM_SIZE, [-FX + BLEED, top_horizontal_y, 0], [0, top_y, 0]);
    square_prism(BEAM_SIZE, [0, top_y, 0], [+FX - BLEED, top_horizontal_y, 0]);
}

module carousel_wall_struts() {
    color("SaddleBrown") {
        difference() {
            // reduce square prism beams to a thinner layer placed on top of wall core
            translate([0, 0, 0.5 * STRUT_OVERRUN])
            intersection() {
                _beam_stuts_shape();
                translate([0, FACE_HEIGHT/2, 0])
                cube([FACE_WIDTH, FACE_HEIGHT, STRUT_OVERRUN], center = true);
            }
            // and cut off the parts inside of door area
            _door_shape(width = FACE_DOOR_WIDTH + EASE, height = FACE_DOOR_HEIGHT + EASE, thickness = (FACE_THICKNESS + BLEED), ground_bleed = 2 * BLEED);
        }
        // add pegs into wall core
        for (p = PEG_POINTS){
            translate([p.x, p.y, STRUT_OVERRUN - BLEED])
            //cube([_STRUT_PEG_SIZE, _STRUT_PEG_SIZE, peg_height]);
            cylinder(h = PEG_HEIGHT + BLEED, d = PEG_DIAMETER);
        }
    }
}

module carousel_wall_column() {
    // translate([-FX, 0, -2*BLEED])
    cylinder(h = FF * FY + BEAM_SIZE/2, d = BEAM_SIZE);
}

module carousel_wall_mounted() {
    strut_dz = FACE_THICKNESS/2 + STRUT_OVERRUN + EASE;
    
    translate([0, 0, -strut_dz])
        carousel_wall_struts();
    
    carousel_wall_core();

    carousel_door_strut();
    
    translate([0, 0, strut_dz])
    rotate([0, 180, 0])
        carousel_wall_struts();
}

// rotate([90, 0, 0]) carousel_wall_mounted();

//     rotate([0, 0, FACE_ANGLE/2])
//     translate([0, -FACE_APOTHEM_LEN, 0])
//     {
//         //difference() {
//             wall_shape(FX, FY, FF);
//         //     translate([-FX, 0, -2*BLEED])
//         //     cylinder(h = FY + BEAM_SIZE/2, d = BEAM_SIZE + EASE);
//         //     translate([FX, 0, -2*BLEED])
//         //     cylinder(h = FY + BEAM_SIZE/2, d = BEAM_SIZE + EASE);
//         // }
//         // translate([-FX, 0, -2*BLEED])
//         // cylinder(h = FF * FY + BEAM_SIZE/2, d = BEAM_SIZE);

// module roof() {
//         // roof part
//         OH = 0.1 * FACE_APOTHEM_LEN;
//         RHR = 0.8 * FACE_APOTHEM_LEN;
//         rpts = [
//             [-FX, -OH, FF*FY],  // 0
//             [  0, -OH,    FY],  // 1
//             [+FX, -OH, FF*FY],  // 2
//             [+FX, 0, FF*FY],    // 3
//             [  0, +0.25*FACE_APOTHEM_LEN, FY],    // 4
//             [-FX, 0, FF*FY],    // 5
//             [+0.2*FX, RHR, ROOF_HEIGHT],    // 6
//             [      0, RHR, ROOF_HEIGHT],    // 7
//             [-0.2*FX, RHR, ROOF_HEIGHT],    // 8
//         ];
//         *color("PaleGreen")
//         translate([0, 0, BEAM_SIZE/2])
//         {
//             point_plate(ROOF_THICKNESS, [rpts[0], rpts[1], rpts[4], rpts[5]]);
//             point_plate(ROOF_THICKNESS, [rpts[1], rpts[2], rpts[3], rpts[4]]);
//             point_plate(ROOF_THICKNESS, [rpts[3], rpts[4], rpts[6]]);
//             point_plate(ROOF_THICKNESS, [rpts[4], rpts[5], rpts[8]]);
//             point_plate(ROOF_THICKNESS, [rpts[4], rpts[8], rpts[6]]);
//             translate([0, 0, ROOF_THICKNESS]) {
//                 square_prism(ROOF_THICKNESS, [rpts[1], rpts[4]]);
//                 square_prism(ROOF_THICKNESS, [rpts[5], rpts[8]]);
//             }
//         }
//     }
// }

module carousel_faces() {
    for (i = [0 : CAROUSEL_FACE_COUNT]){
        rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1])
        translate([0, -FACE_APOTHEM_LEN, 0])
        rotate([90, 0, 0])
            carousel_wall_mounted();
    }
}
