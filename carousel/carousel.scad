include <config.scad>;

use <base.scad>;
use <axle.scad>;
use <rig.scad>;
use <wall.scad>;

module carousel_mounted() {
    mounted_base();

    mounted_axle();

    translate([0, 0, -EASE])
    mounted_walls(true);

    mounted_rig();
}

// all-in-one model, possibly not easily printable as a whole
carousel_mounted();

// carousel_base();
// carousel_rig();
