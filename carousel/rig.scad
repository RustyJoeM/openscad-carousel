include <carousel-config.scad>;
use <commons.scad>;

// Top rotating part used to attach the carousel seats.
module carousel_rig() {
    inner_sin = sin(360/CAROUSEL_FACE_COUNT/2);

    color(COLOR_AXLE) {
        // core ring
        difference() {
            cylinder(h = RIG_HEIGHT, r = 0.1 * RIG_MAX_R);
            translate([0, 0, -0.5 * BLEED])
            cylinder(h = RIG_HEIGHT + BLEED, r = AXLE_RADIUS + EASE);
        }
        // outer ring
        difference() {
            cylinder(h = RIG_HEIGHT, r = RIG_MAX_R);
            translate([0, 0, -0.5 * BLEED])
            cylinder(h = RIG_HEIGHT + BLEED, r = 0.95 * RIG_MAX_R);
        }
        // iterate each face/wall spot
        dz = 0.5 * RIG_STR;
        for (i = [0 : CAROUSEL_FACE_COUNT]){
            rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1]) {
                // star-beam
                square_prism(RIG_STR, [0.05 * RIG_MAX_R, 0, dz], [RIG_MAX_R, 0, dz]);
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

carousel_rig();