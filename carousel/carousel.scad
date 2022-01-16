include <config.scad>;

use <base.scad>;
use <axle.scad>;
use <rig.scad>;
use <wall.scad>;

module carousel_mounted() {
    mounted_base();

    mounted_axle();

    translate([0, 0, -EASE])
    mounted_walls(roof_elevated = false);

    mounted_rig();
    mounted_rotator();
}

// all-in-one model, possibly not easily printable as a whole
carousel_mounted();
