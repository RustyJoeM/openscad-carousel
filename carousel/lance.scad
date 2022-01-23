include <config.scad>;

use <rig.scad>;

LANCE_DIAM = 2;
LANCE_FN = 8;

COLOR_LANCE = COLOR_BASE;

module _half_sphere_top(d, with_bottom_bleed = true) {
    difference() {
        sphere(d = d);
        z_fix = with_bottom_bleed ? BLEED : 0;
        translate([0, 0, -(d/2 + BLEED)/2 - z_fix])
        cube([d + BLEED, d + BLEED, d/2 + BLEED], center = true);
    }
}

module printable_mounting_lance_cap() {
    cap_diam = 2.5 * LANCE_DIAM;
    cap_straight_height = cap_diam/4;
    color(COLOR_LANCE)
    difference() {
        union() {
            translate([0, 0, cap_straight_height]) _half_sphere_top(cap_diam);
            cylinder(h = cap_straight_height, d = cap_diam);
        }
        // hole for lance
        translate([0, 0, -BLEED])
        cylinder(d = LANCE_DIAM + EASE, h = cap_straight_height + BLEED, $fn = LANCE_FN);
    }
}

module mounted_lance(with_ease = false) {
    height = mounted_rig_height();
    extra_ease = with_ease ? EASE : 0;

    color(COLOR_LANCE)
    cylinder(d = LANCE_DIAM + extra_ease, h = height, $fn = LANCE_FN);
}

module printable_lance() {
    rotate([0, 90, 0])
    translate([-LANCE_DIAM/2, 0, 0])
    rotate([0, 0, 180/LANCE_FN])
    mounted_lance();
}

module mounting_lance_carve() {
    difference() {
        children();
        mounted_lance();
    }
}

// printable_lance();
printable_mounting_lance_cap();
