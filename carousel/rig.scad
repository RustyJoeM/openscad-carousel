include <config.scad>;
use <commons.scad>;

use <bearing.scad>;
use <nut.scad>;
use <axle.scad>;

RIG_CAP_BLEED_HEIGHT = 2;
RIG_CAP_BLEED_DIAM = BEARING_DIAM_INNER;

module rig_shape() {
    inner_sin = sin(360/CAROUSEL_FACE_COUNT/2);

    color(COLOR_AXLE) {
        // cut out nest for top arm rotator
        difference() {
            bearing_top();
            translate([0, 0, -BLEED])
            cylinder(h = RIG_CAP_BLEED_HEIGHT + BLEED, d = RIG_CAP_BLEED_DIAM + EASE);
        }
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
    dz = axle_ground_height_pegless() + bearing_height_total();
    translate([0, 0, dz])
    rotate([180, 0, 0])
    printable_rig();
}

module printable_arm_head(diam = RIG_STR, cap_width_multiplier = 2) {
    arm_height = RIG_STR;
    arm_length = 6 * AXLE_RADIUS;
    arm_width = AXLE_RADIUS;

    color(COLOR_BASE) {
        difference() {
            union() {
                cnt = 4;
                cylinder(h = arm_height, d = cap_width_multiplier * diam);
                for (i = [0 : cnt]){
                    rotate(i * 360/cnt, [0, 0, 1])
                    translate([0, -arm_width/2, 0])
                    cube([arm_length, arm_width, arm_height]);
                }
            }
            translate([0, 0, -BLEED/2])
            cylinder(h = arm_height + BLEED, d = diam + EASE);
        }
    }
}

module arm_cap(cap_width_multiplier = 2) {
    cap_diam = 1 * AXLE_RADIUS;
    cap_height =  1.5 * ROOF_HEIGHT;

    color(COLOR_AXLE) {
        // base straight
        translate([0, 0, -RIG_CAP_BLEED_HEIGHT])
        cylinder(h = RIG_CAP_BLEED_HEIGHT + BLEED, d = RIG_CAP_BLEED_DIAM);
        // base chamfered
        cylinder(h = 2 * RIG_CAP_BLEED_HEIGHT, d1 = RIG_CAP_BLEED_DIAM, d2 = cap_diam - BLEED);
        // cap axle
        cylinder(h = cap_height, d = cap_diam);
        // arms guard
        translate([0, 0, ROOF_HEIGHT])
        cylinder(h = RIG_STR, d1 = cap_diam, d2 = cap_width_multiplier * RIG_STR);
    }
}

module mounted_rotator() {
    translate([0, 0, axle_ground_height_pegless() + bearing_height_total() + EASE]) {
        arm_cap();
        translate([0, 0, ROOF_HEIGHT + RIG_STR + EASE])
        printable_arm_head();
    }
}

// mounted_rig();
// mounted_rotator();
printable_rig();
// printable_arm_head();

// TODO - add caps to keep nuts covered?
