include <carousel-config.scad>;

use <base.scad>;
use <axle.scad>;
use <rig.scad>;
use <wall.scad>;

module carousel_mounted() {
    rotate([0, 180, 0])
    carousel_base();

    // translate([0, 0, -BASE_TOTAL_HEIGHT + EASE])
    // carousel_axle();

    carousel_faces_mounted();

    // translate([0, 0, 1.2 * FACE_DOOR_HEIGHT])
    // carousel_rig();
}

// all-in-one model, possibly not easily printable as a whole
carousel_mounted();

// or standalone part(s) positioned on base plane for easier printing...
// let N = number of faces/walls of carousel (configurable in carousel-config.scad)
//

// carousel_base();
// carousel_rig();
