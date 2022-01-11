use <commons.scad>;
include <wall-commons.scad>;

use <wall-commons.scad>;
use <wall-column.scad>;
use <wall-core.scad>;
use <wall-struts-pegs.scad>;

module printable_door_strut(z_centered = false, ease = EASE) {
    door_strut_thickness = FACE_THICKNESS + 2 * STRUT_OVERRUN;
    dz = (z_centered == true) ? 0 : 0.5*door_strut_thickness;

    color(COLOR_STRUTS)
    translate([0, 0, dz])
    difference() {
        door_shape(width = FACE_DOOR_WIDTH - ease, height = FACE_DOOR_HEIGHT - ease, thickness = door_strut_thickness, ground_bleed = 0);
        door_shape(width = FACE_DOOR_WIDTH - 2 * BEAM_SIZE, height = FACE_DOOR_HEIGHT - BEAM_SIZE, thickness = (door_strut_thickness + BLEED), ground_bleed = 2 * BLEED);
    }
}

module _uncut_struts() {
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
        rect_prism(BEAM_SIZE, STRUT_OVERRUN, [s[0].x, s[0].y, 0], [s[1].x, s[1].y, 0]);
    }

    // under-roof beams
    top_y = FY - 0.5 * BEAM_SIZE - EASE;
    rect_prism(BEAM_SIZE, STRUT_OVERRUN, [-FX + BLEED, top_horizontal_y + BLEED, 0], [0, top_y, 0]);
    rect_prism(BEAM_SIZE, STRUT_OVERRUN, [0, top_y, 0], [+FX - BLEED, top_horizontal_y + BLEED, 0]);
}

module _cut_struts() {
    color(COLOR_STRUTS) {
        intersection() {
            difference() {
                // move structs on top of wall core
                translate([0, 0, 0.5 * STRUT_OVERRUN])
                _uncut_struts();
                // cut off the parts inside of door area
                door_shape(width = FACE_DOOR_WIDTH + EASE, height = FACE_DOOR_HEIGHT + EASE, thickness = (FACE_THICKNESS + BLEED), ground_bleed = 5 * BLEED);
            }
            // drop any core shape overruns
            wall_core_shape();
        }
        // add pegs into wall core
        for (p = peg_points()){
            translate([p.x, p.y, STRUT_OVERRUN - BLEED])
            strut_peg(FACE_THICKNESS/2-EASE);
        }
    }
}

module printable_wall_struts_outer() {
    difference() {
        _cut_struts();
        // cut off side columns
        translate([0, 0, 0.5 * FACE_THICKNESS  + STRUT_OVERRUN])
        column_side_holes();
    }
}

// inside part of carousel wall - has shorter strut on sides to fit (not overlap segments) near column
module printable_wall_struts_inner() {
    // TODO - this should be unified with all the wall mounting chaos in some common fn?
    dy = -FACE_APOTHEM_LEN + (FACE_THICKNESS/2 + STRUT_OVERRUN + EASE);
    rotate([-90, 0, 0])
    translate([0, -dy, 0])
    difference() {
        translate([0, dy, 0])
        rotate([90, 0, 0])
        _cut_struts();
        // cut off side columns on both sides
        rotate([0, 0, -360/CAROUSEL_FACE_COUNT])
        translate([0, dy, 0])
        rotate([90, 0, 0])
        translate([0, 0, 0.5 * FACE_THICKNESS + STRUT_OVERRUN])
        column_side_holes();
        // plus cut off right side inner struts overlap
        rotate([0, 0, +360/CAROUSEL_FACE_COUNT])
        translate([-FX, dy - FACE_THICKNESS, 0])
        cube([FACE_THICKNESS + STRUT_OVERRUN, FACE_THICKNESS, FACE_HEIGHT]);
    }
}

printable_door_strut();
// printable_wall_struts_outer();
// printable_wall_struts_inner();

// TODO - address the door frame splitting the beam struts
