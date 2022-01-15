include <config.scad>;
use <commons.scad>;

use <wall-column.scad>;
use <wall-core.scad>;
use <wall-struts.scad>;

// TODO - recompute so that BASE_RADIUS dictates 3d printer bed size explicitly
BASE_RADIUS = 1.05 * CAROUSEL_ESCRIBED_RADIUS; // to include/cover carousel walls

NESTING_DEPTH = 0.5 * BASE_FLOOR_THICKNESS;
// TODO nesting depth not accounted for in total height of carousel!

function base_tenon_radius() = 3 * AXLE_RADIUS;

module base_board() {
    difference() {
        // floor plate
        translate([0, 0, -BASE_FLOOR_THICKNESS])
        cylinder(h = BASE_FLOOR_THICKNESS, r = BASE_RADIUS);
        // cutoff nesting of walls/columns
        for (i = [0 : CAROUSEL_FACE_COUNT]){
            rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1])
            translate([0, -FACE_APOTHEM_LEN, 0]) {
                translate([-FACE_WIDTH/2, 0, -NESTING_DEPTH])
                mounted_column();

                translate([0, 0, -NESTING_DEPTH])
                rotate([90, 0, 0]) {
                    wall_core_trimmed_door();
                    printable_door_strut(z_centered = true, ease = 0);
                }
            }
        }
    }
}

module upside_down_base_shape() {
    color(COLOR_BASE)
    difference() {
        union() {
            rotate([180, 0, 0])
            base_board();
            edge_height = BASE_TOTAL_HEIGHT - BASE_FLOOR_THICKNESS + BLEED;
            translate([0, 0, BASE_FLOOR_THICKNESS - BLEED]) {
                // outer rim/side wall
                difference() {
                    cylinder(h = edge_height, r = BASE_RADIUS);
                    translate([0, 0, -0.5 * BLEED])
                    cylinder(h = edge_height + BLEED, r = BASE_RADIUS - BASE_WALL_THICKNESS);
                }
                // inner rim/side wall
                difference() {
                    cylinder(h = edge_height, r = base_tenon_radius() + BASE_WALL_THICKNESS + EASE);
                    translate([0, 0, -0.5 * BLEED])
                    cylinder(h = edge_height + BLEED, r = base_tenon_radius() + EASE);
                }
            }
        }
        translate([0, 0, -0.5 * BLEED])
        cylinder(h = BASE_TOTAL_HEIGHT + BLEED, r = AXLE_RADIUS + EASE);
    }
}

module printable_base() {
    upside_down_base_shape();
}

module mounted_base() {
    rotate([180, 0, 0])
    upside_down_base_shape();
}

module printable_base_segment(n = CAROUSEL_FACE_COUNT) {
    angle_offset = 360/CAROUSEL_FACE_COUNT/2;
    xx = 2 * (BASE_RADIUS + EASE);
    yy = BASE_RADIUS + 2 * EASE;
    zz = 2 * (BASE_TOTAL_HEIGHT + EASE);
    color(COLOR_BASE)
    difference() {
        rotate([0, 0, angle_offset])
            printable_base();
        translate([0, -0.5*yy, 0])
            cube([xx, yy, zz], center = true);
        rotate(360/n)
        translate([0, 0.5 * yy, 0])
            cube([xx, yy, zz], center = true);
    }
}

// printable_base_segment();
// printable_base();

mounted_base();