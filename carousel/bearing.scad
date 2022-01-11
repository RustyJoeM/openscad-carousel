include <config.scad>;
use <commons.scad>;

module _bearing_socket() {
    difference() {
        // socket body
        cylinder(h = BEARING_SHELL_THICKNESS + BEARING_HEIGHT, r = 0.5 * BEARING_OUTER_D + EASE + BEARING_SHELL_THICKNESS, $fn = CYL_FN);
        // bearing slot
        translate([0, 0, BEARING_SHELL_THICKNESS])
        cylinder(h = BEARING_HEIGHT + EASE, d = BEARING_OUTER_D + EASE, $fn = CYL_FN);
    }
}

// // bearing socket
// assert(BASE_FLOOR_THICKNESS + BEARING_HEIGHT < BASE_TOTAL_HEIGHT, "Bearing height is too big to fit into raised base");
// translate([0, 0, BASE_FLOOR_THICKNESS])
// _bearing_socket();
