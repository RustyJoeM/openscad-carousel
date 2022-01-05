include <carousel-config.scad>;

use <carousel-base.scad>;
use <carousel-axle.scad>;
use <carousel-rig.scad>;
use <carousel-wall.scad>;

module carousel_mounted() {
    rotate([0, 180, 0]) carousel_base();

    translate([0, 0, -BASE_TOTAL_HEIGHT + EASE])
        carousel_axle();

    carousel_faces();

    translate([0, 0, 1.2 * FACE_DOOR_HEIGHT])
        carousel_rig();
}

// all-in-one model, possibly not easily printable as a whole
carousel_mounted();

// or standalone part(s) positioned on base plane for easier printing
// carousel_base();
// carousel_rig();
