include <config.scad>;
use <commons.scad>;

module _bearing_socket(bearing_height, shell_height) {
    difference() {
        // socket body
        cylinder(h = shell_height + bearing_height, d = BEARING_DIAM_OUTER + EASE + 2 * BEARING_SHELL_THICKNESS);
        // bearing slot
        translate([0, 0, shell_height - BLEED])
        cylinder(h = bearing_height + shell_height + EASE, d = BEARING_DIAM_OUTER + EASE);
    }
}

module bearing_top_hole() {
    cylinder(h = BEARING_HEIGHT_TOP + EASE, d = BEARING_DIAM_OUTER + EASE);
    translate([0, 0, BEARING_HEIGHT_TOP - BLEED])
    cylinder(h = BEARING_PEG_OVERRUN + BLEED, d = BEARING_DIAM_INNER + EASE);
}

module bearing_bottom() {
    _bearing_socket(BEARING_HEIGHT_BOTTOM, BEARING_SHELL_BOTTOM);
    translate([0, 0, BEARING_SHELL_BOTTOM - BLEED])
    cylinder(h = BEARING_HEIGHT_BOTTOM + BEARING_HEIGHT_TOP + BEARING_PEG_OVERRUN + BLEED, d = BEARING_DIAM_INNER - EASE);
}

module bearing_top() {
    total_height = BEARING_HEIGHT_TOP + BEARING_SHELL_TOP;
    translate([0, 0, total_height])
    rotate([180, 0, 0])
    difference() {
        cylinder(h = total_height, d = BEARING_DIAM_OUTER + 2 * BEARING_SHELL_THICKNESS + EASE);
        translate([0, 0, -BLEED])
        bearing_top_hole();
    }
}

dx = BEARING_DIAM_OUTER/2 + BEARING_SHELL_THICKNESS + 10*EASE;
translate([-dx, 0, 0]) bearing_bottom();
translate([+dx, 0, 0]) bearing_top();
