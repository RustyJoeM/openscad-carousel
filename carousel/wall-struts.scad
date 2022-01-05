use <carousel-commons.scad>;
include <wall-commons.scad>;

use <wall-commons.scad>;
use <wall-column.scad>;
use <wall-struts-pegs.scad>;

module carousel_door_strut(z_centered = true) {
    door_strut_thickness = FACE_THICKNESS + 2 * STRUT_OVERRUN;
    dz = (z_centered == true) ? 0 : 0.5*door_strut_thickness;

    color(STRUTS_COLOR)
    translate([0, 0, dz])
    difference() {
        door_shape(width = FACE_DOOR_WIDTH - EASE, height = FACE_DOOR_HEIGHT - EASE, thickness = door_strut_thickness, ground_bleed = 0);
        door_shape(width = FACE_DOOR_WIDTH - 2 * BEAM_SIZE, height = FACE_DOOR_HEIGHT - BEAM_SIZE, thickness = (door_strut_thickness + BLEED), ground_bleed = 2 * BLEED);
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
    color(STRUTS_COLOR) {
        difference() {
            // reduce square prism beams to a thinner layer placed on top of wall core
            translate([0, 0, 0.5 * STRUT_OVERRUN])
            intersection() {
                _beam_stuts_shape();
                translate([0, FACE_HEIGHT/2, 0])
                cube([FACE_WIDTH, FACE_HEIGHT, STRUT_OVERRUN], center = true);
            }
            // and cut off the parts inside of door area
            door_shape(width = FACE_DOOR_WIDTH + EASE, height = FACE_DOOR_HEIGHT + EASE, thickness = (FACE_THICKNESS + BLEED), ground_bleed = 2 * BLEED);
            // and side columns
            columns_side_holes();
        }
        // add pegs into wall core
        for (p = peg_points()){
            translate([p.x, p.y, STRUT_OVERRUN - BLEED])
            strut_peg(FACE_THICKNESS/2-EASE);
        }
    }
}

carousel_door_strut(z_centered = false);
carousel_wall_struts();

// TODO - address the door frame split of struts
