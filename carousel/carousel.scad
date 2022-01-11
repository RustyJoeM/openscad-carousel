include <config.scad>;

use <base.scad>;
use <axle.scad>;
use <rig.scad>;
use <wall.scad>;

module carousel_mounted() {
    mounted_base();

    // translate([0, 0, -BASE_TOTAL_HEIGHT + EASE])
    // carousel_axle();

    mounted_walls();

    // translate([0, 0, 1.2 * FACE_DOOR_HEIGHT])
    // carousel_rig();
}

// all-in-one model, possibly not easily printable as a whole
carousel_mounted();

// carousel_base();
// carousel_rig();
