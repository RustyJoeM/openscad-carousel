include <config.scad>;

function diam_to_flats(d) = (0.5 * d * sqrt(3));
function flats_to_diam(s) = (2 * s / sqrt(3));

module nut(diam, m, center = false) {
    translate([0, 0, center ? -m/2 : 0])
    rotate(30)
    cylinder(d = diam, h = m, $fn = 6);
}

module nut_ring(diam_outer, diam_inner, m, center = false) {
    translate([0, 0, center ? -m/2 : 0])
    difference() {
        nut(diam_outer, m, center = false);
        translate([0, 0, -BLEED/2])
        nut(diam_inner, m + BLEED, center = false);
    }
}
