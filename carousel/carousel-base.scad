include <carousel-config.scad>;
use <carousel-commons.scad>;

BASE_RADIUS = 1.05 * CAROUSEL_ESCRIBED_RADIUS; // to include/cover carousel walls

module _bearing_socket() {
    difference() {
        // socket body
        cylinder(h = BEARING_SHELL_THICKNESS + BEARING_HEIGHT, r = 0.5 * BEARING_OUTER_D + EASE + BEARING_SHELL_THICKNESS, $fn = CYL_FN);
        // bearing slot
        translate([0, 0, BEARING_SHELL_THICKNESS])
        cylinder(h = BEARING_HEIGHT + EASE, d = BEARING_OUTER_D + EASE, $fn = CYL_FN);
    }
}

module carousel_base() {
    color("BurlyWood")
    difference() {
        union() {
            // floor plate
            cylinder(h = BASE_FLOOR_THICKNESS, r = BASE_RADIUS);
            // rim/side wall
            edge_height = BASE_TOTAL_HEIGHT - BASE_FLOOR_THICKNESS + BLEED;
            translate([0, 0, BASE_FLOOR_THICKNESS - BLEED])
            difference() {
                cylinder(h = edge_height, r = BASE_RADIUS);
                translate([0, 0, -0.5 * BLEED])
                cylinder(h = edge_height + BLEED, r = BASE_RADIUS - BASE_WALL_THICKNESS);
            }
            // bearing socket
            assert(BASE_FLOOR_THICKNESS + BEARING_HEIGHT < BASE_TOTAL_HEIGHT, "Bearing height is too big to fit into raised base");
            translate([0, 0, BASE_FLOOR_THICKNESS])
            _bearing_socket();
        }
        translate([0, 0, -0.5 * BLEED])
        cylinder(h = BASE_TOTAL_HEIGHT + BLEED, r = AXLE_RADIUS + EASE, $fn = CYL_FN);
    }
}

module base_part(n = CAROUSEL_FACE_COUNT) {
    xx = 2 * (BASE_RADIUS + EASE);
    yy = BASE_RADIUS + 2 * EASE;
    zz = 2 * (BASE_TOTAL_HEIGHT + EASE);
    difference() {
        carousel_base();
        translate([0, -0.5*yy, 0])
            cube([xx, yy, zz], center = true);
        rotate(360/n)
        translate([0, 0.5 * yy, 0])
            cube([xx, yy, zz], center = true);
    }
}

carousel_base();