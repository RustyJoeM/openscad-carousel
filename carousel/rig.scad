include <config.scad>;
use <commons.scad>;

use <bearing.scad>;
use <nut.scad>;
use <axle.scad>;

module rig_shape() {
    inner_sin = sin(360/CAROUSEL_FACE_COUNT/2);

    color(COLOR_AXLE) {
        bearing_top();
        // outer ring
        difference() {
            cylinder(h = RIG_HEIGHT, r = RIG_MAX_R);
            translate([0, 0, -0.5 * BLEED])
            cylinder(h = RIG_HEIGHT + BLEED, r = RIG_MAX_R - RIG_STR);
        }
        // iterate each face/wall spot
        dz = 0.5 * RIG_STR;
        for (i = [0 : CAROUSEL_FACE_COUNT]){
            rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1]) {
                // star-beam
                square_prism(RIG_STR, [BEARING_DIAM_OUTER/2, 0, dz], [RIG_MAX_R, 0, dz]);
                // cross-beams
                for (frac = RIG_RING_POSITIONS) {
                    ring_r = frac * RIG_MAX_R;
                    translate([ring_r, 0, 0])
                    rotate([0, 0, 180 - FACE_ANGLE/2])
                    square_prism(RIG_STR, [0, 0, dz], [2 * ring_r * inner_sin, 0, dz]);
                }
            }
        }
    }
}

// Top rotating part used to attach the carousel seats.
module printable_rig() {
    nut_floor = 1;
    dx = RIG_MAX_R - RIG_STR/2;
    color(COLOR_AXLE) {
        difference() {
            // core round shape
            rig_shape();
            // cut off space for nut holders
            for (i = [0 : CAROUSEL_FACE_COUNT]) {
                rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1])
                translate([dx, 0, -BLEED/2])
                nut(RIG_NUT_SIZE + RIG_NUT_WALL, RIG_HEIGHT + BLEED);
            }
        }
        // add nut holders
        for (i = [0 : CAROUSEL_FACE_COUNT]) {
            rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1]) {
                translate([dx, 0, 0])
                nut_ring(RIG_NUT_SIZE + RIG_NUT_WALL + BLEED, RIG_NUT_SIZE - EASE, RIG_STR);

                translate([dx, 0, RIG_STR - nut_floor])
                nut(RIG_NUT_SIZE + RIG_NUT_WALL/2, nut_floor);
            }
        }
    }
}

module mounted_rig() {
    dz = axle_ground_height_pegless() + mounted_bearing_height() + RIG_HEIGHT + EASE;
    translate([0, 0, dz])
    rotate([180, 0, 0])
    printable_rig();
}

// mounted_rig();
printable_rig();

// TODO - nut caps to keep nuts covered?
