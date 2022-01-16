include <config.scad>;

use <bearing.scad>;
use <base.scad>;

AXLE_TENON_THICKNESS = BASE_FLOOR_THICKNESS;

AXLE_HEIGHT_TOTAL = FACE_HEIGHT * FACE_HEIGHT_ROOF_START_RATIO - bearing_height_bottom();   // ground level to bearing socket top (not including bearing peg)
AXLE_HEIGHT_BASE_ABOVE = AXLE_HEIGHT_TOTAL - bearing_height_bottom();  // ground level to axle peg
AXLE_HEIGHT_BASE_BELOW = AXLE_TENON_THICKNESS + BASE_FLOOR_THICKNESS; // below ground level height -> tenon + ground floor thickness

AXLE_PEG_RAD = 0.5 * AXLE_RADIUS;
AXLE_PEG_HEIGHT = BEARING_HEIGHT_BOTTOM + BEARING_SHELL_BOTTOM;

tenon = base_tenon_radius();

function axle_ground_height_pegless() = (AXLE_HEIGHT_BASE_ABOVE);

module printable_axle_base() {
    height = AXLE_HEIGHT_BASE_BELOW + AXLE_HEIGHT_BASE_ABOVE;

    color(COLOR_STRUTS) {
        cylinder(h = height, r = AXLE_RADIUS);

        translate([0, 0, height - BLEED])
        cylinder(h = AXLE_PEG_HEIGHT + BLEED, r = AXLE_PEG_RAD);

        cylinder(h = AXLE_TENON_THICKNESS, r = tenon);
    }
}

module printable_axle_bearing() {
    color(COLOR_AXLE)
    difference() {
        bearing_bottom();
        translate([0, 0, -BLEED])
        cylinder(h = AXLE_PEG_HEIGHT + BLEED + EASE, r = AXLE_PEG_RAD + EASE);
    }
}

module mounted_axle(with_bearing = true) {
    translate([0, 0, -AXLE_HEIGHT_BASE_BELOW])
    printable_axle_base();

    if (with_bearing) {
        translate([0, 0, AXLE_HEIGHT_BASE_ABOVE])
        printable_axle_bearing();
    }
}

AXLE_BODY_PEG_SIZE = [0.5 * AXLE_RADIUS, 0.5 * AXLE_RADIUS, 1.5 * AXLE_RADIUS];

module axle_body_half() {
    peg_heights = [0.05, 0.45, 0.85];

    peg = AXLE_BODY_PEG_SIZE;

    translate([-(AXLE_HEIGHT_BASE_BELOW + AXLE_HEIGHT_BASE_ABOVE + peg.z)/2, 0, 0])
    rotate([0, 90, 0])
    color(COLOR_AXLE)
    difference() {
        printable_axle_base();
        translate([0, -tenon - BLEED/2, -BLEED/2])
        cube([tenon + BLEED, 2 * (tenon + BLEED), AXLE_HEIGHT_BASE_BELOW + AXLE_HEIGHT_BASE_ABOVE + peg.z + BLEED]);
        for (fz = peg_heights) {
            translate([-peg.x, -peg.y/2, fz * (AXLE_HEIGHT_BASE_BELOW + AXLE_HEIGHT_BASE_ABOVE)])
            cube([peg.x + EASE, peg.y + EASE, peg.z + EASE]);
        }
    }
}

module axle_peg() {
    peg = AXLE_BODY_PEG_SIZE;
    x = peg.z;
    y = peg.y * 2;
    z = peg.x;

    color(COLOR_AXLE)
    cube([x, y, z], center = true);
}

module printable_axle_bom() {
    dy = tenon;

    translate([0, dy, 0])
    axle_body_half();

    translate([0, -dy, 0])
    rotate([0, 0, 180])
    axle_body_half();


    peg = AXLE_BODY_PEG_SIZE;
    dx = peg.x;
    translate([0, 0, peg.x/2]) {
        translate([-5 * dx, 0, 0]) axle_peg();
        translate([0, 0, 0]) axle_peg();
        translate([+5 * dx, 0, 0]) axle_peg();
    }
}

// printable_axle_bearing();
// printable_axle_base();
printable_axle_bom();
