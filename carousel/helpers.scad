include <config.scad>;

use <lance.scad>;
use <rig.scad>;

// Auxiliary module to position child nodes into specific carousel seat slot.
//     ring_index - which ring of seats to mount to, innermost (0) to outermost
//     position_index - position/face index on the specified ring
module carousel_slotted(ring_index, position_index, elevation = EASE) {
    assert(ring_index < len(RIG_RING_POSITIONS), "Ring index too big!");
    assert(position_index < CAROUSEL_FACE_COUNT, "Position on ring is too big!");

    rotate(360/CAROUSEL_FACE_COUNT * position_index, [0, 0, 1])
    translate([lance_dx_offset(RIG_RING_POSITIONS[ring_index]), 0, 0]) {
        color(COLOR_STRUTS)
        mounted_lance();
        translate([0, 0, mounted_rig_height()])
        printable_mounting_lance_cap();
        // TODO - resolve scaling
        intersection() {
            translate([0, 0, -EASE])
            cylinder(h = 0.9 * FACE_DOOR_HEIGHT + 2 * EASE, r = CAROUSEL_INSCRIBED_RADIUS/len(RIG_RING_POSITIONS) + EASE);
            rotate([0, 0, 90])
            translate([0, 0, elevation])
            children();
        }
    }
}

// Helper to place a child nodes into odd/even spots around carousel.
module carousel_scattered() {
    for (i = [0 : len(RIG_RING_POSITIONS)-1]) {
        for (j = [0 : CAROUSEL_FACE_COUNT-1]) {
            if ((i + j) % 2) {
                carousel_slotted(i, j)
                children();
            }
        }
    }
    spot_cnt = CAROUSEL_FACE_COUNT/2 * len(RIG_RING_POSITIONS);
    echo(str("--- Total number of seat spots: ", spot_cnt));
}
